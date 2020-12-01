//
//  FeedRouter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "RouterType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DIContainerType;

@interface FeedRouter : NSObject <RouterType>

- (instancetype)initWithWindow:(UIWindow *)window dependencies:(id<DIContainerType>)container;

@end

NS_ASSUME_NONNULL_END
