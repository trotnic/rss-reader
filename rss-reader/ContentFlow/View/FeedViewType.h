//
//  FeedViewType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeedChannelViewModel;

@protocol FeedViewType <NSObject>

- (void)updatePresentation;
//- (void)setChannel:(id<FeedChannelViewModel>)channel;

@end

NS_ASSUME_NONNULL_END
