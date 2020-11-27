//
//  FeedRouter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedRouter.h"
#import "FeedViewController.h"
#import "UIViewController+ErrorPresenter.h"

@protocol ErrorManagerType;

@interface FeedRouter ()

@property (nonatomic, retain, readwrite) id<ErrorManagerType> errorManager;
@property (nonatomic, retain, readwrite) UIApplication *application;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) id<DIContainerType> container;

@end

@implementation FeedRouter

- (instancetype)initWithWindow:(UIWindow *)window
                  dependencies:(id<DIContainerType>)container {
    self = [super init];
    if (self) {
        _window = [window retain];
        _container = [container retain];
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    [_container release];
    [_application release];
    [_errorManager release];
    [super dealloc];
}

// MARK: - Lazy

- (id<ErrorManagerType>)errorManager {
    if(!_errorManager) {
        _errorManager = [[self.container resolveServiceOfType:NSStringFromProtocol(@protocol(ErrorManagerType))] retain];
    }
    return _errorManager;
}

- (UIApplication *)application {
    if(!_application) {
        _application = [[self.container resolveServiceOfType:NSStringFromClass(UIApplication.class)] retain];
    }
    return _application;
}

// MARK: - RouterType

- (void)start {
    self.window.rootViewController = [[[UINavigationController alloc]
                                       initWithRootViewController:[self.container
                                                                   resolveServiceOfType:NSStringFromClass(FeedViewController.class)]] autorelease];
    [self.window makeKeyAndVisible];
}

- (void)openURL:(NSURL *)url {
    [self.application openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%@ %@", url, success ? @" is opened" : @" isn't opened");
    }];
}

- (void)showError:(RSSError)error {
    __block typeof(self)weakSelf = self;
    [self.errorManager provideErrorOfType:RSSErrorTypeBadNetwork withCompletion:^(NSError *someError) {
        [weakSelf retain];
        [weakSelf.window.rootViewController showError:someError];
        [weakSelf release];
    }];
}

- (void)showNetworkActivityIndicator:(BOOL)show {
    self.application.networkActivityIndicatorVisible = show;
}

@end
