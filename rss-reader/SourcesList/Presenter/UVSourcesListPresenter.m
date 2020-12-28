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

- (NSArray<id<RSSSourceViewModel>> *)items {
    return self.sourceManager.sources;
}

- (void)parseAddress:(NSString *)address {
    NSURL *url = [NSURL URLWithString:@"" relativeToURL:[NSURL URLWithString:address]].absoluteURL;
    
    if ([url.scheme isEqualToString:@"http"] || !url.scheme) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        comps.scheme = @"https";
        url = comps.URL;
    }
    
    NSURLComponents *urlCompsCopy = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    urlCompsCopy.path = @"";
    __block typeof(self)weakSelf = self;
    [self.network fetchDataOnURL:urlCompsCopy.URL.absoluteURL completion:^(NSData *data, NSError *error) {
        if (error) {
            [weakSelf.view presentError:[weakSelf provideErrorOfType:RSSErrorTypeBadNetwork]];
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
    [self.view presentDetailWithModel:self.sourceManager.sources[index]];
}

// MARK: - Lazy

- (id<UVNetworkManagerType>)network {
    if(!_network) {
        _network = [UVNetwork.shared retain];
    }
    return _network;
}

@end
