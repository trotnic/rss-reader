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

+ (NSError *)provideErrorOfType:(RSSError)type;

@end

NS_ASSUME_NONNULL_END
