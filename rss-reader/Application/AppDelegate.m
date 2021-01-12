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
    UVDataRecognizer *recognizer = [UVDataRecognizer new];
    UVSourceManager *sourceManager = [UVSourceManager new];
    UVNetwork *network = [UVNetwork new];
    
    UVChannelFeedPresenter *presenter = [[UVChannelFeedPresenter alloc] initWithRecognizer:recognizer
                                                                             sourceManager:sourceManager
                                                                                   network:network];
    
    UVChannelFeedViewController *controller = [UVChannelFeedViewController new];
    presenter.viewDelegate = controller;
    controller.presenter = presenter;
    
    [controller setupOnRighButtonClickAction:^{
        
        UVSourcesListPresenter *presenter = [[UVSourcesListPresenter alloc] initWithRecognizer:recognizer
                                                                                 sourceManager:sourceManager
                                                                                       network:network];
        UVSourcesListViewController *presentedController = [UVSourcesListViewController new];
        presenter.viewDelegate = presentedController;
        presentedController.presenter = presenter;
        [controller.navigationController pushViewController:presentedController animated:YES];
    }];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
}

// MARK: Lazy

- (UIWindow *)window {
    if(!_window) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _window;
}

@end
