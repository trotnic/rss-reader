//
//  UVSessionType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UVFile) {
    UVSourcesFile,
    UVFeedFile
};

@protocol UVSessionType <NSObject>

@property (nonatomic, assign) BOOL shouldRestore;
@property (nonatomic, strong) NSDictionary *lastFeedItem;

- (NSString *)nameOfFile:(UVFile)type;

@end

NS_ASSUME_NONNULL_END
