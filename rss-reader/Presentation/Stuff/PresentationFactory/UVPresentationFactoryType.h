//
//  UVPresentationFactoryType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import <UIKit/UIKit.h>
#import "UVCoordinatorType.h"
#import "UVPresentationBlocks.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVPresentationFactoryType <NSObject>

- (UIViewController *)presentationBlockOfType:(PresentationBlockType)type
                                  coordinator:(id<UVCoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
