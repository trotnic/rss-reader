//
//  UVLinksPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVSourceDetailViewType.h"
#import "RSSSourceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceDetailPresenterType <NSObject>

- (void)saveSource;
- (void)assignView:(id<UVSourceDetailViewType>)view;
- (void)selectChannelAtIndex:(NSInteger)index;
- (id<RSSSourceViewModel>)source;

@end

NS_ASSUME_NONNULL_END
