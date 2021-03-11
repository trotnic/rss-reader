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

// FEED: ❗️
#import "UVRSSFeed.h"

#import <objc/runtime.h>
#import <objc/message.h>

/**
 remove links?
 
 */

@interface UVSourceManager ()

@property (nonatomic, strong) NSMutableArray<UVRSSLink *> *rssLinks;

@property (nonatomic, retain) id<UVSessionType> session;
@property (nonatomic, retain) id<UVPListRepositoryType> repository;

@property (nonatomic, copy, readonly) NSString *sourcesFileName;

@end

@implementation UVSourceManager

- (instancetype)initWithSession:(id<UVSessionType>)session repository:(id<UVPListRepositoryType>)repository
{
    self = [super init];
    if (self) {
        _session = [session retain];
        _repository = [repository retain];
    }
    return self;
}

- (void)dealloc
{
    [_repository release];
    [_rssLinks release];
    [_session release];
    [super dealloc];
}

// MARK: - Lazy Properties

- (NSMutableArray<UVRSSLink *> *)rssLinks {
    if (!_rssLinks) {
        NSError *error = nil;
        NSArray<NSDictionary *> *links = [self.repository fetchData:self.sourcesFileName error:&error];
        if (links && !error) {
            NSMutableArray *newLinks = [[links map:^UVRSSLink *(NSDictionary *rawLink) {
                return [UVRSSLink objectWithDictionary:rawLink];
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
    NSArray<NSDictionary *> *rawLinks = [self.rssLinks compactMap:^NSDictionary *(UVRSSLink *link) {
        return [link dictionaryFromObject];
    }];
    return [self.repository updateData:rawLinks file:self.sourcesFileName error:error];
}

- (NSArray<UVRSSLink *> *)selectedLinks {
    return [self.rssLinks filter:^BOOL(UVRSSLink *link) {
        return link.isSelected;
    }];
}

//- (RSSLink *)selectedLink {
//    RSSLink *link = [[self.rssLinks filter:^BOOL(RSSLink *link) {
//        return link.isSelected;
//    }] firstObject];
//    if (!link && self.rssLinks.count > 0) {
//        self.rssLinks.firstObject.selected = YES;
//        return self.rssLinks.firstObject;
//    }
//    return link;
//}

- (void)selectLink:(UVRSSLink *)link {
    link.selected = !link.isSelected;
    [self notifyObservers:^(observableCallback callback) {
        // TODO: -
        if (callback) callback(YES);
    }];
}

- (void)updateLink:(UVRSSLink *)link {
    [self.rssLinks enumerateObjectsUsingBlock:^(UVRSSLink *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:link]) self.rssLinks[idx] = link;
    }];
}

- (void)deleteLink:(UVRSSLink *)link {
    [self.rssLinks removeObject:link];
}

- (void)insertLink:(NSDictionary *)rawLink relativeToURL:(NSURL *)url {
    UVRSSLink *link = [UVRSSLink objectWithDictionary:rawLink];
    [link configureURLRelativeToURL:url];
    if (![self.rssLinks containsObject:link]) [self.rssLinks addObject:link];
}

- (NSArray<UVRSSLink *> *)links {
    return [[self.rssLinks copy] autorelease];
}

// MARK: - Private

- (NSString *)sourcesFileName {
    return [self.session nameOfFile:UVSourcesFile];
}

@end
