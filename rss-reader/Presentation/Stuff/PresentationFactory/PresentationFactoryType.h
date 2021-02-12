//
//  PresentationFactoryType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import <UIKit/UIKit.h>
#import "UVNetworkType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "CoordinatorType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PresentationBlockType) {
    PresentationBlockFeed,
    PresentationBlockSources,
    PresentationBlockSearch
};

@protocol PresentationFactoryType <NSObject>

- (UIViewController *)presentationBlockOfType:(PresentationBlockType)type
                                      network:(id<UVNetworkType>)network
                                       source:(id<UVSourceManagerType>)source
                                       parser:(id<UVDataRecognizerType>)parser
                                  coordinator:(id<CoordinatorType>)coordinator;

@end

NS_ASSUME_NONNULL_END
