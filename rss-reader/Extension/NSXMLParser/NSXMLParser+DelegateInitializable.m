//
//  NSXMLParser+DelegateInitializable.m
//  rss-reader
//
//  Created by Uladzislau on 11/24/20.
//

#import "NSXMLParser+DelegateInitializable.h"

@implementation NSXMLParser (DelegateInitializable)

+ (instancetype)parserWithData:(NSData *)data
                      delegate:(id<NSXMLParserDelegate>)delegate {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = delegate;
    return parser;
}

+ (instancetype)parserWithURL:(NSURL *)url
                     delegate:(id<NSXMLParserDelegate>)delegate {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = delegate;
    return parser;
}

@end
