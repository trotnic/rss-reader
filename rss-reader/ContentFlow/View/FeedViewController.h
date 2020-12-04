//
//  FeedViewController.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <UIKit/UIKit.h>
#import "FeedViewType.h"
#import "FeedItemWebViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedPresenterType;

@interface FeedViewController : UIViewController <FeedViewType>

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
