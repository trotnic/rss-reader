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

#import "PresentationBlockFactory.h"
#import "AppCoordinator.h"
#import "UVNavigationController.h"

@interface AppDelegate ()

@property (nonatomic, strong) AppCoordinator *coordinator;

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
    PresentationBlockFactory *factory = [PresentationBlockFactory new];
    // TODO: -
    self.coordinator = [[AppCoordinator alloc] initWithPresentationFactory:factory network:network source:sourceManager recognizer:recognizer];
    UVNavigationController *controller = [UVNavigationController new];
    [self.coordinator setRootNavigationController:controller];
    [self.coordinator showScreen:TRFeed];
    // TODO: -
    self.window.rootViewController = controller;
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
