//
//  UVSourceManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "RSSLink.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceManagerType <NSObject>

@property (nonatomic, strong, readonly) NSArray<RSSLink *> *links;

//- (void)insertLinks:(NSArray<NSDictionary *> *)rawLinks relativeToURL:(NSURL *)url;
- (void)insertLink:(NSDictionary *)rawLink relativeToURL:(NSURL *)url;
- (void)updateLink:(RSSLink *)link;
- (void)deleteLink:(RSSLink *)link;
- (void)selectLink:(RSSLink *)link;
- (RSSLink * _Nullable)selectedLink;
- (BOOL)saveState:(out NSError **)error;

@end

NS_ASSUME_NONNULL_END
