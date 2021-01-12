//
//  UVDataRecognizerMock.h
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 3.01.21.
//

#import <Foundation/Foundation.h>
#import "UVDataRecognizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVDataRecognizerMock : NSObject <UVDataRecognizerType>

@property (nonatomic, assign) BOOL isCalled;
@property (nonatomic, retain) NSData *providedChannelData;
@property (nonatomic, retain) NSDictionary *rawChannelToReturn;
@property (nonatomic, retain) NSError *discoverChannelErrorToReturn;
@property (nonatomic, retain) id<UVFeedParserType> providedParser;

@property (nonatomic, retain) NSData *providedContentData;
@property (nonatomic, assign) UVRawContentType contentTypeToReturn;
@property (nonatomic, retain) NSError *discoverContentErrorToReturn;

@property (nonatomic, retain) NSData *providedXMLData;
@property (nonatomic, retain) NSArray<NSDictionary *> *rawLinksXMLToReturn;
@property (nonatomic, retain) NSError *discoverXMLErrorToReturn;
@property (nonatomic, retain) NSURL *providedURL;

@property (nonatomic, retain) NSData *providedHTMLData;
@property (nonatomic, retain) NSArray<NSDictionary *> *rawLinksHTMLToReturn;
@property (nonatomic, retain) NSError *discoverHTMLErrorToReturn;

@end

NS_ASSUME_NONNULL_END
