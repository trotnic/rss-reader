//
//  UVFeedXMLParser.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVFeedXMLParser.h"

#import "NSString+Util.h"
#import "NSXMLParser+DelegateInitializable.h"
#import "UVErrorDomain.h"

#import "TagKeys.h"
#import "AtomKeys.h"
#import "TagAttributeKeys.h"

#import "UVFeedChannelKeys.h"
#import "UVFeedItemKeys.h"

typedef void(^ParseHandler)(NSArray *_Nullable, NSError *_Nullable);

@interface UVFeedXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) ParseHandler completion;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *items;
@property (nonatomic, strong) NSMutableDictionary *itemDictionary;

// MARK: - Util
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableString *parsingString;

@property (nonatomic, strong) NSSet<NSString *> *plainTextNodes;

@end

@implementation UVFeedXMLParser

// MARK: FeedParserType

- (void)parseData:(NSData *)data completion:(ParseHandler)completion {
    if (!data) {
        if (completion) completion(nil, [self parsingError]);
        return;
    }
    self.completion = completion;
    self.parser = [NSXMLParser parserWithData:data delegate:self];
    [self.parser parse];
    if (self.parser.parserError != nil) {
        if (completion) completion(nil, self.parser.parserError);
        [self.parser abortParsing];
        return;
    }
}

// MARK: - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) self.completion(nil, parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([self.plainTextNodes containsObject:elementName]) {
        self.parsingString = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if([self.plainTextNodes containsObject:elementName]) {
        self.itemDictionary[elementName] = self.parsingString.stringByStrippingHTML;
        _parsingString = nil;
    }
    
    if([elementName isEqualToString:TAG_ITEM]) {
        [self.items addObject:self.itemDictionary];
        _itemDictionary = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if(self.completion) self.completion([self.items copy], nil);
}

// MARK: - Private

- (NSError *)parsingError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

// MARK: - Lazy

- (NSMutableArray<NSDictionary *> *)items {
    if(!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}

- (NSMutableDictionary *)itemDictionary {
    if(!_itemDictionary) {
        _itemDictionary = [NSMutableDictionary new];
    }
    return _itemDictionary;
}

- (NSSet<NSString *> *)plainTextNodes {
    if(!_plainTextNodes) {
        _plainTextNodes = [NSSet setWithArray:@[
            TAG_TITLE,
            TAG_LINK,
            TAG_CATEGORY,
            TAG_PUBLICATION_DATE,
            TAG_DESCRIPTION
        ]];
    }
    return _plainTextNodes;
}

@end
