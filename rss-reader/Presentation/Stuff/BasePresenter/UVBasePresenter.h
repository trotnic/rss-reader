//
//  UVBasePresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import <UIKit/UIKit.h>
#import "UVBaseViewType.h"
#import "CoordinatorType.h"
#import "UVSourceManagerType.h"
#import "UVDataRecognizerType.h"
#import "UVNetworkType.h"
#import "RSSError.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVBasePresenter : NSObject

@property (nonatomic, retain, readonly) id<UVDataRecognizerType> dataRecognizer;
@property (nonatomic, retain, readonly) id<UVSourceManagerType> sourceManager;
@property (nonatomic, retain, readonly) id<UVNetworkType> network;
@property (nonatomic, retain, readonly) id<CoordinatorType> coordinator;

@property (nonatomic, assign) UIViewController<UVBaseViewType> *viewDelegate;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)manager
                           network:(id<UVNetworkType>)network
                       coordinator:(id<CoordinatorType>)coordinator;

- (void)showError:(RSSError)error;

@end

NS_ASSUME_NONNULL_END
