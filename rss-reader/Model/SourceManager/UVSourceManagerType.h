//
//  UVSourceManagerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "UVRSSLink.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceManagerType <NSObject>

@property (nonatomic, strong, readonly) NSArray<UVRSSLink *> *links;

- (void)insertLink:(NSDictionary *)rawLink relativeToURL:(NSURL *)url;
- (void)updateLink:(UVRSSLink *)link;
- (void)deleteLink:(UVRSSLink *)link;
- (void)selectLink:(UVRSSLink *)link;

// LINKS:
// _______________________
- (NSArray<UVRSSLink *> *)selectedLinks;
// _______________________

//- (UVRSSLink * _Nullable)selectedLink;
- (BOOL)saveState:(out NSError **)error;

- (void)registerObserver:(NSString *)observer callback:(void(^)(BOOL shouldUpdate))callback;
- (void)unregisterObserver:(NSString *)observer;
- (BOOL)isObservedBy:(NSString *)observer;

@end

NS_ASSUME_NONNULL_END
