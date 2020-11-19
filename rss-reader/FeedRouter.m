//
//  FeedRouter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedRouter.h"
#import "FeedXMLParser.h"
#import "FeedPresenter.h"
#import "FeedViewController.h"

@interface FeedRouter ()

@property (nonatomic, retain) UIWindow *window;

@end

@implementation FeedRouter

- (instancetype)initWithWindow:(UIWindow *)window
{
    self = [super init];
    if (self) {
        _window = [window retain];
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

// MARK: - RouterType

- (void)start {
    FeedXMLParser *parser = [FeedXMLParser new];
    
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithParser:parser router:self];
    [parser release];
    FeedViewController *controller = [[FeedViewController alloc] initWithPresenter:presenter];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [presenter assignView:controller];
    [presenter release];
    
    self.window.rootViewController = navigationController;
    [controller release];
    [navigationController release];
    
    [self.window makeKeyAndVisible];
}

- (void)openURL:(NSURL *)url {
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%@ %@", url, success ? @" is opened" : @" isn't opened");
    }];
}

@end
