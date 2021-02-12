//
//  CoordinatorType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ScreenState) {
    ScreenStateFeed,
    ScreenStateSources,
    ScreenStateSearch
};

typedef NS_ENUM(NSUInteger, Transactions) {
    TRNoConnection,
    TRFeed,
    TRSearch,
    TRSource,
    TRWeb
};

@protocol CoordinatorType <NSObject>

- (void)showScreen:(Transactions)screen;

@end

NS_ASSUME_NONNULL_END
