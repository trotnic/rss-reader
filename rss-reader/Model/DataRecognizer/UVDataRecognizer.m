//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"
#import "UVRSSLinkXMLParser.h"

NSString *const linkTagPattern = @"<link[^>]+type=\"application[/]rss[+]xml\".*>";
NSString *const hrefAttributePattern = @"(?<=\\bhref=\")[^\"]*";
NSString *const titleAttributePattern = @"(?<=\\btitle=\")[^\"]*";
NSString *const titleTagPattern = @"(?<=<title>).*(?=<\\/title>)";

NSString *const rssTagPattern = @"<rss.*version=\"\\d.\\d\"";

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

- (void)processData:(NSData *)data
             parser:(id<FeedParserType>)parser
         completion:(void (^)(FeedChannel *, RSSError))completion {
    [parser retain];
    
    [parser parseData:data withCompletion:^(FeedChannel *result, NSError *error) {
        if (error) {
            completion(nil, RSSErrorTypeParsingError);
            [parser release];
            return;
        }
        completion(result, RSSErrorTypeNone);
        [parser release];
    }];
}

- (void)processData:(NSData *)data
         completion:(void (^)(NSArray<RSSLink *> *, RSSError))completion {
    NSString *html = [NSString stringWithUTF8String:data.bytes];
    NSRegularExpression *rssRegEx = [NSRegularExpression regularExpressionWithPattern:rssTagPattern
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:nil];
    NSTextCheckingResult *checkingResult = [rssRegEx firstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
    if (checkingResult != nil) {
        [UVRSSLinkXMLParser.parser parseData:data completion:^(RSSLink *link, NSError *error) {
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

- (NSArray<RSSLink *> *)findLinks:(NSString *)html {
    NSMutableArray<RSSLink *> *result = [NSMutableArray array];
    NSArray<NSTextCheckingResult *> *matches = [self.regExps[@"link"] matchesInString:html
                                                                              options:0
                                                                                range:NSMakeRange(0, html.length)];
    if (!matches.count) {
        return @[];
    }
    
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        NSString *linkString = [html substringWithRange:[obj range]];
        NSRange searchRange = NSMakeRange(0, linkString.length);
        NSTextCheckingResult *hrefMatch = [self.regExps[@"href"] firstMatchInString:linkString options:0 range:searchRange];
        NSTextCheckingResult *titleMatch = [self.regExps[@"title"] firstMatchInString:linkString options:0 range:searchRange];
        
        NSString *hrefString = [linkString substringWithRange:[hrefMatch range]];
        NSString *titleString = [linkString substringWithRange:[titleMatch range]];
        [result addObject:[[[RSSLink alloc] initWithTitle:titleString link:hrefString] autorelease]];
    }];
    
    return [[result copy] autorelease];
}

// MARK: - Lazy

- (NSDictionary *)regExps {
    if(!_regExps) {
        _regExps = [@{
            @"link" : [NSRegularExpression regularExpressionWithPattern:linkTagPattern options:NSRegularExpressionCaseInsensitive error:nil],
            @"title" : [NSRegularExpression regularExpressionWithPattern:titleAttributePattern options:NSRegularExpressionCaseInsensitive error:nil],
            @"href" : [NSRegularExpression regularExpressionWithPattern:hrefAttributePattern options:NSRegularExpressionCaseInsensitive error:nil],
            @"rssTag" : [NSRegularExpression regularExpressionWithPattern:rssTagPattern options:NSRegularExpressionCaseInsensitive error:nil]
        } retain];
    }
    return _regExps;
}

@end
