//
//  UVAppCoordinator.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import "UVAppCoordinator.h"

@interface UVAppCoordinator ()

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) id<UVPresentationFactoryType> factory;

@end

@implementation UVAppCoordinator

- (instancetype)initWithNavigation:(UINavigationController *)navigation
                           factory:(id<UVPresentationFactoryType>)factory
{
    self = [super init];
    if (self) {
        _navigationController = [navigation retain];
        _factory = [factory retain];
    }
    return self;
}

- (void)dealloc
{
    [_navigationController release];
    [_factory release];
    [super dealloc];
}

// MARK: -

- (void)showPresentationBlock:(UVPresentationBlockType)block {
    switch (block) {
        case UVPresentationBlockFeed: {
            UIViewController *controller = [self.factory presentationBlockOfType:UVPresentationBlockFeed coordinator:self];
            if (self.navigationController.viewControllers.count) [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case UVPresentationBlockSources: {
            UIViewController *controller = [self.factory presentationBlockOfType:UVPresentationBlockSources coordinator:self];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
    }
}

@end
