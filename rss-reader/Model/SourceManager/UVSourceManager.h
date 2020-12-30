//
//  UVSourceManager.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "UVSourceManagerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVSourceManager : NSObject <UVSourceManagerType>

@property (nonatomic, retain) NSUserDefaults *userDefaults;

@end

NS_ASSUME_NONNULL_END
