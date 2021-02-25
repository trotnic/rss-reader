//
//  UIBarButtonItem+PrettiInitializable.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12/3/20.
//

#import "UIBarButtonItem+PrettiInitializable.h"

#import <objc/runtime.h>

void *kAssociationToken_action = &kAssociationToken_action;

@implementation UIBarButtonItem (PrettyInitializable)

+ (instancetype)systemItem:(UIBarButtonSystemItem)systemItem action:(void(^)(void))action {
    return [[UIBarButtonItem alloc] initWithSystemItem:systemItem action:action];
}

- (instancetype)initWithSystemItem:(UIBarButtonSystemItem)systemItem action:(void (^)(void))action {
    self = [self initWithBarButtonSystemItem:systemItem target:nil action:@selector(invoke)];
    if (self) {
        objc_setAssociatedObject(self, kAssociationToken_action, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.target = objc_getAssociatedObject(self, kAssociationToken_action);
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void (^)(void))action {
    self = [self initWithImage:image style:style target:nil action:@selector(invoke)];
    if (self) {
        objc_setAssociatedObject(self, kAssociationToken_action, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.target = objc_getAssociatedObject(self, kAssociationToken_action);
    }
    return self;
}

+ (instancetype)spacer {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                          target:nil action:nil] autorelease];
}

@end
