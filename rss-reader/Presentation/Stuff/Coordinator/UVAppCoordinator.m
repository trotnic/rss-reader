//
//  UVAppCoordinator.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import "UVAppCoordinator.h"
#import <UIKit/UIKit.h>

#import "NSArray+Util.h"

@interface UVAppCoordinator () <UINavigationControllerDelegate>

@property (nonatomic, strong) id<UVPresentationFactoryType> factory;

@property (nonatomic, strong) UVNavigationController *controller;
@property (nonatomic, strong) UIApplication *application;

@end

@implementation UVAppCoordinator

- (instancetype)initWithPresentationFactory:(id<UVPresentationFactoryType>)factory {
    self = [super init];
    if (self) {
        _factory = factory;
    }
    return self;
}

- (void)setRootNavigationController:(UVNavigationController *)controller {
    self.controller = controller;
}

- (void)showScreen:(PresentationBlockType)type {
    [self.controller pushViewController:[self.factory presentationBlockOfType:type coordinator:self]
                               animated:YES];
}

- (void)openURL:(NSURL *)url {
    if (url && [self.application canOpenURL:url]) {
        [self.application openURL:url options:@{} completionHandler:^(BOOL success){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.controller popViewControllerAnimated:YES];
            });
        }];
    }
}

- (void)closeCurrentScreen {
    [self.controller popViewControllerAnimated:YES];
}

// MARK: - Private

- (UIViewController *)controllerOf:(PresentationBlockType)type {
    return [self.factory presentationBlockOfType:type
                                     coordinator:self];
}

- (UIApplication *)application {
    if (!_application) {
        _application = UIApplication.sharedApplication;
    }
    return _application;
}

@end
