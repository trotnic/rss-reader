//
//  FeedRouter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedRouter.h"
#import "FeedXMLParser.h"
#import "FeedPresenter.h"
#import "FeedProvider.h"
#import "NetworkService.h"
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
    NetworkService *network = [[NetworkService alloc] initWithSession:NSURLSession.sharedSession];
    FeedProvider *provider = [[FeedProvider alloc] initWithNetwork:network parser:parser];
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithProvider:provider router:self];
    [parser release];
    [provider release];
    [network release];

    FeedViewController *controller = [[FeedViewController alloc] initWithPresenter:presenter];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [presenter assignView:controller];
    [controller release];
    [presenter release];
    
    self.window.rootViewController = navigationController;
    [navigationController release];
    
    [self.window makeKeyAndVisible];
}

- (void)openURL:(NSURL *)url {
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%@ %@", url, success ? @" is opened" : @" isn't opened");
    }];
}

- (void)showError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedFailureReason
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
