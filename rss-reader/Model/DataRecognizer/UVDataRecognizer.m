//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"
#import "UVRSSLinkXMLParser.h"
#import "NSArray+Util.h"

#define LINK_TAG_PATTERN    @"<link[^>]+type=\"application[/]rss[+]xml\".*>"
#define HREF_ATTR_PATTERN   @"(?<=\\bhref=\")[^\"]*"
#define TITLE_ATTR_PATTERN  @"(?<=\\btitle=\")[^\"]*"
#define TITLE_TAG_PATTERN   @"(?<=<title>).*(?=<\\/title>)"
#define RSS_TAG_PATTERN     @"<rss.*version=\"\\d.\\d\""

#define KEY_TITLE           @"title"
#define KEY_HREF            @"href"
#define KEY_LINK            @"link"
#define KEY_RSSTAG          @"rssTag"

@interface UVDataRecognizer ()

@property (nonatomic, retain) NSDictionary<NSString *, NSRegularExpression *> *regExps;

@end

@implementation UVDataRecognizer

- (void)dealloc
{
    [_regExps release];
    [super dealloc];
}

// MARK: - UVDataRecognizerType

- (void)discoverChannel:(NSData *)data
                 parser:(id<FeedParserType>)parser
             completion:(void (^)(FeedChannel *, RSSError))completion {
    [parser retain];
    
    [parser parseData:data
           completion:^(FeedChannel *result, NSError *error) {
        if (error) {
            completion(nil, RSSErrorTypeParsingError);
            [parser release];
            return;
        }
        completion(result, RSSErrorTypeNone);
        [parser release];
    }];
}

- (void)discoverLinks:(NSData *)data
           completion:(void (^)(NSArray<RSSLink *> *, RSSError))completion {
    NSString *html = [[[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding] autorelease];
    
    if ([self isRSS:html]) {
        [UVRSSLinkXMLParser.parser parseData:data
                                  completion:^(RSSLink *link, NSError *error) {
            completion(@[link], RSSErrorTypeNone);
        }];
        return;
    }
    NSArray *links = [self findLinks:html];
    
    if (!links.count) {
        completion(nil, RSSErrorNoRSSLinks);
        return;
    }
    
    completion(links, RSSErrorTypeNone);
}

// MARK: - Private

- (BOOL)isRSS:(NSString *)html {
    NSRange matchRange = [self.regExps[KEY_RSSTAG] rangeOfFirstMatchInString:html
                                                                     options:0
                                                                       range:NSMakeRange(0, html.length)];
    return matchRange.location != NSNotFound;
}

- (NSArray<RSSLink *> *)findLinks:(NSString *)html {
    NSMutableArray<RSSLink *> *result = [NSMutableArray array];
    
    [self.regExps[KEY_LINK] enumerateMatchesInString:html
                                             options:0
                                               range:NSMakeRange(0, html.length)
                                          usingBlock:^(NSTextCheckingResult *obj, NSMatchingFlags flags, BOOL *stop) {
        NSString *linkString = [html substringWithRange:[obj range]];
        NSRange searchRange = NSMakeRange(0, linkString.length);
        NSRange hrefRange = [self.regExps[KEY_HREF] rangeOfFirstMatchInString:linkString options:0 range:searchRange];
        NSRange titleRange = [self.regExps[KEY_TITLE] rangeOfFirstMatchInString:linkString options:0 range:searchRange];
        
        NSString *hrefString = [linkString substringWithRange:hrefRange];
        NSString *titleString = [linkString substringWithRange:titleRange];
        [result addObject:[[[RSSLink alloc] initWithTitle:titleString link:hrefString] autorelease]];
    }];
    
    return [[result copy] autorelease];
}

// MARK: - Lazy

- (NSDictionary *)regExps {
    if(!_regExps) {
        _regExps = [@{
            KEY_LINK : [NSRegularExpression regularExpressionWithPattern:LINK_TAG_PATTERN options:NSRegularExpressionCaseInsensitive error:nil],
            KEY_TITLE : [NSRegularExpression regularExpressionWithPattern:TITLE_ATTR_PATTERN options:NSRegularExpressionCaseInsensitive error:nil],
            KEY_HREF : [NSRegularExpression regularExpressionWithPattern:HREF_ATTR_PATTERN options:NSRegularExpressionCaseInsensitive error:nil],
            KEY_RSSTAG : [NSRegularExpression regularExpressionWithPattern:RSS_TAG_PATTERN options:NSRegularExpressionCaseInsensitive error:nil]
        } retain];
    }
    return _regExps;
}

@end
