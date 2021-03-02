//
//  UVRSSLinkXMLParser.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.12.20.
//

#import "UVRSSLinkXMLParser.h"
#import "NSXMLParser+DelegateInitializable.h"

#import "UVRSSLinkKeys.h"
#import "UVErrorDomain.h"

#import "TagKeys.h"
#import "TagAttributeKeys.h"

@interface UVRSSLinkXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) void(^completion)(NSDictionary *, NSError *);
@property (nonatomic, retain) NSXMLParser *parser;

@property (nonatomic, retain) NSMutableDictionary *linkDictionary;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, assign) BOOL isEndChannel;
@property (nonatomic, assign) BOOL isItem;

@end

@implementation UVRSSLinkXMLParser

- (void)dealloc
{
    [_parser release];
    [_completion release];
    [_parsingString release];
    [_linkDictionary release];
    [super dealloc];
}

- (void)parseData:(NSData *)data completion:(void (^)(NSDictionary *, NSError *))completion {
    if (!data) {
        if (completion) completion(nil, [self parsingError]);
        return;
    }
    self.completion = completion;
    self.parser = [NSXMLParser parserWithData:data delegate:self];
    [self.parser parse];
    if (self.parser.parserError != nil) {
        [self.parser abortParsing];
        if (completion) completion(nil, self.parser.parserError);
        return;
    }
}

// MARK: - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) self.completion(nil, parseError);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.isEndChannel = NO;
    self.linkDictionary = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([elementName isEqualToString:TAG_ITEM]) {
        self.isItem = YES;
    }
    self.parsingString = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:TAG_TITLE] && !self.isEndChannel && !self.isItem) {
        self.linkDictionary[kRSSLinkTitle] = self.parsingString;
    }
    if([elementName isEqualToString:TAG_ITEM]) {
        self.isItem = NO;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.completion) {
        NSDictionary *linkCopy = [[self.linkDictionary copy] autorelease];
        self.completion(linkCopy, nil);
    }
}

// MARK: - Private

- (NSError *)parsingError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

@end
