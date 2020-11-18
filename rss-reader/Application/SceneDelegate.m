//
//  SceneDelegate.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "SceneDelegate.h"
#import "FeedViewController.h"
#import "FeedXMLParser.h"
#import "FeedRouter.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.window = window;
    [window release];
    
    FeedXMLParser *parser = [FeedXMLParser new];    
    FeedRouter *router = [FeedRouter new];
    FeedPresenter *presenter = [[FeedPresenter alloc] initWithParser:parser router:router];
    [parser release];
    [router release];
    FeedViewController *controller = [[FeedViewController alloc] initWithPresenter:presenter];
    [presenter assignView:controller];
    
    [presenter release];
    
    self.window.rootViewController = controller;
    [controller release];
    
    
    [self.window makeKeyAndVisible];
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
