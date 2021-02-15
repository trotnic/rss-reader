//
//  UVChannelSearchPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import "UVChannelSearchPresenter.h"

@implementation UVChannelSearchPresenter

@synthesize viewDelegate;

- (void)searchButtonClickedWithToken:(NSString *)token {
    NSError *error = nil;
    NSURL *url = [self.network validateAddress:token error:&error];
    
    if (error || !url) {
        [self showError:RSSErrorTypeBadURL];
        return;
    }
    
    __block typeof(self)weakSelf = self;
    [self.network fetchDataFromURL:url
                        completion:^(NSData *data, NSError *error) {
        if (error) {
            [weakSelf showError:RSSErrorTypeBadURL];
            return;
        }
        [weakSelf discoverLinks:data url:url];
    }];
}

// MARK: - Private

- (void)discoverLinks:(NSData *)data url:(NSURL *)url {
    if (!data) {
        [self showError:RSSErrorTypeParsingError];
        return;
    }
    
    __block typeof(self)weakSelf = self;
    [self.dataRecognizer discoverContentType:data
                                  completion:^(UVRawContentType type, NSError *error) {
        if (type == UVRawContentHTML) {
            [weakSelf.dataRecognizer discoverLinksFromHTML:data
                                                completion:^(NSArray<NSDictionary *> *links, NSError *error) {
                [weakSelf insertRawLinks:links baseURL:url error:error];
            }];
        } else if (type == UVRawContentXML) {
            [weakSelf.dataRecognizer discoverLinksFromXML:data
                                                      url:url
                                               completion:^(NSArray<NSDictionary *> *links, NSError *error) {
                [weakSelf insertRawLinks:links baseURL:url error:error];
            }];
        } else if (type == UVRawContentUndefined || error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [weakSelf.viewDelegate stopSearchWithUpdate:NO];
                [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            });
        }
    }];
}

- (void)insertRawLinks:(NSArray<NSDictionary *> *)links
               baseURL:(NSURL *)url error:(NSError *)error {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showError:RSSErrorNoRSSLinksDiscovered];
        });
        return;
    }
    [self.sourceManager insertLinks:links relativeToURL:url];
    
    NSError *saveError = nil;
    [self.sourceManager saveState:&saveError];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.coordinator showScreen:PresentationBlockFeed];
    });
    
}

- (void)saveState {
    NSError *error = nil;
    [self.sourceManager saveState:&error];
    if(error) {
        [self.sourceManager saveState:&error];
        NSLog(@"%@", error);
    }
}

@end
