//
//  UVChannelSourceListViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>
#import "UVBaseViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelSourceListViewType <UVBaseViewType>

- (void)stopSearchWithUpdate:(BOOL)update;

@end

NS_ASSUME_NONNULL_END