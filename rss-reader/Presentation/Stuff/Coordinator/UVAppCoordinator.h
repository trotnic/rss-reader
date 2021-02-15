//
//  UVAppCoordinator.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import <Foundation/Foundation.h>
#import "UVPresentationFactoryType.h"
#import "UVCoordinatorType.h"
#import "UVNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVAppCoordinator : NSObject <UVCoordinatorType>

- (instancetype)initWithPresentationFactory:(id<UVPresentationFactoryType>)factory;

- (void)setRootNavigationController:(UVNavigationController *)controller;

@end

NS_ASSUME_NONNULL_END
