//
//  UIBarButtonItem+PrettiInitializable.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (PrettiInitializable)

+ (instancetype)plainItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (instancetype)fillerItem;

@end

NS_ASSUME_NONNULL_END
