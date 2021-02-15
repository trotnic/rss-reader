//
//  UVPresentationBlockFactory.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import "UVPresentationFactoryType.h"
#import "UVNetworkType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVFeedManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVPresentationBlockFactory : NSObject <UVPresentationFactoryType>

- (instancetype)initWithNetwork:(id<UVNetworkType>)network
                         source:(id<UVSourceManagerType>)source
                     recognizer:(id<UVDataRecognizerType>)recognizer
                           feed:(id<UVFeedManagerType>)feed;

@end

NS_ASSUME_NONNULL_END
