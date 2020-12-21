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

- (RSSSource *)source {
    return nil;
}

- (void)setSource:(RSSSource *)source {
    
}

- (void)selectLink:(RSSLink *)link {
    
}

- (RSSLink *)selectedLink {    
    for (RSSSource *source in self.rssSources) {
        if (source.isSelected) {
            return source.selectedLinks.firstObject;
        }
    }
    return nil;
}

- (void)saveState {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.rssSources requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:data forKey:@"sources"];
}

- (NSArray<RSSSource *> *)origins {
    return [self.rssSources sortedArrayUsingDescriptors:@[]];
}

- (void)addRSSSource:(RSSSource *)source {
    // TODO:
    [self.rssSources addObject:source];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.rssSources requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:data forKey:@"sources"];
}

- (void)updateRSSSource:(RSSSource *)source {
    
    
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
