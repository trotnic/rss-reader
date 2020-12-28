//
//  UVSourcesListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVSourcesListPresenter.h"
#import "NSString+StringExtractor.h"
#import "UVNetwork.h"
#import "NSURL+Util.h"
#import "NSArray+Util.h"

@interface UVSourcesListPresenter ()

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain) id<UVDataRecognizerType> recognizer;

@property (nonatomic, retain) id<UVNetworkManagerType> network;

@end

@implementation UVSourcesListPresenter

- (instancetype)initWithSource:(id<UVSourceManagerType>)manager
                    recognizer:(id<UVDataRecognizerType>)recognizer;
{
    self = [super init];
    if (self) {
        _sourceManager = [manager retain];
        _recognizer = [recognizer retain];
    }
    return self;
}

- (void)dealloc
{
    [_sourceManager release];
    [_recognizer release];
    [_network release];
    [super dealloc];
}

// MARK: - UVSourcesListPresenterType

- (NSArray<id<RSSLinkViewModel>> *)items {
    return self.sourceManager.links;
}

- (void)parseAddress:(NSString *)address {
    NSURL *url = [NSURL URLWithString:@"" relativeToURL:[NSURL URLWithString:address]].absoluteURL;
    
    if (!url.scheme) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        comps.scheme = @"https";
        url = comps.URL;
    }
    
    __block typeof(self)weakSelf = self;
    [self.network fetchDataOnURL:url completion:^(NSData *data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view presentError:[weakSelf provideErrorOfType:RSSErrorTypeBadURL]];
            });
            return;
        }
        [weakSelf.recognizer processData:data completion:^(NSArray<RSSLink *> *links, RSSError error) {
            switch (error) {
                case RSSErrorTypeNone: {
                    RSSSource *source = [[[RSSSource alloc] initWithURL:url links:links] autorelease];
                    [weakSelf.sourceManager insertRSSSource:source];
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

- (void)selectItemWithIndex:(NSInteger)index {
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

// MARK: - Lazy

- (id<UVNetworkManagerType>)network {
    if(!_network) {
        _network = [UVNetwork.shared retain];
    }
    return _network;
}

@end
