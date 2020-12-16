//
//  UVLinksPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "UVLinksPresenter.h"
#import "NSURL+Util.h"
#import "NSString+StringExtractor.h"

@interface UVLinksPresenter ()

@property (nonatomic, retain, readwrite) id<UVDataRecognizerType> recognizer;
@property (nonatomic, retain) RSSSource *actualSource;
@property (nonatomic, assign) id<UVLinksViewType> view;

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;

@end

@implementation UVLinksPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)sourceManager
{
    self = [super init];
    if (self) {
        _recognizer = [recognizer retain];
        _sourceManager = [sourceManager retain];
    }
    return self;
}

// MARK: - UVLinksPresenterType

- (void)updateChannelsWithPlainUrl:(NSString *)url {
    if ([NSURL isStringValid:url]) {
        NSString *newUrl = [NSString stringWithFormat:@"https://%@", [url substringFromString:@"\\/\\/"]];
        
        
        __block typeof(self)weakSelf = self;
        [self.recognizer findOnURL:[NSURL URLWithString:newUrl] withCompletion:^(RSSSource * result) {
            weakSelf.actualSource = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view updatePresentation];
            });
        }];
    } else {
        [self provideErrorOfType:RSSErrorTypeBadURL withCompletion:^(NSError *resultError) {
            [self.view presentError:resultError];
        }];
    }
}

- (id<RSSSourceViewModel>)source {
    return self.actualSource;
}

- (void)assignView:(id<UVLinksViewType>)view {
    _view = view;
}

- (void)selectChannelAtIndex:(NSInteger)index {
    // TODO: save intermediate source state somewhere else
    [self.sourceManager setSource:self.actualSource];
    [self.sourceManager selectLink:self.sourceManager.source.rssLinks[index]];
}

@end
