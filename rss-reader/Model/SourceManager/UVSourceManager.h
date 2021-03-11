//
//  UVSourceManager.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import <Foundation/Foundation.h>
#import "UVObservable.h"
#import "UVSourceManagerType.h"
#import "UVPListRepositoryType.h"
#import "UVSessionType.h"

@interface UVSourceManager : UVObservable <UVSourceManagerType>

- (instancetype)initWithSession:(id<UVSessionType>)session repository:(id<UVPListRepositoryType>)repository;

@end
