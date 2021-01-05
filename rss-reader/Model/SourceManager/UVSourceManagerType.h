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

@property (nonatomic, copy, readonly) NSArray<RSSLink *> *links;

- (BOOL)insertSourceWithURL:(NSURL *)url links:(NSArray<NSDictionary *> *)links error:(out NSError **)error;
- (RSSSource *)buildObjectWithURL:(NSURL *)url links:(NSArray<RSSLink *> *)links;
- (void)removeObject:(RSSSource *)source;
- (void)updateObject:(RSSSource *)source;
- (void)selectLink:(RSSLink *)link;
- (RSSSource * _Nullable)selectedSource;
- (RSSLink * _Nullable)selectedLink;
- (BOOL)saveState:(out NSError **)error;

@end

NS_ASSUME_NONNULL_END
