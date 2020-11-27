//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "FeedRouter.h"
#import "FeedXMLParser.h"
#import "NetworkService.h"
#import "FeedProvider.h"
#import "FeedPresenter.h"
#import "DIContainer.h"
#import "FeedViewController.h"
#import "ErrorManager.h"

@interface AppDelegate ()

@property (nonatomic, retain) FeedRouter *router;
@property (nonatomic, retain) DIContainer *container;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureDependencies];
    [self.router start];
    return YES;
}

// MARK: -

- (void)configureDependencies {
    [self.container registerServiceOfType:NSStringFromClass(FeedXMLParser.class)
                           withCompletion:^id (id<DIContainerType> container) {
        return [FeedXMLParser new];
    }];
    [self.container registerServiceOfType:NSStringFromClass(NetworkService.class) withCompletion:^id (id<DIContainerType> container) {
        return [[NetworkService alloc] initWithSession:NSURLSession.sharedSession];
    }];
    [self.container registerServiceOfType:NSStringFromClass(FeedProvider.class) withCompletion:^id (id<DIContainerType> container) {
        return [[FeedProvider alloc] initWithNetwork:[container resolveServiceOfType:NSStringFromClass(NetworkService.class)]
                                              parser:[container resolveServiceOfType:NSStringFromClass(FeedXMLParser.class)]];
    }];
    [self.container registerServiceOfType:NSStringFromClass(FeedPresenter.class) withCompletion:^id (id<DIContainerType> container) {
        return [[FeedPresenter alloc] initWithProvider:[container resolveServiceOfType:NSStringFromClass(FeedProvider.class)]
                                                router:self.router];
    }];
    [self.container registerServiceOfType:NSStringFromClass(FeedViewController.class) withCompletion:^id (id<DIContainerType> container) {
        return [[FeedViewController alloc] initWithPresenter:[container resolveServiceOfType:NSStringFromClass(FeedPresenter.class)]];
    }];
    [self.container registerServiceOfType:NSStringFromClass(UIApplication.class) withCompletion:^id (id<DIContainerType> container) {
        return [UIApplication.sharedApplication retain];
    }];
    [self.container registerServiceOfType:NSStringFromProtocol(@protocol(ErrorManagerType)) withCompletion:^id (id<DIContainerType> container) {
        return [ErrorManager new];
    }];
}

// MARK: - Lazy

- (DIContainer *)container {
    if(!_container) {
        _container = [DIContainer new];
    }
    return _container;
}

- (UIWindow *)window {
    if(!_window) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _window;
}

- (FeedRouter *)router {
    if(!_router) {
        _router = [[FeedRouter alloc] initWithWindow:self.window
                                        dependencies:self.container];
    }
    return _router;
}

// MARK: -

- (void)dealloc
{
    [_window release];
    [_router release];
    [_container release];
    [super dealloc];
}

@end
