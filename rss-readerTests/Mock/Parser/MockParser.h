//
//  MockParser.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVFeedParserType.h"

NS_ASSUME_NONNULL_BEGIN

@interface MockParser : NSObject <UVFeedParserType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) UVFeedChannel *channel;

+ (instancetype)parser;

@end
NS_ASSUME_NONNULL_END
