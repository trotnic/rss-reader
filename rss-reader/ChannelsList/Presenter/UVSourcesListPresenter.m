//
//  UVSourcesListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVSourcesListPresenter.h"
#import "NSArray+Util.h"

@interface UVSourcesListPresenter ()

@end

@implementation UVSourcesListPresenter

@synthesize view;

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
            [self.view updatePresentation];
        });
        [self saveState];
    });
}

// MARK: - Private

- (void)discoverLinks:(NSData *)data url:(NSURL *)url {
    __block typeof(self)weakSelf = self;
    [self.dataRecognizer discoverLinks:data
                            completion:^(NSArray<NSDictionary *> *rawLinks, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view stopSearchWithUpdate:NO];
                [weakSelf showError:RSSErrorNoRSSLinks];
            });
            return;
        }
        
        NSError *insertError = nil;
        [weakSelf.sourceManager insertSourceWithURL:url
                                              links:rawLinks
                                              error:&insertError];
        
        if (insertError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view stopSearchWithUpdate:NO];
                [weakSelf showError:RSSErrorNoRSSLinks];
            });
        }
        
        NSError *saveError = nil;
        [weakSelf.sourceManager saveState:&error];
        // TODO: -
        BOOL shouldUpdateResults = saveError == nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view stopSearchWithUpdate:shouldUpdateResults];
        });
    }];
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
