//
//  UVSession.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 07.03.2021.
//

#import "UVSession.h"

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


// MARK: - UVSessionType

- (NSString *)pathTo:(UVPath)type {
    switch (type) {
        case UVFeedPath:
            return FEED_FILE_NAME;
        case UVSourcesPath:
            return SOURCES_FILE_NAME;
    }
}

- (BOOL)shouldRestore {
    return NO;
}

@end
