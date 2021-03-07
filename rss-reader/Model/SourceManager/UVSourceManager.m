//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"

#import "NSArray+Util.h"

#import "UVErrorDomain.h"
#import "KeyConstants.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface UVSourceManager ()

@property (nonatomic, strong) NSMutableArray<RSSLink *> *rssLinks;

@property (nonatomic, strong) id<UVSessionType> session;
@property (nonatomic, strong) id<UVPListRepositoryType> repository;

@property (nonatomic, copy, readonly) NSString *sourcesFileName;

@end

@implementation UVSourceManager

- (instancetype)initWithSession:(id<UVSessionType>)session repository:(id<UVPListRepositoryType>)repository
{
    self = [super init];
    if (self) {
        _session = session;
        _repository = repository;
    }
    return self;
}

- (void)dealloc
{
    [_repository release];
    [_rssLinks release];
    [super dealloc];
}

// MARK: - Lazy Properties

- (NSMutableArray<RSSLink *> *)rssLinks {
    if (!_rssLinks) {
        NSError *error = nil;
        NSArray<NSDictionary *> *links = [self.repository fetchData:self.sourcesFileName error:&error];
        if (links && !error) {
            NSMutableArray *newLinks = [[links map:^RSSLink *(NSDictionary *rawLink) {
                return [RSSLink objectWithDictionary:rawLink];
            }] mutableCopy];
            _rssLinks = newLinks;
        } else {
            NSMutableArray *newLinks = [NSMutableArray new];
            _rssLinks = newLinks;
        }
    }
    return _rssLinks;
}

// MARK: - Interface

- (BOOL)saveState:(out NSError * _Nullable *)error {
    NSArray<NSDictionary *> *rawLinks = [self.rssLinks compactMap:^NSDictionary *(RSSLink *link) {
        return [link dictionaryFromObject];
    }];
    return [self.repository updateData:rawLinks file:self.sourcesFileName error:error];
}

- (RSSLink *)selectedLink {
    RSSLink *link = [[self.rssLinks filter:^BOOL(RSSLink *link) {
        return link.isSelected;
    }] firstObject];
    if (!link && self.rssLinks.count > 0) {
        self.rssLinks.firstObject.selected = YES;
        return self.rssLinks.firstObject;
    }
    return link;
}

- (void)selectLink:(RSSLink *)link {
    [self.rssLinks forEach:^(RSSLink *link) {
        link.selected = NO;
    }];
    link.selected = YES;
}

- (void)updateLink:(RSSLink *)link {
    [self.rssLinks enumerateObjectsUsingBlock:^(RSSLink *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:link]) self.rssLinks[idx] = link;
    }];
}

- (void)deleteLink:(RSSLink *)link {
    [self.rssLinks removeObject:link];
}

- (void)insertLink:(NSDictionary *)rawLink relativeToURL:(NSURL *)url {
    RSSLink *link = [RSSLink objectWithDictionary:rawLink];
    [link configureURLRelativeToURL:url];
    if (![self.rssLinks containsObject:link]) {
        [self.rssLinks addObject:link];
    }
}

- (NSArray<RSSLink *> *)links {
    return [self.rssLinks copy];
}

// MARK: - Private

- (NSString *)sourcesFileName {
    return [self.session pathTo:UVSourcesPath];
}

@end
