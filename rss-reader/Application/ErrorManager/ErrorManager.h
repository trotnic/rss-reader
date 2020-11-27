//
//  ErrorManager.h
//  rss-reader
//
//  Created by Uladzislau on 11/25/20.
//

#import <Foundation/Foundation.h>
#import "ErrorManagerType.h"
#import "LocaleConstants.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSInteger const RSSReaderErrorCodeKey;
FOUNDATION_EXPORT NSString *const RSSReaderDomainKey;

@interface ErrorManager : NSObject <ErrorManagerType>

@end

NS_ASSUME_NONNULL_END
