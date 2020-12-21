//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"

NSString *const kRSSSourceObject = @"rssSource";

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

// TODO:
- (void)saveState {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.rssSources requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:data forKey:@"sources"];
}

- (NSArray<RSSSource *> *)sources {
    return [self.rssSources sortedArrayUsingDescriptors:@[]];
}

- (void)insertRSSSource:(RSSSource *)source {
    for (int i = 0; i < self.rssSources.count; i++) {
        if ([self.rssSources[i].url isEqual:source.url]) {
            return;
        }
    }
    [self.rssSources addObject:source];
    [self saveState];
}

- (void)updateRSSSource:(RSSSource *)source {
    for (int i = 0; i < self.rssSources.count; i++) {
        if ([self.rssSources[i].url isEqual:source.url]) {
            for (int j = 0; j < source.rssLinks.count; j++) {
                self.rssSources[i].rssLinks[j].selected = source.rssLinks[j].isSelected;
            }
        } else if (source.isSelected) {
            [self.rssSources[i] switchAllLinksSelected:NO];
        }
    }
}

- (void)removeRSSSource:(RSSSource *)source {
    for (int i = 0; i < self.rssSources.count; i++) {
        if ([self.rssSources[i].url isEqual:source.url]) {
            [self.rssSources removeObjectAtIndex:i];
            return;
        }
    }
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

- (NSUserDefaults *)userDefaults {
    if(!_userDefaults) {
        _userDefaults = [NSUserDefaults.standardUserDefaults retain];
    }
    return _userDefaults;
}

- (NSMutableArray<RSSSource *> *)rssSources {
    if(!_rssSources) {
        NSData *sources = [self.userDefaults dataForKey:@"sources"];
        if (sources) {
            _rssSources = [[NSMutableArray arrayWithArray:
                            [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[NSArray.class, RSSSource.class]]
                                                                fromData:sources error:nil]] retain];
        } else {
            _rssSources = [NSMutableArray new];
        }
    }
    return _rssSources;
}

@end
