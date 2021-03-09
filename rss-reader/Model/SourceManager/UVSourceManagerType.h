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

- (void)insertLink:(NSDictionary *)rawLink relativeToURL:(NSURL *)url;
- (void)updateLink:(RSSLink *)link;
- (void)deleteLink:(RSSLink *)link;
- (void)selectLink:(RSSLink *)link;
- (RSSLink * _Nullable)selectedLink;
- (BOOL)saveState:(out NSError **)error;

- (void)registerObserver:(NSString *)observer callback:(void(^)(BOOL))callback;
- (void)unregisterObserver:(NSString *)observer;
- (BOOL)isObservedBy:(NSString *)observer;

@end

NS_ASSUME_NONNULL_END
