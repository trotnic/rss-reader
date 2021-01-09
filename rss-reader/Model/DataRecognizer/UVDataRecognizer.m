//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"
#import "UVRSSLinkXMLParser.h"
#import "UVErrorDomain.h"

#import "NSString+Util.h"
#import "NSArray+Util.h"

#import "UVRSSLinkKeys.h"
#import "UVRSSSourceKeys.h"

static NSString *const LINK_TAG_PATTERN     = @"<link[^>]+type=\"application[/]rss[+]xml\".*>";
static NSString *const HREF_ATTR_PATTERN    = @"(?<=\\bhref=\")[^\"]*";
static NSString *const TITLE_ATTR_PATTERN   = @"(?<=\\btitle=\")[^\"]*";
static NSString *const RSS_TAG_PATTERN      = @"<rss.*version=\"\\d.\\d\"";
static NSString *const HTML_TAG_PATTERN     = @"<html.*";

static NSString *const KEY_LINK             = @"link";

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
    if (!data || !parser) {
        completion(nil, [self recognitionError]);
        return;
    }
    
    [parser retain];
    
    [parser parseData:data
           completion:^(NSDictionary *result, NSError *error) {
        completion(result, error);
        [parser release];
    }];
}

- (void)discoverLinks:(NSData *)data
           completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    if (!data) {
        completion(nil, [self recognitionError]);
        return;
    }
    
    NSString *html = [NSString htmlStringFromData:data];
    
    if (!html || !html.length || [html isEqualToString:EMPTY_STRING]) {
        completion(nil, [self recognitionError]);
        return;
    }
    
    if ([self isRSS:html]) {
        [self.linkXMLParser parseData:data
                           completion:^(NSDictionary *link, NSError *error) {
            NSArray<NSDictionary *> *result = link == nil ? nil : @[link];
            completion(result, error);
        }];
        return;
    }
    
    if ([self isHTML:html]) {
        NSMutableArray<NSDictionary *> *links = [self findLinks:html];
        
        if (!links.count || !links) {
            completion(nil, [self recognitionError]);
            return;
        }
        
        completion([[links copy] autorelease], nil);
        return;
    }
    
    completion(nil, [self recognitionError]);
}

// MARK: - Private

- (BOOL)isRSS:(NSString *)string {
    return [string rangeOfString:RSS_TAG_PATTERN options:NSRegularExpressionSearch].location != NSNotFound;
}

- (BOOL)isHTML:(NSString *)string {
    return [string rangeOfString:HTML_TAG_PATTERN options:NSRegularExpressionSearch].location != NSNotFound;
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
            KEY_LINK : [self regExpWithPattern:LINK_TAG_PATTERN]
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
