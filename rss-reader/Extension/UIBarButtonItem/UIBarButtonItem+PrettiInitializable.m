//
//  UIBarButtonItem+PrettiInitializable.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import "UIBarButtonItem+PrettiInitializable.h"

@implementation UIBarButtonItem (PrettiInitializable)

+ (instancetype)plainItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action] autorelease];
}

+ (instancetype)fillerItem {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
}

@end
