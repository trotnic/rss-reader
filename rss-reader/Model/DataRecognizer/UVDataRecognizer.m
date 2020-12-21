//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"
#import "NSRegularExpression+PrettyInitializable.h"

NSString *const linkTagPattern = @"<link.*type=\"application[/]rss[+]xml\".*>";
NSString *const hrefAttributePattern = @"(?<=\\bhref=\")[^\"]*";
NSString *const titleAttributePattern = @"(?<=\\btitle=\")[^\"]*";
NSString *const titleTagPattern = @"(?<=<title>).*(?=<\\/title>)";

@interface UVDataRecognizer ()

@end

@implementation UVDataRecognizer

// MARK: -

- (void)findOnURL:(NSURL *)url withCompletion:(void(^)(RSSSource *))completion {
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:url
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSRegularExpression *hrefReg = [NSRegularExpression expressionWithPattern:hrefAttributePattern];
        NSRegularExpression *titleReg = [NSRegularExpression expressionWithPattern:titleAttributePattern];
        NSRegularExpression *linkReg = [NSRegularExpression expressionWithPattern:linkTagPattern];
        NSRegularExpression *titleTagReg = [NSRegularExpression expressionWithPattern:titleTagPattern];
        
        NSMutableArray<RSSLink *> *result = [NSMutableArray array];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray<NSTextCheckingResult *> *matches = [linkReg matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        

        
        NSTextCheckingResult *titleMatch = [titleTagReg firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        NSString *sourceTitle = [string substringWithRange:[titleMatch range]];
        
        [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
            NSString *linkString = [string substringWithRange:[obj range]];
            NSRange searchRange = NSMakeRange(0, linkString.length);
            NSTextCheckingResult *hrefMatch = [hrefReg firstMatchInString:linkString options:0 range:searchRange];
            NSTextCheckingResult *titleMatch = [titleReg firstMatchInString:linkString options:0 range:searchRange];
            
            NSString *hrefString = [linkString substringWithRange:[hrefMatch range]];
            NSString *titleString = [linkString substringWithRange:[titleMatch range]];
            [result addObject:[[[RSSLink alloc] initWithTitle:titleString link:hrefString selected:NO] autorelease]];
        }];
        
        completion([[RSSSource alloc] initWithTitle:sourceTitle url:url links:result selected:NO]);
    }];
    
    [task resume];
}

@end
