//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"
#import "UVSourceRepository.h"

#import "NSArray+Util.h"

#import "UVErrorDomain.h"
#import "KeyConstants.h"

@interface UVSourceManager ()

@property (nonatomic, retain) NSMutableArray<RSSSource *> *sources;
@property (nonatomic, retain) id<UVPListRepositoryType> repository;

@end

@implementation UVSourceManager

- (void)dealloc
{
    [_repository release];
    [_sources release];
    [_userDefaults release];
    [super dealloc];
}

// MARK: -

- (NSArray<RSSLink *> *)links {
    NSMutableArray *links = [NSMutableArray array];
    [self.sources forEach:^(RSSSource *source) {
        [links addObjectsFromArray:source.rssLinks];
    }];
    return [[links copy] autorelease];
}

- (RSSSource *)buildObjectWithURL:(NSURL *)url
                            links:(NSArray<RSSLink *> *)links {
    return [[[RSSSource alloc] initWithURL:url links:links] autorelease];
}

- (BOOL)insertSourceWithURL:(NSURL *)url
                      links:(NSArray<NSDictionary *> *)links
                      error:(out NSError **)error {
    if (!url || !links || !links.count) {
        [self provideErrorForReference:error];
        return NO;
    }
    
    NSArray<RSSLink *> *actualLinks = [links map:^RSSLink *(NSDictionary *rawLink) {
        return [RSSLink objectWithDictionary:rawLink];
    }];
    
    if (!actualLinks || !actualLinks.count) {
        [self provideErrorForReference:error];
        return NO;
    }
    
    RSSSource *source = [[[RSSSource alloc] initWithURL:url links:actualLinks] autorelease];
    
    if (!source) {
        [self provideErrorForReference:error];
        return NO;
    }
    [self insertObject:source];
    return YES;
}

- (void)removeObject:(RSSSource *)source {
    [self.sources removeObject:source];
}

- (void)updateObject:(RSSSource *)source {
    __block typeof(self)weakSelf = self;
    [self.sources enumerateObjectsUsingBlock:^(RSSSource *obj, NSUInteger idx, BOOL *stop) {
        if([obj isEqual:source]) {
            weakSelf.sources[idx] = source;
        } else if (source.isSelected) {
            [obj switchAllLinksSelected:NO];
        }
    }];
}

- (void)selectLink:(RSSLink *)link {
    [self.sources forEach:^(RSSSource *source) {
        [source switchAllLinksSelected:NO];
    }];
    link.selected = YES;
}

- (RSSSource *)selectedSource {
    return [self.sources find:^BOOL(RSSSource *source) {
        return source.isSelected;
    }];
}

- (RSSLink *)selectedLink {
    return self.selectedSource.selectedLinks.firstObject;
}

- (BOOL)saveState:(out NSError **)error {
    NSArray *sources = [self.sources map:^id(RSSSource *source) {
        return source.dictionaryFromObject;
    }];
    [self.repository updateData:sources error:error];
    return YES;
}

// MARK: - Private

- (void)insertObject:(RSSSource *)source {
    if (![self.sources containsObject:source]) {
        [self.sources addObject:source];
    }
}

- (NSError *)sourceError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

- (BOOL)provideErrorForReference:(out NSError **)error {
    if (error) {
        *error = [self sourceError];
    }
    return YES;
}

// MARK: - Lazy

- (NSMutableArray<RSSSource *> *)sources {
    if(!_sources) {
        NSError *error = nil;
        NSArray *sources = [self.repository fetchData:&error];
        if (sources && !error) {
            _sources = [[sources map:^id (NSDictionary *rawSource) {
                return [RSSSource objectWithDictionary:rawSource];
            }] mutableCopy];
        } else {
            _sources = [NSMutableArray new];
        }
    }
    return _sources;
}

- (id<UVPListRepositoryType>)repository {
    if(!_repository) {
        NSString *path = [self.userDefaults objectForKey:kSourcesFilePathKey];
        _repository = [[UVSourceRepository alloc] initWithPath:path];
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
