//
//  FeedRouter.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RouterType.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedRouter : NSObject <RouterType>

- (instancetype)initWithWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
