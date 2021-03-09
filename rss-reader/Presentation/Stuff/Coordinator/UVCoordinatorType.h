//
//  UVCoordinatorType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import <Foundation/Foundation.h>
#import "UVPresentationBlocks.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVCoordinatorType <NSObject>

- (void)showScreen:(PresentationBlockType)screen;
- (void)openURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
