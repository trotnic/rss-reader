//
//  UVNavigationController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12.02.21.
//

#import "UVNavigationController.h"

@implementation UVNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (self.pushCallback) self.pushCallback();
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.popCallback) self.popCallback();
    return [super popViewControllerAnimated:animated];
}

@end
