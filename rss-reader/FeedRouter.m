//
//  FeedRouter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import "FeedRouter.h"
#import <UIKit/UIKit.h>

@interface FeedRouter ()

@end

@implementation FeedRouter

- (void)startURL:(NSURL *)url {
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"%ul", success);
    }];
}

@end
