//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"
#import "NSArray+Util.h"
#import "UVSourceRepositoryType.h"
#import "UVSourceRepository.h"
#import "KeyConstants.h"

@interface UVSourceManager ()

@property (nonatomic, retain) NSMutableArray<RSSSource *> *rssSources;
@property (nonatomic, retain) id<UVSourceRepositoryType> repository;

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
    [_repository release];
    [_rssSources release];
    [_userDefaults release];
    [super dealloc];
}

// MARK: -

- (NSArray<RSSLink *> *)links {
    NSMutableArray *links = [NSMutableArray array];
    for (RSSSource *source in self.rssSources) {
        for (RSSLink *link in source.rssLinks) {
            [links addObject:link];
        }
    }
    
    return [[links copy] autorelease];
}

- (void)selectLink:(RSSLink *)link {
    for (int i = 0; i < self.rssSources.count; i++) {
        [self.rssSources[i] switchAllLinksSelected:NO];
    }
    link.selected = YES;
}

- (RSSLink *)selectedLink {    
    return self.selectedRSSSource.selectedLinks.firstObject;
}

- (BOOL)saveState:(out NSError **)error {
    NSArray *sources = [self.rssSources map:^id(RSSSource *source) { return source.dictionaryFromObject; }];
    [self.repository updateData:sources error:error];
    return YES;
}

- (NSArray<RSSSource *> *)sources {
    return [self.rssSources sortedArrayUsingDescriptors:@[]];
}

- (void)insertRSSSource:(RSSSource *)source {
    if (![self.rssSources containsObject:source]) {
        [self.rssSources addObject:source];
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
        NSError *error = nil;
        NSArray *sources = [self.repository fetchData:&error];
        if (sources && !error) {
            _rssSources = [[sources map:^id (id source) { return [RSSSource objectWithDictionary:source]; }] mutableCopy];
        } else {
            _rssSources = [NSMutableArray new];
        }
    }
    return _rssSources;
}

- (id<UVSourceRepositoryType>)repository {
    if(!_repository) {
        
        NSString *fileName = [self.userDefaults objectForKey:kSourcesFileNameKey];
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                           .firstObject stringByAppendingString:fileName] copy];
        _repository = [[UVSourceRepository alloc] initWithPath:[path autorelease]];
    }
    return _repository;
}

- (NSUserDefaults *)userDefaults {
    if(!_userDefaults) {
        _userDefaults = [NSUserDefaults.standardUserDefaults retain];
    }
    return _userDefaults;
}


@end
