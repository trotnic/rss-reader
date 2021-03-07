//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"

#import "UVSourceRepository.h"
#import "UVFeedManager.h"
#import "UVSourceManager.h"
#import "UVDataRecognizer.h"
#import "UVNetwork.h"

#import "UVNavigationController.h"
#import "UVSession.h"

#import "UVPresentationBlockFactory.h"
#import "UVAppCoordinator.h"

#import <objc/runtime.h>
#import <objc/message.h>
//#import "../Model/SourceManager/UVSourceManager.m"

//static Class UVSourceManager;

@interface AppDelegate () {
    Class UVSourceManager;
}

@property (nonatomic, strong) UVAppCoordinator *coordinator;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupComponents];
    return YES;
}

// MARK: -

- (void)setupComponents {
    UVNavigationController *controller = [UVNavigationController new];
    [self.coordinator setRootNavigationController:controller];
    [self.coordinator showScreen:PresentationBlockFeed];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}

// MARK: Lazy

- (UVPresentationBlockFactory *)factory {
    UVNetwork *network = [UVNetwork new];
    UVDataRecognizer *recognizer = [UVDataRecognizer new];
    UVSourceRepository *repository = [UVSourceRepository new];
    UVSession *session = [[UVSession alloc] initWithDefaults:NSUserDefaults.standardUserDefaults];
    
    UVSourceManager *source = [[UVSourceManager alloc] initWithSession:session repository:repository];
    UVFeedManager *feed = [[UVFeedManager alloc] initWithSession:session repository:repository];
    
    return [[UVPresentationBlockFactory alloc] initWithNetwork:network
                                                        source:source
                                                    recognizer:recognizer
                                                          feed:feed];
}

- (UVAppCoordinator *)coordinator {
    if (!_coordinator) {
        _coordinator = [[UVAppCoordinator alloc] initWithPresentationFactory:[self factory]];
    }
    return _coordinator;
}

- (UIWindow *)window {
    if(!_window) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _window;
}

@end
