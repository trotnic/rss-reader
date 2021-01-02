//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "UVFeedXMLParser.h"
#import "UVFeedProvider.h"
#import "UVFeedPresenter.h"
#import "UVFeedViewController.h"
#import "UVNetwork.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearance];
    return YES;
}

// MARK: -

- (void)setupAppearance {
    UVFeedPresenter *presenter = [[UVFeedPresenter alloc] initWithProvider:[[UVFeedProvider new] autorelease]
                                                                   network:[[UVNetwork new] autorelease]];
    UVFeedViewController *controller = [[UVFeedViewController alloc] initWithPresenter:[presenter autorelease]];
    presenter.view = controller;
    
    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    [self.window makeKeyAndVisible];
    
    [controller release];
}

// MARK: Lazy

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
    [super dealloc];
}

@end
