//
//  UVBasePresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <UIKit/UIKit.h>
#import "UVBaseViewType.h"
#import "UVCoordinatorType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVNetworkType.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVBasePresenter : NSObject

@property (nonatomic, retain, readonly) id<UVDataRecognizerType>    dataRecognizer;
@property (nonatomic, retain, readonly) id<UVSourceManagerType>     sourceManager;
@property (nonatomic, retain, readonly) id<UVNetworkType>           network;
@property (nonatomic, retain, readonly) id<UVCoordinatorType>         coordinator;

@property (nonatomic, assign) UIViewController<UVBaseViewType> *viewDelegate;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                            source:(id<UVSourceManagerType>)source
                           network:(id<UVNetworkType>)network
                       coordinator:(id<UVCoordinatorType>)coordinator;

- (void)showError:(RSSError)error;

@end

NS_ASSUME_NONNULL_END
