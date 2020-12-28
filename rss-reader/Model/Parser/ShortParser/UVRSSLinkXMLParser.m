//
//  UVRSSLinkXMLParser.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.12.20.
//

#import "UVRSSLinkXMLParser.h"
#import "NSXMLParser+DelegateInitializable.h"

@interface UVRSSLinkXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) void(^completion)(RSSLink *, NSError *);
@property (nonatomic, retain) NSXMLParser *parser;


@property (nonatomic, retain) NSMutableDictionary *linkDictionary;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, assign) BOOL isEndChannel;

@end

@implementation UVRSSLinkXMLParser

+ (instancetype)parser {
    return [[UVRSSLinkXMLParser new] autorelease];
}

- (void)parseData:(NSData *)data
       completion:(void (^)(RSSLink *, NSError *))completion {
    self.completion = completion;
    self.parser = [NSXMLParser parserWithData:data delegate:self];
    [self.parser parse];
}

// MARK: - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.isEndChannel = NO;
    self.linkDictionary = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([elementName isEqualToString:@"atom:link"]) {
        self.linkDictionary[@"link"] = attributeDict[@"href"];
    }
    self.parsingString = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"title"] && !self.isEndChannel) {
        self.linkDictionary[@"title"] = self.parsingString;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    RSSLink *link = [[[RSSLink alloc] initWithTitle:self.linkDictionary[@"title"]
                                               link:self.linkDictionary[@"link"]] autorelease];
    self.completion(link, nil);
}

@end
