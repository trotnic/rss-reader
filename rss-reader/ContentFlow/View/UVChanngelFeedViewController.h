//
//  FeedViewController.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <UIKit/UIKit.h>
#import "UVChannelFeedViewType.h"
#import "FeedItemWebViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedPresenterType;

@interface UVChanngelFeedViewController : UIViewController <UVChannelFeedViewType>

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter;
- (void)setupOnRighButtonClickAction:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
