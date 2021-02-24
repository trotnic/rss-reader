//
//  UVChannelSearchPresenterType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UVChannelSearchPresenterType <NSObject>

- (void)searchWithToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
