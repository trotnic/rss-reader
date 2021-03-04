//
//  UVPresentationFactoryType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import <UIKit/UIKit.h>

#import "UVAppCoordinatorType.h"
#import "UVPresentationBlock.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVPresentationFactoryType <NSObject>

- (UIViewController *)presentationBlockOfType:(UVPresentationBlockType)type coordinator:(id<UVAppCoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
