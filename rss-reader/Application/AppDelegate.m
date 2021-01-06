//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "UVFeedXMLParser.h"
#import "UVChannelFeedPresenter.h"
#import "UVChannelFeedViewController.h"
#import "UVSourceManager.h"
#import "UVSourceManager.h"
#import "UVDataRecognizer.h"
#import "UVSearchViewController.h"
#import "UVSourcesListViewController.h"
#import "UVSourcesListPresenter.h"
#import "UVNetwork.h"
#import "KeyConstants.h"
#import "UVFeedXMLParser.h"
#import "UVChannelFeedViewController.h"
#import "UVNetwork.h"

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
    UVNetwork *network = [[UVNetwork new] autorelease];
    
    UVChannelFeedPresenter *presenter = [[UVChannelFeedPresenter alloc] initWithRecognizer:recognizer
                                                                             sourceManager:sourceManager
                                                                                   network:network];
    
    UVChannelFeedViewController *controller = [UVChannelFeedViewController new];
    presenter.viewDelegate = controller;
    controller.presenter = [presenter autorelease];
    
    [controller setupOnRighButtonClickAction:^{
        
        UVSourcesListPresenter *presenter = [[UVSourcesListPresenter alloc] initWithRecognizer:recognizer
                                                                                 sourceManager:sourceManager
                                                                                       network:network];
        UVSourcesListViewController *controller = [UVSourcesListViewController new];
        presenter.viewDelegate = [controller autorelease];
        controller.presenter = presenter;
        [controller.navigationController pushViewController:controller animated:YES];
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
