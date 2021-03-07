//
//  UVSessionType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UVPath) {
    UVSourcesPath,
    UVFeedPath
};

@protocol UVSessionType <NSObject>

- (NSString *)pathTo:(UVPath)type;
- (BOOL)shouldRestore;

@end

NS_ASSUME_NONNULL_END
