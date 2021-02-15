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


@interface AppDelegate ()

@property (nonatomic, strong) UVAppCoordinator *coordinator;

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
    UVSourceManager *source = [UVSourceManager new];
    UVNetwork *network = [UVNetwork new];
    UVFeedManager *feed = [UVFeedManager new];
    
    UVPresentationBlockFactory *factory = [[UVPresentationBlockFactory alloc] initWithNetwork:network
                                                                                   source:source
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
