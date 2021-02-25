//
//  UVPresentationFactory.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 25.02.21.
//

#import "UVPresentationFactoryType.h"

#import "UVDataRecognizerType.h"
#import "UVNetworkType.h"
#import "UVSourceManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVPresentationFactory : NSObject <UVPresentationFactoryType>

+ (instancetype)factoryWithNetwork:(id<UVNetworkType>)network source:(id<UVSourceManagerType>)source recognizer:(id<UVDataRecognizerType>)recognizer;
- (instancetype)initWithNetwork:(id<UVNetworkType>)network source:(id<UVSourceManagerType>)source recognizer:(id<UVDataRecognizerType>)recognizer;

@end

NS_ASSUME_NONNULL_END
