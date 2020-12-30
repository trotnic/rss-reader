//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "FeedXMLParser.h"
#import "UVChannelFeedPresenter.h"
#import "UVChanngelFeedViewController.h"
#import "UVSourceManager.h"
#import "UVSourceManager.h"
#import "UVDataRecognizer.h"
#import "UVSearchViewController.h"
#import "UVSourcesListViewController.h"
#import "UVSourcesListPresenter.h"
#import "UVNetwork.h"
#import "KeyConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupComponents];
    [self setupSourcesFilePath];
    return YES;
}

// MARK: -

- (void)setupSourcesFilePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      .firstObject stringByAppendingString:kSourcesFileNameValue];
    [NSUserDefaults.standardUserDefaults setObject:path forKey:kSourcesFilePathKey];
}

- (void)setupComponents {
    UVDataRecognizer *recognizer = [[UVDataRecognizer new] autorelease];
    UVSourceManager *sourceManager = [[UVSourceManager new] autorelease];
    
    UVChannelFeedPresenter *presenter = [[UVChannelFeedPresenter alloc] initWithRecognizer:recognizer
                                                                             sourceManager:sourceManager
                                                                                   network:UVNetwork.shared];
    UVChanngelFeedViewController *controller = [[UVChanngelFeedViewController alloc] initWithPresenter:[presenter autorelease]];
    presenter.view = controller;
    
    [controller setupOnRighButtonClickAction:^{
        
        UVSourcesListPresenter *presenter = [[UVSourcesListPresenter alloc] initWithRecognizer:recognizer
                                                                                 sourceManager:sourceManager
                                                                                       network:UVNetwork.shared];
        UVSourcesListViewController *presentedController = [[UVSourcesListViewController alloc] initWithPresenter:[presenter autorelease]];
        presenter.view = [presentedController autorelease];
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
