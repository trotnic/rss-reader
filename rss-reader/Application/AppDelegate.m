//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "FeedXMLParser.h"
#import "FeedProvider.h"
#import "FeedPresenter.h"
#import "DIContainer.h"
#import "FeedViewController.h"

@interface AppDelegate ()

@property (nonatomic, retain) DIContainer *container;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureDependencies];
    self.window.rootViewController =[[[UINavigationController alloc] initWithRootViewController:[self.container resolveServiceOfType:NSStringFromClass(FeedViewController.class)]] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

// MARK: -

- (void)configureDependencies {
    [self.container registerServiceOfType:NSStringFromClass(FeedXMLParser.class)
                           withCompletion:^id (id<DIContainerType> container) {
        return [FeedXMLParser new];
    }];
    [self.container registerServiceOfType:NSStringFromClass(FeedProvider.class) withCompletion:^id (id<DIContainerType> container) {
        return [[FeedProvider alloc] initWithParser:[container resolveServiceOfType:NSStringFromClass(FeedXMLParser.class)]];
    }];
    [self.container registerServiceOfType:NSStringFromClass(FeedPresenter.class) withCompletion:^id (id<DIContainerType> container) {
        return [[FeedPresenter alloc] initWithProvider:[container resolveServiceOfType:NSStringFromClass(FeedProvider.class)]];
    }];
    [self.container registerServiceOfType:NSStringFromClass(FeedViewController.class) withCompletion:^id (id<DIContainerType> container) {
        return [[FeedViewController alloc] initWithPresenter:[container resolveServiceOfType:NSStringFromClass(FeedPresenter.class)]];
    }];
}

// MARK: Lazy

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

// MARK: -

- (void)dealloc
{
    [_window release];
    [_container release];
    [super dealloc];
}

@end
