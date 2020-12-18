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
#import "FeedViewController.h"
#import "UVSourceManager.h"
#import "UVSourceManager.h"
#import "UVLinksViewController.h"
#import "UVLinksPresenter.h"
#import "UVDataRecognizer.h"
#import "UVTextFieldViewController.h"
#import "UVSourceSearchViewController.h"
#import "UVSourceSearchPresenter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupAppearance];
    [NSNotificationCenter.defaultCenter addObserver:UVSourceManager.defaultManager
                                           selector:@selector(saveState)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [NSNotificationCenter.defaultCenter removeObserver:UVSourceManager.defaultManager];
}

// MARK: -

- (void)setupAppearance {
    FeedXMLParser *parser = [FeedXMLParser new];
    FeedProvider *dataProvider = [[FeedProvider alloc] initWithParser:[parser autorelease]];
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithProvider:[dataProvider autorelease]
                                                         sourceManager:UVSourceManager.defaultManager];
    FeedViewController *controller = [[FeedViewController alloc] initWithPresenter:[presenter autorelease]];
    
    [controller setupOnRighButtonClickAction:^{
        UVLinksPresenter *presenter = [[UVLinksPresenter alloc] initWithRecognizer:[[UVDataRecognizer new] autorelease]
                                                                     sourceManager:UVSourceManager.defaultManager];
        
        UVLinksViewController *presentedController = [[UVLinksViewController alloc] initWithPresenter:presenter];
        [presentedController setOnChangeButtonClickAction:^{
            UVSourceSearchPresenter *presenter = [[UVSourceSearchPresenter alloc] initWithSource:UVSourceManager.defaultManager dataRecognizer:[UVDataRecognizer new]];
            UVSourceSearchViewController *controller = [[UVSourceSearchViewController alloc] initWithPresenter:presenter];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            
            [presentedController presentViewController:navigationController animated:YES completion:nil];
        }];
        
        [controller.navigationController pushViewController:presentedController animated:YES];
    }];
    
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
