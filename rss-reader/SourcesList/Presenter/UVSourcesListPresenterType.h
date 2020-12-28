//
//  UVSourcesListPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourcesListPresenterType <NSObject>

- (NSArray<id<RSSLinkViewModel>> *)items;
- (void)parseAddress:(NSString *)address;
- (void)selectItemWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
