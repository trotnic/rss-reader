//
//  UVSourcesListViewType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 20.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVSourcesListViewType

- (void)stopSearchWithUpdate:(BOOL)update;
- (void)updatePresentation;
- (void)presentError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
