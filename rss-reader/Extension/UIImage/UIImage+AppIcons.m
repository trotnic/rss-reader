//
//  UIImage+AppIcons.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 16.01.21.
//

#import "UIImage+AppIcons.h"
#import "AppIcons.h"

@implementation UIImage (AppIcons)

+ (UIImage *)arrowLeftIcon {
    return [UIImage imageNamed:ARROW_LEFT];
}

+ (UIImage *)arrowRightIcon {
    return [UIImage imageNamed:ARROW_RIGHT];
}

+ (UIImage *)refreshIcon {
    return [UIImage imageNamed:REFRESH];
}

+ (UIImage *)xmarkIcon {
    return [UIImage imageNamed:XMARK];
}

+ (UIImage *)safariIcon {
    return [UIImage imageNamed:SAFARI];
}

+ (UIImage *)threeDotsHIcon {
    return [UIImage imageNamed:THREE_DOTS_H];
}

+ (UIImage *)plusIcon {
    return [UIImage imageNamed:PLUS];
}

+ (UIImage *)gearIcon {
    return [UIImage imageNamed:GEAR];
}

@end
