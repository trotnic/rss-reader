//
//  UVRSSLinkXMLParserMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 8.01.21.
//

#import <Foundation/Foundation.h>
#import "UVRSSLinkXMLParserType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVRSSLinkXMLParserMock : NSObject <UVRSSLinkXMLParserType>

@property (nonatomic, strong) NSData *providedData;
@property (nonatomic, strong) NSDictionary *dictionaryToReturn;
@property (nonatomic, strong) NSError *errorToReturn;
@property (nonatomic, assign) BOOL isCalled;

@end

NS_ASSUME_NONNULL_END
