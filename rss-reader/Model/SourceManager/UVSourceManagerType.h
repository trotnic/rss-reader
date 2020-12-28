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
- (NSArray<RSSLink *> *)links;
- (void)insertRSSSource:(RSSSource *)source;
- (void)removeRSSSource:(RSSSource *)source;
- (void)updateRSSSource:(RSSSource *)source;
- (void)selectLink:(RSSLink *)link;
- (RSSSource * _Nullable)selectedRSSSource;
- (RSSLink * _Nullable)selectedLink;
- (BOOL)saveState:(out NSError **)error;

@end

NS_ASSUME_NONNULL_END
