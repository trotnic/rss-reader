//
//  UVAppCoordinator.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import <UIKit/UIKit.h>
#import "UVPresentationFactoryType.h"
#import "UVAppCoordinatorType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVAppCoordinator : NSObject <UVAppCoordinatorType>

@property (nonatomic, retain, readonly) UINavigationController *navigationController;

- (instancetype)initWithNavigation:(UINavigationController *)navigation
                           factory:(id<UVPresentationFactoryType>)factory;

@end

NS_ASSUME_NONNULL_END
