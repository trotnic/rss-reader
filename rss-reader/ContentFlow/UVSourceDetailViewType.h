//
//  UVLinksViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "BaseViewType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourceDetailViewType <BaseViewType>

- (void)updateLinkAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
