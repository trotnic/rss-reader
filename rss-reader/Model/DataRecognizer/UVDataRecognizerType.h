//
//  UVDataRecognizerType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVFeedParserType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UVRawContentType) {
    UVRawContentXML,
    UVRawContentHTML,
    UVRawContentUndefined,
};

@protocol UVDataRecognizerType <NSObject>

- (void)discoverLinksFromHTML:(NSData *)data
                   completion:(void(^)(NSArray<NSDictionary *> * _Nullable, NSError * _Nullable))completion;

- (void)discoverLinksFromXML:(NSData *)data
                        url:(NSURL *)url
                 completion:(void (^)(NSArray<NSDictionary *> * _Nullable, NSError * _Nullable))completion;

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void(^)(NSDictionary *, NSError *))completion;

- (void)discoverContentType:(NSData *)data completion:(void(^)(UVRawContentType, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
