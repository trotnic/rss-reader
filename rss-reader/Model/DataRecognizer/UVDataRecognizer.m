//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"
#import "UVRSSLinkXMLParser.h"
#import "UVErrorDomain.h"
#import "NSArray+Util.h"

#import "UVRSSLinkKeys.h"
#import "UVRSSSourceKeys.h"

static NSString *const LINK_TAG_PATTERN     = @"<link[^>]+type=\"application[/]rss[+]xml\".*>";
static NSString *const HREF_ATTR_PATTERN    = @"(?<=\\bhref=\")[^\"]*";
static NSString *const TITLE_ATTR_PATTERN   = @"(?<=\\btitle=\")[^\"]*";
static NSString *const RSS_TAG_PATTERN      = @"<rss.*version=\"\\d.\\d\"";

static NSString *const KEY_LINK             = @"link";
static NSString *const KEY_RSSTAG           = @"rssTag";

static NSString *const EMPTY_STRING         = @"";

@interface UVDataRecognizer ()

@property (nonatomic, retain) NSDictionary<NSString *, NSRegularExpression *> *regExps;
@property (nonatomic, retain) id<UVRSSLinkXMLParserType> linkXMLParser;

@end

@implementation UVDataRecognizer

- (void)dealloc
{
    [_regExps release];
    [_linkXMLParser release];
    [super dealloc];
}

// MARK: - UVDataRecognizerType

- (void)discoverChannel:(NSData *)data
                 parser:(id<UVFeedParserType>)parser
             completion:(void (^)(NSDictionary *, NSError *))completion {
    [parser retain];
    
    [parser parseData:data
           completion:^(NSDictionary *result, NSError *error) {
        if (error) {
            completion(nil, error);
            [parser release];
            return;
        }
        completion(result, nil);
        [parser release];
    }];
}

- (void)discoverLinks:(NSData *)data
           completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    NSString *html = [[[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding] autorelease];
    if ([self isRSS:html]) {
        [self.linkXMLParser parseData:data
                           completion:^(NSDictionary *link, NSError *error) {
            if (error) {
                completion(nil, error);
                return;
            }
            completion(@[link], nil);
        }];
        return;
    }
    NSMutableArray<NSDictionary *> *links = [self findLinks:html];
    
    if (!links.count) {
        completion(nil, [self recognitionError]);
        return;
    }
    
    completion([[links copy] autorelease], nil);
}

// MARK: - Private

- (BOOL)isRSS:(NSString *)html {
    return [self.regExps[KEY_RSSTAG] numberOfMatchesInString:html
                                                     options:0
                                                       range:NSMakeRange(0, html.length)] != 0;
}

- (NSMutableArray<NSDictionary *> *)findLinks:(NSString *)html {
    NSMutableArray<NSDictionary *> *results = [NSMutableArray array];
    
    [self.regExps[KEY_LINK] enumerateMatchesInString:html
                                             options:0
                                               range:NSMakeRange(0, html.length)
                                          usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *linkString = [html substringWithRange:[result range]];
        
        NSRange hrefRange = [linkString rangeOfString:HREF_ATTR_PATTERN options:NSRegularExpressionSearch];
        NSRange titleRange = [linkString rangeOfString:TITLE_ATTR_PATTERN options:NSRegularExpressionSearch];
        
        [results addObject:@{
            kRSSLinkTitle : titleRange.location == NSNotFound ? EMPTY_STRING : [linkString substringWithRange:titleRange],
            kRSSLinkURL : hrefRange.location == NSNotFound ? EMPTY_STRING : [linkString substringWithRange:hrefRange]
        }];
    }];
    
    return results;
}

// MARK: - Private

- (NSError *)recognitionError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:1000 userInfo:nil];
}

- (NSRegularExpression *)regExpWithPattern:(NSString *)pattern {
    return [NSRegularExpression regularExpressionWithPattern:pattern
                                                     options:NSRegularExpressionCaseInsensitive
                                                       error:nil];
}

// MARK: - Lazy

- (NSDictionary *)regExps {
    if(!_regExps) {
        _regExps = [@{
            KEY_LINK : [self regExpWithPattern:LINK_TAG_PATTERN],
            KEY_RSSTAG : [self regExpWithPattern:RSS_TAG_PATTERN]
        } retain];
    }
    return _regExps;
}

- (id<UVRSSLinkXMLParserType>)linkXMLParser {
    if(!_linkXMLParser) {
        _linkXMLParser = [UVRSSLinkXMLParser new];
    }
    return _linkXMLParser;
}

@end
