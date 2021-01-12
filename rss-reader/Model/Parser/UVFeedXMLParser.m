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

typedef void(^ParseHandler)(NSDictionary *_Nullable, NSError *_Nullable);

@interface UVFeedXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) ParseHandler completion;

// MARK: - Channel
@property (nonatomic, retain) NSMutableDictionary *channelDictionary;
@property (nonatomic, retain) NSMutableArray<NSDictionary *> *items;

// MARK: - Item
@property (nonatomic, retain) NSMutableDictionary *itemDictionary;
@property (nonatomic, assign) BOOL isItem;

// MARK: - Util
@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableString *parsingString;

@property (nonatomic, retain) NSSet<NSString *> *plainTextNodes;

@end

@implementation UVFeedXMLParser

// MARK: FeedParserType

- (void)parseData:(NSData *)data
       completion:(ParseHandler)completion {
    if (!data) {
        completion(nil, [self parsingError]);
        return;
    }
    self.completion = completion;
    self.parser = [NSXMLParser parserWithData:data delegate:self];
    [self.parser parse];
    if (self.parser.parserError != nil) {
        completion(nil, self.parser.parserError);
        [self.parser abortParsing];
        return;
    }
}

- (void)parseContentsOfURL:(NSURL *)url
                completion:(ParseHandler)completion {
    if (!url) {
        completion(nil, [self parsingError]);
        return;
    }
    self.completion = completion;
    self.parser = [NSXMLParser parserWithURL:url delegate:self];
    [self.parser parse];
    if (self.parser.parserError != nil) {
        completion(nil, self.parser.parserError);
        [self.parser abortParsing];
        return;
    }
}

// MARK: - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.completion(nil, parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([elementName isEqualToString:TAG_CHANNEL]) {
        self.isItem = NO;
    }
    
    if([elementName isEqualToString:ATOM_LINK]) {
        self.channelDictionary[kRSSChannelLink] = attributeDict[ATTR_HREF];
    }
    
    if([elementName isEqualToString:TAG_ITEM]) {
        self.isItem = YES;
    }
    
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
    
    if([elementName isEqualToString:TAG_CHANNEL]) {
        [self.channelDictionary setValue:self.items forKey:kRSSChannelItems];
    }
    
    if([self.plainTextNodes containsObject:elementName]) {
        if(self.isItem) {
            self.itemDictionary[elementName] = self.parsingString.stringByStrippingHTML;
        } else {
            self.channelDictionary[elementName] = self.parsingString;
        }
        _parsingString = nil;
    }
    
    if([elementName isEqualToString:TAG_ITEM]) {
        [self.items addObject:self.itemDictionary];
        self.isItem = NO;
        
        _itemDictionary = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if(self.completion) {
        self.completion(self.channelDictionary, nil);
        _items = nil;
        _parser = nil;
        _completion = nil;
        _parsingString = nil;
        _itemDictionary = nil;
        _channelDictionary = nil;
    }
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

- (NSMutableDictionary *)channelDictionary {
    if(!_channelDictionary) {
        _channelDictionary = [NSMutableDictionary new];
    }
    return _channelDictionary;
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
