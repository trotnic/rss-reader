//
//  UVBasePresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <Foundation/Foundation.h>
#import "UVBaseViewType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVNetworkType.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVBasePresenter : NSObject

@property (nonatomic, retain, readonly) id<UVDataRecognizerType> dataRecognizer;
@property (nonatomic, retain, readonly) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain, readonly) id<UVNetworkType> network;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)manager
                           network:(id<UVNetworkType>)network;

@property (nonatomic, assign) id<UVBaseViewType> view;

- (void)showError:(RSSError)error;

@end

NS_ASSUME_NONNULL_END
