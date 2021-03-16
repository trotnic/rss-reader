//
//  AppDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "AppDelegate.h"
#import "KeyConstants.h"

#import "UVPresentationFactory.h"
#import "UVAppCoordinator.h"

#import "UVDataRecognizer.h"
#import "UVNetwork.h"
#import "UVSourceManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) UVAppCoordinator *coordinator;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupSourcesFilePath];
    self.window.rootViewController = self.coordinator.navigationController;
    [self.coordinator showPresentationBlock:UVPresentationBlockFeed];
    [self.window makeKeyAndVisible];
    return YES;
}

// MARK: -

- (void)setupSourcesFilePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      .firstObject stringByAppendingString:kSourcesFileNameValue];
    [NSUserDefaults.standardUserDefaults setObject:path forKey:kSourcesFilePathKey];
}

// MARK: Lazy

- (UVAppCoordinator *)coordinator {
    if (!_coordinator) {
        UINavigationController *navigation = [UINavigationController new];
        _coordinator = [[UVAppCoordinator alloc] initWithNavigation:navigation factory:[self factory]];
    }
    return _coordinator;
}

- (UVPresentationFactory *)factory {
    UVDataRecognizer *recognizer = [UVDataRecognizer new];
    id source = [UVSourceManager new];
    UVNetwork *network = [UVNetwork new];
    return [UVPresentationFactory factoryWithNetwork:network source:source recognizer:recognizer];
}

- (UIWindow *)window {
    if(!_window) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _window;
}

@end
