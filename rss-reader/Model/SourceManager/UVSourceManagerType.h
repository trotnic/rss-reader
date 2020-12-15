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

@property (nonatomic, retain) RSSSource *source;

- (void)selectLink:(RSSLink *)link;
- (RSSLink *)selectedLink;
- (void)saveState;

@end

NS_ASSUME_NONNULL_END
