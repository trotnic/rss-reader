//
//  UVSourceManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceManagerType <NSObject>

- (NSArray<RSSSource *> *)sources;
- (void)insertRSSSource:(RSSSource *)source;
- (void)removeRSSSource:(RSSSource *)source;
- (void)updateRSSSource:(RSSSource *)source;
- (RSSSource * _Nullable)selectedRSSSource;
- (RSSLink * _Nullable)selectedLink;
- (void)saveState;

@end

NS_ASSUME_NONNULL_END
