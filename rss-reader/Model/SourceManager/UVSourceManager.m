//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"
#import "NSArray+Util.h"

NSString *const kFileName = @"/source.plist";

@interface UVSourceManager ()

@property (nonatomic, retain) NSMutableArray<RSSSource *> *rssSources;

@end

@implementation UVSourceManager

+ (instancetype)defaultManager {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [self new];
    });
    return _sharedObject;
}

- (void)dealloc
{
    [_userDefaults release];
    [_rssSources release];
    [super dealloc];
}

- (RSSLink *)selectedLink {    
    return self.selectedRSSSource.selectedLinks.firstObject;
}

- (void)saveState {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                          .firstObject stringByAppendingFormat:kFileName];
    NSArray *sources = [self.rssSources map:^id(RSSSource *source) { return source.dictionaryFromObject; }];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:sources
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:0 error:nil];
    [plistData writeToFile:path atomically:YES];
}

- (NSArray<RSSSource *> *)sources {
    return [self.rssSources sortedArrayUsingDescriptors:@[]];
}

- (void)insertRSSSource:(RSSSource *)source {
    if (![self.rssSources containsObject:source]) {
        [self.rssSources addObject:source];
        [self saveState];
    }
}

- (void)updateRSSSource:(RSSSource *)source {
    for (int i = 0; i < self.rssSources.count; i++) {
        if ([self.rssSources[i] isEqual:source]) {
            for (int j = 0; j < source.rssLinks.count; j++) {
                self.rssSources[i].rssLinks[j].selected = source.rssLinks[j].isSelected;
            }
        } else if (source.isSelected) {
            [self.rssSources[i] switchAllLinksSelected:NO];
        }
    }
}

- (void)removeRSSSource:(RSSSource *)source {
    [self.rssSources removeObject:source];
}

- (RSSSource *)selectedRSSSource {
    for (int i = 0; i < self.rssSources.count; i++) {
        if (self.rssSources[i].isSelected) {
            return self.rssSources[i];
        }
    }
    return nil;
}

// MARK: - Lazy

- (NSMutableArray<RSSSource *> *)rssSources {
    if(!_rssSources) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                              .firstObject stringByAppendingFormat:kFileName];
        NSData *sources = [NSData dataWithContentsOfFile:path];
        if (sources) {
            _rssSources = [[[NSPropertyListSerialization propertyListWithData:sources
                                                                      options:0
                                                                       format:nil
                                                                        error:nil]
                            map:^id (NSDictionary *source) {
                return [RSSSource objectWithDictionary:source];
            }] mutableCopy];
        } else {
            _rssSources = [NSMutableArray new];
        }
    }
    return _rssSources;
}

@end
