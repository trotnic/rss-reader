//
//  FeedRouter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedRouter.h"
#import "FeedViewController.h"
#import "UIViewController+ErrorPresenter.h"

@interface FeedRouter ()

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) id<DIContainerType> container;

@end

@implementation FeedRouter

- (instancetype)initWithWindow:(UIWindow *)window
                  dependencies:(id<DIContainerType>)container {
    self = [super init];
    if (self) {
        _window = [window retain];
        _container = [container retain];
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    [_container release];
    [super dealloc];
}

// MARK: - RouterType

- (void)start {
    self.window.rootViewController = [[[UINavigationController alloc]
                                       initWithRootViewController:[self.container
                                                                   resolveServiceOfType:NSStringFromClass(FeedViewController.class)]] autorelease];    
    [self.window makeKeyAndVisible];
}

- (void)openURL:(NSURL *)url {
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%@ %@", url, success ? @" is opened" : @" isn't opened");
    }];
}

- (void)showError:(NSError *)error {
    [self.window.rootViewController showError:error];
}

@end
