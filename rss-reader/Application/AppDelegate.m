//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"

#import "UVFeedManager.h"
#import "UVSourceManager.h"
#import "UVDataRecognizer.h"
#import "UVNetwork.h"

#import "KeyConstants.h"
#import "UVNavigationController.h"

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
@property (nonatomic, strong) id source;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupSourcesFilePath];
    [self setupComponents];
    return YES;
}

// MARK: -

- (void)setupSourcesFilePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      .firstObject stringByAppendingString:kSourcesFileNameValue];
    [NSUserDefaults.standardUserDefaults setObject:path forKey:kSourcesFilePathKey];
}

- (void)setupComponents {
    UVSourceManager = registerClass(@"UVSourceManager");
    UVDataRecognizer *recognizer = [UVDataRecognizer new];
    self.source = [UVSourceManager new];
    UVNetwork *network = [UVNetwork new];
    UVFeedManager *feed = [UVFeedManager new];
    
    UVPresentationBlockFactory *factory = [[UVPresentationBlockFactory alloc] initWithNetwork:network
                                                                                   source:self.source
                                                                               recognizer:recognizer
                                                                                     feed:feed];
    self.coordinator = [[UVAppCoordinator alloc] initWithPresentationFactory:factory];
    UVNavigationController *controller = [UVNavigationController new];
    [self.coordinator setRootNavigationController:controller];
    [self.coordinator showScreen:PresentationBlockFeed];
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
