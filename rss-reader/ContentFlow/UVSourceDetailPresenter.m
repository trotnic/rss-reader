//
//  UVLinksPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "UVSourceDetailPresenter.h"
#import "NSURL+Util.h"
#import "NSString+StringExtractor.h"

@interface UVSourceDetailPresenter ()

@property (nonatomic, assign) id<UVSourceDetailViewType> view;
@property (nonatomic, copy) RSSSource *model;

@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;

@end

@implementation UVSourceDetailPresenter

- (instancetype)initWithModel:(RSSSource *)model
                sourceManager:(id<UVSourceManagerType>)sourceManager
{
    self = [super init];
    if (self) {
        _model = [model copy];
        _sourceManager = [sourceManager retain];
    }
    return self;
}

// MARK: - UVLinksPresenterType

- (id<RSSSourceViewModel>)source {
    return self.model;
}

- (void)assignView:(id<UVSourceDetailViewType>)view {
    _view = view;
}

- (void)selectChannelAtIndex:(NSInteger)index {
    for (int i = 0; i < self.model.rssLinks.count; i++) {
        self.model.rssLinks[i].selected = NO;
    }
    self.model.rssLinks[index].selected = YES;
    [self.view updateLinkAtIndex:index];
}

- (void)saveSource {
    [self.sourceManager updateRSSSource:self.model];
}

@end
