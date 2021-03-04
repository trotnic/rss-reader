//
//  UVAppCoordinatorType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import <Foundation/Foundation.h>
#import "UVPresentationBlock.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVAppCoordinatorType <NSObject>

- (void)showPresentationBlock:(UVPresentationBlockType)block;

@end

NS_ASSUME_NONNULL_END
