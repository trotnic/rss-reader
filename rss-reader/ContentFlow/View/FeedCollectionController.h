//
//  FeedCollectionController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/4/20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedCollectionController : UIViewController <FeedViewType>

- (instancetype)initWithPresenter:(id<FeedPresenterType>)presenter;

@end

NS_ASSUME_NONNULL_END
