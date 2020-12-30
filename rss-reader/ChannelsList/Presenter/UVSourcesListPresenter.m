//
//  UVSourcesListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVSourcesListPresenter.h"
#import "NSString+StringExtractor.h"
#import "UVNetwork.h"
#import "NSArray+Util.h"

@interface UVSourcesListPresenter ()

@end

@implementation UVSourcesListPresenter

// MARK: - UVSourcesListPresenterType

- (NSArray<id<RSSLinkViewModel>> *)items {
    return self.sourceManager.links;
}

- (void)discoverAddress:(NSString *)address {
    NSURL *url = [self buildURLFromAddress:address];
    
    __block typeof(self)weakSelf = self;
    [self.network fetchDataOnURL:url
                      completion:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view presentError:[weakSelf provideErrorOfType:RSSErrorTypeBadURL]];
            });
            return;
        }
        [weakSelf.dataRecognizer discoverLinks:data
                                    completion:^(NSArray<RSSLink *> *links, RSSError error) {
            switch (error) {
                case RSSErrorTypeNone: {
                    RSSSource *source = [weakSelf.sourceManager buildObjectWithURL:url links:links];
                    [weakSelf.sourceManager insertObject:source];
                    NSError *error = nil;
                    [weakSelf.sourceManager saveState:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view stopSearchWithUpdate:error == nil];
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view stopSearchWithUpdate:NO];
                        [weakSelf.view presentError:[weakSelf provideErrorOfType:error]];
                    });
                }
            }
        }];
    }];
}

- (void)selectItemAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self.sourceManager selectLink:self.sourceManager.links[index]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view updatePresentation];
        });
        NSError *error = nil;
        [self.sourceManager saveState:&error];
        if(error) {
            [self.sourceManager saveState:&error];
            NSLog(@"%@", error);
        }
    });
}

// MARK: - Private

- (NSURL *)buildURLFromAddress:(NSString *)address {
    NSURL *url = [NSURL URLWithString:@""
                        relativeToURL:[NSURL URLWithString:address]].absoluteURL;
    
    if (!url.scheme) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:url
                                            resolvingAgainstBaseURL:YES];
        comps.scheme = @"https";
        url = comps.URL;
    }
    return url;
}

@end
