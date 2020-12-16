//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"

NSString *const kRSSSourceObject = @"rssSource";

@interface UVSourceManager ()

@property (nonatomic, retain) RSSSource *actualSource;

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
    [_actualSource release];
    [super dealloc];
}

- (RSSSource *)source {
    return _actualSource;
}

- (void)setSource:(RSSSource *)source {
    [source retain];
    [_actualSource release];
    _actualSource = source;
}

- (void)selectLink:(RSSLink *)link {
    for (RSSLink *actualLink in self.actualSource.rssLinks) {
        actualLink.selected = [actualLink.link isEqualToString:link.link];
    }
}

- (RSSLink *)selectedLink {    
    return [[self.actualSource.rssLinks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]] firstObject];
}

- (void)saveState {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.actualSource requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:data forKey:kRSSSourceObject];
}

- (BOOL)hasSource {
    return _actualSource != nil;
}

// MARK: - Lazy

- (NSUserDefaults *)userDefaults {
    if(!_userDefaults) {
        _userDefaults = [NSUserDefaults.standardUserDefaults retain];
    }
    return _userDefaults;
}

- (RSSSource *)actualSource {
    if(!_actualSource) {
        NSData *source = [self.userDefaults objectForKey:kRSSSourceObject];
        if(source) {
            _actualSource = [[NSKeyedUnarchiver unarchivedObjectOfClass:RSSSource.class fromData:source error:nil] retain];
        }
    }
    return _actualSource;
}

@end
