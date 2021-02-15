//
//  UVChannelSourceListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVChannelSourceListPresenter.h"
#import "NSArray+Util.h"

@interface UVChannelSourceListPresenter ()

@end

@implementation UVChannelSourceListPresenter

@synthesize viewDelegate;

// MARK: - UVSourcesListPresenterType

- (void)discoverAddress:(NSString *)address {
    NSError *error = nil;
    NSURL *url = [self.network validateAddress:address error:&error];
    
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

- (NSArray<id<UVRSSLinkViewModel>> *)items {
    return self.sourceManager.links;
}

- (void)selectItemAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self.sourceManager selectLink:self.sourceManager.links[index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewDelegate updatePresentation];
        });
        [self saveState];
    });
}

- (void)deleteItemAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self.sourceManager deleteLink:self.sourceManager.links[index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewDelegate updatePresentation];
        });
        [self saveState];
    });
}

- (void)searchButtonClicked {
    [self.coordinator showScreen:PresentationBlockSearch];
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
                                                completion:^(NSArray<NSDictionary *> *rawLinks, NSError *error) {
                [weakSelf insertRawLinks:rawLinks baseURL:url error:error];
            }];
        }
        if (type == UVRawContentXML) {
            [weakSelf.dataRecognizer discoverLinksFromXML:data
                                                      url:url
                                               completion:^(NSArray<NSDictionary *> *rawLinks, NSError *error) {
                [weakSelf insertRawLinks:rawLinks baseURL:url error:error];
            }];
        }
        if (type == UVRawContentUndefined || error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.viewDelegate stopSearchWithUpdate:NO];
                [weakSelf showError:RSSErrorNoRSSLinksDiscovered];
            });
        }
    }];
}

- (void)insertRawLinks:(NSArray<NSDictionary *> *)links
               baseURL:(NSURL *)url error:(NSError *)error {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewDelegate stopSearchWithUpdate:NO];
            [self showError:RSSErrorNoRSSLinksDiscovered];
        });
        return;
    }
    [self.sourceManager insertLinks:links relativeToURL:url];
    
    NSError *saveError = nil;
    [self.sourceManager saveState:&saveError];
    BOOL shouldUpdateResults = (saveError == nil);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewDelegate stopSearchWithUpdate:shouldUpdateResults];
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
