//
//  UVSourcesListPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourcesListPresenterType <NSObject>

- (void)discoverAddress:(NSString *)address;
- (NSArray<id<UVRSSLinkViewModel>> *)items;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)deleteItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
