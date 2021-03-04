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

@property (nonatomic, retain) NSMutableArray<RSSLink *> *rssLinks;
@property (nonatomic, retain) id<UVPListRepositoryType> repository;

@end

@implementation UVSourceManager

- (void)dealloc
{
    [_repository release];
    [_rssLinks release];
    [_userDefaults release];
    [super dealloc];
}

// MARK: -

- (NSArray<RSSLink *> *)links {
    return [[self.rssLinks copy] autorelease];
}

- (void)insertLinks:(NSArray<NSDictionary *> *)rawLinks
      relativeToURL:(NSURL *)url{
    [[rawLinks compactMap:^RSSLink *(NSDictionary *rawLink) {
        RSSLink *link = [RSSLink objectWithDictionary:rawLink];
        [link configureURLRelativeToURL:url];
        return link;
    }] forEach:^(RSSLink *link) {
        if (![self.rssLinks containsObject:link]) {
            [self.rssLinks addObject:link];
        }
    }];
}

- (void)insertLink:(NSDictionary *)rawLink
     relativeToURL:(NSURL *)url {
    RSSLink *link = [RSSLink objectWithDictionary:rawLink];
    [link configureURLRelativeToURL:url];
    if (![self.rssLinks containsObject:link]) {
        [self.rssLinks addObject:link];
    }
}

- (void)deleteLink:(RSSLink *)link {
    [self.rssLinks removeObject:link];
}

- (void)updateLink:(RSSLink *)link {
    __block typeof(self)weakSelf = self;
    [self.rssLinks enumerateObjectsUsingBlock:^(RSSLink *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:link]) {
            weakSelf.rssLinks[idx] = link;
        }
    }];
}

- (void)selectLink:(RSSLink *)link {
    [self.rssLinks forEach:^(RSSLink *obj) {
        obj.selected = NO;
    }];
    link.selected = YES;
}

- (RSSLink *)selectedLink {    
    RSSLink * link = [[self.rssLinks filter:^BOOL(RSSLink *obj) {
        return obj.isSelected;
    }] firstObject];
    if (!link && self.rssLinks.count > 0) {
        self.rssLinks.firstObject.selected = YES;
        return self.rssLinks.firstObject;
    }
    return link;
}

- (BOOL)saveState:(out NSError **)error {
    NSArray<NSDictionary *> *rawLinks = [self.rssLinks compactMap:^id (RSSLink *link) {
        return link.dictionaryFromObject;
    }];
    return [self.repository updateData:rawLinks error:error];
}

// MARK: - Private

- (NSError *)sourceError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

- (BOOL)provideErrorForPointer:(out NSError **)error {
    if (error) {
        *error = [self sourceError];
    }
    return YES;
}

// MARK: - Lazy

- (NSMutableArray<RSSLink *> *)rssLinks {
    if (!_rssLinks) {
        NSError *error = nil;
        NSArray<NSDictionary *> *links = [self.repository fetchData:&error];
        if (links && !error) {
            _rssLinks = [[links map:^id (NSDictionary *rawLink) {
                return [RSSLink objectWithDictionary:rawLink];
            }] mutableCopy];
        } else {
            _rssLinks = [NSMutableArray new];
        }
    }
    return _rssLinks;
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
