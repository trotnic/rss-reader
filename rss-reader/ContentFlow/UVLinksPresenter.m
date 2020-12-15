//
//  UVLinksPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "UVLinksPresenter.h"
#import "UVDataRecognizer.h"
#import "NSURL+Util.h"
#import "UVSourceManager.h"

@interface UVLinksPresenter ()

@property (nonatomic, retain, readwrite) id<UVDataRecognizerType> recognizer;
@property (nonatomic, retain) RSSSource *actualSource;
@property (nonatomic, assign) id<UVLinksViewType> view;

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;

@end

@implementation UVLinksPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
{
    self = [super init];
    if (self) {
        _recognizer = [recognizer retain];
    }
    return self;
}

// MARK: - UVLinksPresenterType

- (void)updateChannelsWithPlainUrl:(NSString *)url {
    if ([NSURL isStringValid:url]) {
        __block typeof(self)weakSelf = self;
        [self.recognizer findOnURL:[NSURL URLWithString:url] withCompletion:^(RSSSource * result) {
            weakSelf.actualSource = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view updateState];
            });
        }];
    } else {
        // TODO: highlight the field || show a message
        NSLog(@"INVALID");
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

// MARK: - Lazy

- (id<UVDataRecognizerType>)recognizer {
    if(!_recognizer) {
        _recognizer = [UVDataRecognizer new];
    }
    return _recognizer;
}

- (id<UVSourceManagerType>)sourceManager {
    if(!_sourceManager) {
        _sourceManager = [UVSourceManager.defaultManager retain];
    }
    return _sourceManager;
}

@end
