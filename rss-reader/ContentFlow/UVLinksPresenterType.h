//
//  UVLinksPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVLinksViewType.h"
#import "RSSSourceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVLinksPresenterType <NSObject>

- (void)assignView:(id<UVLinksViewType>)view;
- (void)updateChannelsWithPlainUrl:(NSString *)url;
- (void)selectChannelAtIndex:(NSInteger)index;
- (id<RSSSourceViewModel>)source;

@end

NS_ASSUME_NONNULL_END
