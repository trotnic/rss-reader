//
//  UVSession.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import "UVSession.h"

static NSString *const KEY_FEED_ITEM        = @"feedItem";
static NSString *const KEY_SHOULD_RESTORE   = @"shouldRestore";
static NSString *const SOURCES_FILE_NAME    = @"source.plist";
static NSString *const FEED_FILE_NAME       = @"lolkek.plist";

@interface UVSession ()

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation UVSession

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults
{
    self = [super init];
    if (self) {
        _defaults = defaults;
    }
    return self;
}

// MARK: - Lazy Properties

- (BOOL)shouldRestore {
    return [self.defaults boolForKey:KEY_SHOULD_RESTORE];
}

- (void)setShouldRestore:(BOOL)shouldRestore {
    [self.defaults setBool:shouldRestore forKey:KEY_SHOULD_RESTORE];
}

- (NSDictionary *)lastFeedItem {
    return [self.defaults valueForKey:KEY_FEED_ITEM];
}

- (void)setLastFeedItem:(NSDictionary *)lastFeedItem {
    [self.defaults setValue:lastFeedItem forKey:KEY_FEED_ITEM];
}

// MARK: - UVSessionType

- (NSString *)nameOfFile:(UVFile)type {
    switch (type) {
        case UVFeedFile:
            return FEED_FILE_NAME;
        case UVSourcesFile:
            return SOURCES_FILE_NAME;
    }
}

@end
