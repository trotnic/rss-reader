//
//  UVNavigationController.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12.02.21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UVNavigationController : UINavigationController

@property (nonatomic, copy) void(^pushCallback)(void);
@property (nonatomic, copy) void(^popCallback)(void);

@end

NS_ASSUME_NONNULL_END
