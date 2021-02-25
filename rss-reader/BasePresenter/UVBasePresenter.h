//
//  UVBasePresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <UIKit/UIKit.h>

#import "RSSError.h"

#import "UVAppCoordinatorType.h"
#import "UVDataRecognizerType.h"
#import "UVNetworkType.h"
#import "UVSourceManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVBasePresenter : NSObject

@property (nonatomic, retain, readonly) id<UVDataRecognizerType> dataRecognizer;
@property (nonatomic, retain, readonly) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain, readonly) id<UVNetworkType> network;
@property (nonatomic, retain, readonly) id<UVAppCoordinatorType> coordinator;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)manager
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVAppCoordinatorType>)coordinator;

- (NSError *)provideErrorOfType:(RSSError)errorType;

@end

NS_ASSUME_NONNULL_END
