//
//  AppCoordinator.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import <Foundation/Foundation.h>
#import "PresentationFactoryType.h"
#import "CoordinatorType.h"
#import "UVNetworkType.h"
#import "UVDataRecognizerType.h"
#import "UVSourceManagerType.h"
#import "UVNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppCoordinator : NSObject <CoordinatorType>

- (instancetype)initWithPresentationFactory:(id<PresentationFactoryType>)factory
                                    network:(id<UVNetworkType>)network
                                     source:(id<UVSourceManagerType>)source
                                 recognizer:(id<UVDataRecognizerType>)recognizer;

- (void)setRootNavigationController:(UVNavigationController *)controller;

@end

NS_ASSUME_NONNULL_END
