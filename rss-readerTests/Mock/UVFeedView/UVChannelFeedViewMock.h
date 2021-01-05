//
//  UVFeedViewMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <UIKit/UIKit.h>
#import "UVChannelFeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVChannelFeedViewMock : UIViewController <UVChannelFeedViewType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, assign) BOOL isActivityShown;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSURL *presentedURL;

@end

NS_ASSUME_NONNULL_END
