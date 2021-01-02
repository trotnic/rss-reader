//
//  UVFeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>
#import "UVBaseViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVFeedViewType <UVBaseViewType>

- (void)updatePresentation;
- (void)rotateActivityIndicator:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
