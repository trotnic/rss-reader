//
//  FeedViewController.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenter.h"
#import "FeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController <FeedViewType>

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
