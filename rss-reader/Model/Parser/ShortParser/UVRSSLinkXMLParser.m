//
//  UVRSSLinkXMLParser.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 28.12.20.
//

#import "UVRSSLinkXMLParser.h"
#import "NSXMLParser+DelegateInitializable.h"

#import "UVRSSLinkKeys.h"

#import "AtomKeys.h"
#import "TagKeys.h"
#import "TagAttributeKeys.h"

@interface UVRSSLinkXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) void(^completion)(NSDictionary *, NSError *);
@property (nonatomic, retain) NSXMLParser *parser;


@property (nonatomic, retain) NSMutableDictionary *linkDictionary;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, assign) BOOL isEndChannel;

@end

@implementation UVRSSLinkXMLParser

- (void)dealloc
{
    [_parser release];
    [_linkDictionary release];
    [_parsingString release];
    [_completion release];
    [super dealloc];
}

- (void)parseData:(NSData *)data
       completion:(void (^)(NSDictionary *, NSError *))completion {
    self.completion = completion;
    self.parser = [NSXMLParser parserWithData:data delegate:self];
    [self.parser parse];
}

// MARK: - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.completion(nil, parseError);
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
    
    if([elementName isEqualToString:atomLink]) {
        self.linkDictionary[kRSSLinkURL] = attributeDict[hrefAttr];
    }
    self.parsingString = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:titleTag] && !self.isEndChannel) {
        self.linkDictionary[kRSSLinkTitle] = self.parsingString;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.completion(self.linkDictionary, nil);
}

@end
