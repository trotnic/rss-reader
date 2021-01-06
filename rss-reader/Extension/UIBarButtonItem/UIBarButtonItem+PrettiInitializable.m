//
//  UIBarButtonItem+PrettiInitializable.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import "UIBarButtonItem+PrettiInitializable.h"

@implementation UIBarButtonItem (PrettyInitializable)

+ (instancetype)fillerItem {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                          target:nil action:nil] autorelease];
}

@end
