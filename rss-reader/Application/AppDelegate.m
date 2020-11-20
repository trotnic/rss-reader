//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "FeedRouter.h"

@interface AppDelegate ()

@property (nonatomic, retain) FeedRouter* router;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window = window;
    FeedRouter *router = [[FeedRouter alloc] initWithWindow:window];
    self.router = router;
    [router start];
    
    [window release];
    [router release];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_router release];
    [super dealloc];
}

@end
