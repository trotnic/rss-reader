//
//  UVAppCoordinator.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import "UVAppCoordinator.h"
#import <UIKit/UIKit.h>

#import "NSArray+Util.h"
#import "UVStack.h"

@interface UVAppCoordinator () <UINavigationControllerDelegate>

@property (nonatomic, strong) id<UVSessionType> session;
@property (nonatomic, strong) id<UVPresentationFactoryType> factory;

@property (nonatomic, strong) UVNavigationController *navigation;
@property (nonatomic, strong) UIApplication *application;

@property (nonatomic, strong) UVStack *presentationStack;

@end

@implementation UVAppCoordinator

- (instancetype)initWithPresentationFactory:(id<UVPresentationFactoryType>)factory session:(id<UVSessionType>)session {
    self = [super init];
    if (self) {
        _factory = factory;
        _session = session;
    }
    return self;
}

// MARK: - Lazy Properties

- (UIApplication *)application {
    if (!_application) {
        _application = UIApplication.sharedApplication;
    }
    return _application;
}

- (UVStack *)presentationStack {
    if (!_presentationStack) {
        _presentationStack = [UVStack new];
    }
    return _presentationStack;
}

// MARK: - Interface

- (void)setRootNavigationController:(UVNavigationController *)controller {
    self.navigation = controller;
    __weak typeof(self)weakSelf = self;
    self.navigation.popCallback = ^{
        id presentationBlock = [weakSelf.presentationStack pop];
        if ([presentationBlock intValue] == PresentationBlockWeb)
            weakSelf.session.shouldRestore = NO;
    };
}

- (void)start {
    [self showScreen:PresentationBlockFeed];
    if (self.session.shouldRestore) [self showScreen:PresentationBlockWeb];
}

// MARK: - UVCoordinatorType

- (void)showScreen:(PresentationBlockType)screen {
    // TODO: -
    PresentationBlockType previousScreen = [self.presentationStack.peek intValue];
    switch (previousScreen) {
        case PresentationBlockWeb:
            self.session.shouldRestore = NO;
        case PresentationBlockSearch:
            [self.navigation popViewControllerAnimated:YES];
            break;
        default:
            [self.navigation pushViewController:[self.factory presentationBlockOfType:screen coordinator:self] animated:YES];
            [self.presentationStack push:@(screen)];
    }
    if (screen == PresentationBlockWeb) self.session.shouldRestore = YES;
}

- (void)openURL:(NSURL *)url {
    if (url && [self.application canOpenURL:url]) {
        self.session.shouldRestore = NO;
        [self.application openURL:url options:@{} completionHandler:^(BOOL success){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigation popViewControllerAnimated:YES];
            });
        }];
    }
}

@end
