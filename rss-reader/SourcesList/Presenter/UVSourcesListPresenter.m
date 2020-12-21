//
//  UVSourcesListPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import "UVSourcesListPresenter.h"
#import "NSString+StringExtractor.h"
#import "NSURL+Util.h"

@interface UVSourcesListPresenter ()

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain) id<UVDataRecognizerType> recognizer;

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
    [super dealloc];
}

// MARK: - UVSourcesListPresenterType

- (NSArray<id<RSSSourceViewModel>> *)items {
    return self.sourceManager.sources;
}

- (void)parseAddress:(NSString *)address {
    if ([NSURL isStringValid:address]) {
        // TODO:
        NSString *newUrl = [NSString stringWithFormat:@"https://%@", [address substringFromString:@"\\/\\/"]];
        __block typeof(self)weakSelf = self;
        [self.recognizer findOnURL:[NSURL URLWithString:newUrl] withCompletion:^(RSSSource * result) {
            [weakSelf.sourceManager insertRSSSource:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view stopSearchWithUpdate:YES];
            });
        }];
    } else {
        [self.view presentError:[self provideErrorOfType:RSSErrorTypeBadURL]];
    }
}

- (void)selectItemWithIndex:(NSInteger)index {
    [self.view presentDetailWithModel:self.sourceManager.sources[index]];
}

@end
