//
//  UVChannelSourceListPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelSourceListPresenterType <NSObject>

- (void)selectItemAtIndex:(NSInteger)index;
- (void)deleteItemAtIndex:(NSInteger)index;
- (void)searchButtonClicked;

- (NSInteger)numberOfItems;
- (id<UVRSSLinkViewModel>)itemAt:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
