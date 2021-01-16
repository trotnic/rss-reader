//
//  UVFeedViewMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <UIKit/UIKit.h>
#import "UVFeedViewType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVFeedViewMock : UIViewController <UVFeedViewType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, assign) BOOL isActivityShown;
@property (nonatomic, retain) NSError *error;
<<<<<<< HEAD
@property (nonatomic, retain) NSURL *presentedURL;
=======
>>>>>>> develop
@property (nonatomic, retain) id<UVFeedChannelDisplayModel> channel;

@end

NS_ASSUME_NONNULL_END
