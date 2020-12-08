//
//  UVDataRecognizer.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVDataRecognizer.h"
#import "NSRegularExpression+PrettyInitializable.h"

NSString *const linkTagPattern = @"<link.+type=\"application[/]rss[+]xml\".*>";
NSString *const hrefAttributePattern = @"(?<=\\bhref=\")[^\"]*";
NSString *const titleAttributePattern = @"(?<=\\btitle=\")[^\"]*";

@interface UVDataRecognizer ()

@end

@implementation UVDataRecognizer

// MARK: -

- (void)findOnURL:(NSURL *)url withCompletion:(void(^)(NSArray<RSSSource *> *))completion {
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:url
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSRegularExpression *hrefReg = [NSRegularExpression expressionWithPattern:hrefAttributePattern];
        NSRegularExpression *titleReg = [NSRegularExpression expressionWithPattern:titleAttributePattern];
        NSRegularExpression *linkReg = [NSRegularExpression expressionWithPattern:linkTagPattern];
        
        NSMutableArray<RSSSource *> *result = [NSMutableArray array];
        NSString *string = [NSString stringWithUTF8String:[data bytes]];
        NSArray<NSTextCheckingResult *> *matches = [linkReg matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
            NSString *linkString = [string substringWithRange:[obj range]];
            NSRange searchRange = NSMakeRange(0, linkString.length);
            NSTextCheckingResult *hrefMatch = [hrefReg firstMatchInString:linkString options:0 range:searchRange];
            NSTextCheckingResult *titleMatch = [titleReg firstMatchInString:linkString options:0 range:searchRange];
            
            NSString *hrefString = [linkString substringWithRange:[hrefMatch range]];
            NSString *titleString = [linkString substringWithRange:[titleMatch range]];
            [result addObject:[[[RSSSource alloc] initWithTitle:titleString link:hrefString] autorelease]];
        }];
        
        completion([result copy]);
    }];
    
    [task resume];
}

@end
