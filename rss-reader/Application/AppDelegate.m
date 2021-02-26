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
    NSString *sourcePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                            .firstObject stringByAppendingString:kSourcesFileNameValue];
    [NSUserDefaults.standardUserDefaults setObject:sourcePath forKey:kSourcesFilePathKey];
}

- (void)setupComponents {
    UVSourceManager = registerClass(@"UVSourceManager");
    
    // TODO: -
    UVNavigationController *controller = [UVNavigationController new];
    [self.coordinator setRootNavigationController:controller];
    [self.coordinator showScreen:PresentationBlockFeed];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}

// MARK: Lazy

- (id)source {
    
    
    if (!_source) {
        _source = [UVSourceManager new];
    }
    return _source;
}

- (UVNetwork *)network {
    return [UVNetwork new];
}

- (UVDataRecognizer *)recognizer {
    return [UVDataRecognizer new];
}

- (UVFeedManager *)feedManager {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                      .firstObject stringByAppendingString:@"/lolkek.plist"];
    UVSourceRepository *feedRepository = [[UVSourceRepository alloc] initWithPath:path];
    return [[UVFeedManager alloc] initWithRepository:feedRepository];
}

- (UVPresentationBlockFactory *)factory {
    return [[UVPresentationBlockFactory alloc] initWithNetwork:[self network]
                                                        source:self.source
                                                    recognizer:[self recognizer]
                                                          feed:[self feedManager]];
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
