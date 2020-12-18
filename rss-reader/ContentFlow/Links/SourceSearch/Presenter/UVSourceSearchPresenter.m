//
//  UVSourceSearchPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 18.12.20.
//

#import "UVSourceSearchPresenter.h"
#import "NSURL+Util.h"
#import "NSString+StringExtractor.h"

@interface UVSourceSearchPresenter ()

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain) id<UVDataRecognizerType> recognizer;
@property (nonatomic, assign) id<UVSourceSearchViewType> view;

@end

@implementation UVSourceSearchPresenter

- (instancetype)initWithSource:(id<UVSourceManagerType>)soucre
                dataRecognizer:(id<UVDataRecognizerType>)recognizer
{
    self = [super init];
    if (self) {
        _sourceManager = [soucre retain];
        _recognizer = [recognizer retain];
    }
    return self;
}

- (void)dealloc
{
    [_sourceManager release];
    [_recognizer release];
    [super dealloc];
}

// MARK: - UVSourceSearchPresenterType

- (void)assignView:(id<UVSourceSearchViewType>)view {
    _view = view;
}

- (void)searchForAddress:(NSString *)address {
    if ([NSURL isStringValid:address]) {
        NSString *newUrl = [NSString stringWithFormat:@"https://%@", [address substringFromString:@"\\/\\/"]];
        __block typeof(self)weakSelf = self;
        [self.recognizer findOnURL:[NSURL URLWithString:newUrl] withCompletion:^(RSSSource * result) {
            [weakSelf.sourceManager setSource:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view updatePresentation];
            });
        }];
    } else {
        [self.view presentError:[self provideErrorOfType:RSSErrorTypeBadURL]];
    }
}

- (NSArray<id<RSSLinkViewModel>> *)items {
    return self.sourceManager.source.rssLinks;
}

@end
