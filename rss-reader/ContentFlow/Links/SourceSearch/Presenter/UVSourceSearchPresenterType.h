//
//  UVSourceSearchPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 18.12.20.
//

#import <Foundation/Foundation.h>
#import "UVSourceSearchViewType.h"
#import "RSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceSearchPresenterType <NSObject>

- (void)searchForAddress:(NSString *)address;
- (void)assignView:(id<UVSourceSearchViewType>)view;
- (NSArray<id<RSSLinkViewModel>> *)items;

@end

NS_ASSUME_NONNULL_END
