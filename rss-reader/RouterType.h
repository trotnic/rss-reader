//
//  RouterType.h
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RouterType <NSObject>

- (void)startURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
