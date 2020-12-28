//
//  UVSourcesListViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>
#import "BaseViewType.h"
#import "RSSSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourcesListViewType <NSObject, BaseViewType>

- (void)stopSearchWithUpdate:(BOOL)update;
- (void)presentDetailWithModel:(RSSSource *)model;

@end

NS_ASSUME_NONNULL_END
