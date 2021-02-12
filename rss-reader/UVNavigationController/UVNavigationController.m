//
//  UVNavigationController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 12.02.21.
//

#import "UVNavigationController.h"

@interface UVNavigationController ()

@end

@implementation UVNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if (self.pushCallback) self.pushCallback();
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.popCallback) self.popCallback();
    return [super popViewControllerAnimated:animated];
}

@end
