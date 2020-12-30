//
//  ErrorPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 16.12.20.
//

#import <Foundation/Foundation.h>
#import "LocalConstants.h"
#import "UVErrorManagerType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVNetworkManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVBasePresenter : NSObject <UVErrorManagerType>

@property (nonatomic, retain, readonly) id<UVDataRecognizerType> dataRecognizer;
@property (nonatomic, retain, readonly) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain, readonly) id<UVNetworkManagerType> network;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)manager
                           network:(id<UVNetworkManagerType>)network;

@end

NS_ASSUME_NONNULL_END
