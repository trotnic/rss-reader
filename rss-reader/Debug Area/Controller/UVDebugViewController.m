//
//  UVDebugViewController.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 23.02.2021.
//

#import "UVDebugViewController.h"

#import "UIImage+AppIcons.h"

@interface UVDebugViewController ()

@property (nonatomic, strong) UIButton *noNetworkNotificationButton;

@end

@implementation UVDebugViewController

// MARK: - Lazy Properties

- (UIButton *)noNetworkNotificationButton {
    if (!_noNetworkNotificationButton) {
        _noNetworkNotificationButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
        [_noNetworkNotificationButton setImage:UIImage.plusIcon forState:UIControlStateNormal];
        [_noNetworkNotificationButton addTarget:self action:@selector(sendNoNetworkNotification) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noNetworkNotificationButton;
}

// MARK: -

- (void)sendNoNetworkNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"kNetworkReachabilityChangedNotification" object: @{
        @"isConnectionStable" : [NSNumber numberWithBool:NO]
    }];
}

// MARK: -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.noNetworkNotificationButton];
}

@end
