//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"

NSString *const linkTagPattern = @"<link.+type=\"application[/]rss[+]xml\".*>";
NSString *const hrefAttributePattern = @"(?<=\\bhref=\")[^\"]*";
NSString *const titleAttributePattern = @"(?<=\\btitle=\")[^\"]*";

@interface UVDataRecognizer ()

@property (nonatomic, retain) NSURL *url;

@property (nonatomic, retain) NSRegularExpression *rssLincReco;
@property (nonatomic, retain) NSRegularExpression *rssHref;

@end

@implementation UVDataRecognizer

// MARK: -

- (NSRegularExpression *)rssLincReco {
    if(!_rssLincReco) {
        _rssLincReco = [[NSRegularExpression regularExpressionWithPattern:linkTagPattern
                                                                  options:NSRegularExpressionCaseInsensitive error:nil] retain];
    }
    return _rssLincReco;
}

- (NSRegularExpression *)rssHref {
    if(!_rssHref) {
        _rssHref = [[NSRegularExpression regularExpressionWithPattern:hrefAttributePattern
                                                              options:NSRegularExpressionCaseInsensitive error:nil] retain];
    }
    return _rssHref;
}

// MARK: -

- (void)findOnURL:(NSURL *)url withCompletion:(void(^)(NSArray<RSSSource *> *))completion {
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:url
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSRegularExpression *hrefReg = [NSRegularExpression regularExpressionWithPattern:hrefAttributePattern
                                                              options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *titleReg = [NSRegularExpression regularExpressionWithPattern:titleAttributePattern
                                                                                  options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *linkReg = [NSRegularExpression regularExpressionWithPattern:linkTagPattern
                                                                                 options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSMutableArray<RSSSource *> *result = [NSMutableArray new];
        NSString *string = [NSString stringWithUTF8String:[data bytes]];
        NSArray<NSTextCheckingResult *> *matches = [linkReg matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *linkString = [string substringWithRange:[obj range]];
            NSTextCheckingResult *hrefMatch = [hrefReg firstMatchInString:linkString options:0 range:NSMakeRange(0, linkString.length)];
            NSTextCheckingResult *titleMatch = [titleReg firstMatchInString:linkString options:0 range:NSMakeRange(0, linkString.length)];
            
            NSString *hrefString = [linkString substringWithRange:[hrefMatch range]];
            NSString *titleString = [linkString substringWithRange:[titleMatch range]];
            [result addObject:[[[RSSSource alloc] initWithTitle:titleString link:hrefString] autorelease]];
        }];
        
        completion([result copy]);
    }];
    
    [task resume];
}

- (NSURL *)url {
    if(!_url) {
        NSString *urlString = [NSUserDefaults.standardUserDefaults stringForKey:@"url_pref"];
        _url = [[NSURL URLWithString:urlString] retain];
    }
    return _url;
}

@end
