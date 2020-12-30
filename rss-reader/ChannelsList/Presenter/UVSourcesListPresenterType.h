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
- (void)discoverAddress:(NSString *)address;
- (void)selectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
