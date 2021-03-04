//
//  UIBarButtonItem+PrettiInitializable.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (PrettyInitializable)

+ (instancetype)systemItem:(UIBarButtonSystemItem)systemItem action:(void(^)(void))action;
- (instancetype)initWithSystemItem:(UIBarButtonSystemItem)systemItem action:(void(^)(void))action;
- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void(^)(void))action;
+ (instancetype)spacer;

@end

NS_ASSUME_NONNULL_END
