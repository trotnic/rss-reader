//
//  UVChannelDoneListPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 3.03.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedItemDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelDoneListPresenterType <NSObject>

@property (nonatomic, assign, readonly) NSInteger numberOfRows;

- (id<UVFeedItemDisplayModel>)itemAt:(NSInteger)index;
- (void)didSelectItemAt:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
