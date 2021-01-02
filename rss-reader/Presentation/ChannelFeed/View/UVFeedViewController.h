//
//  UVFeedViewController.h
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import <UIKit/UIKit.h>
#import "UVFeedViewType.h"
#import "UVFeedPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedViewController : UIViewController <UVFeedViewType>

- (instancetype)initWithPresenter:(id<UVFeedPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
