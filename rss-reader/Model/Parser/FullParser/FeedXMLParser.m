//
//  UVFeedXMLParser.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "UVFeedXMLParser.h"
#import "UVFeedChannel.h"
#import "NSXMLParser+DelegateInitializable.h"
#import "TagKeys.h"
#import "TagAttributeKeys.h"
#import "AtomKeys.h"

typedef void(^ParseHandler)(UVFeedChannel *_Nullable, NSError *_Nullable);

@interface UVFeedXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) ParseHandler completion;

// MARK: - Channel
@property (nonatomic, retain) UVFeedChannel *channel;
@property (nonatomic, retain) NSMutableDictionary *channelDictionary;
@property (nonatomic, retain) NSMutableArray<UVFeedItem *> *items;

// MARK: - Item
@property (nonatomic, retain) NSMutableDictionary *itemDictionary;
@property (nonatomic, retain) NSMutableString *parsingString;

// MARK: - Util
@property (nonatomic, assign) BOOL isItem;
@property (nonatomic, retain) NSXMLParser *parser;

@property (nonatomic, retain) NSSet<NSString *> *plainTextNodes;

@end

@implementation UVFeedXMLParser

+ (instancetype)parser {
    return [[FeedXMLParser new] autorelease];
}

// MARK: FeedParserType

- (void)parseData:(NSData *)data completion:(ParseHandler)completion {
    self.completion = completion;
    self.parser = [NSXMLParser parserWithData:data delegate:self];
    [self.parser parse];
    if(!data) {
        completion(nil, self.parser.parserError);
        [self.parser abortParsing];
    }
}

- (void)parseContentsOfURL:(NSURL *)url completion:(ParseHandler)completion {
    self.completion = completion;
    self.parser = [NSXMLParser parserWithURL:url delegate:self];
    [self.parser parse];
    if(!url) {
        completion(nil, self.parser.parserError);
        [self.parser abortParsing];
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
    
    if([elementName isEqualToString:channelTag]) {
        self.isItem = NO;
    }
    
    if([elementName isEqualToString:atomLink]) {
        self.channelDictionary[kRSSChannelLink] = attributeDict[hrefAttr];
    }
    
    if([elementName isEqualToString:itemTag]) {
        self.isItem = YES;
        self.itemDictionary = [NSMutableDictionary dictionary];
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

    if([elementName isEqualToString:channelTag]) {
        [self.channelDictionary setValue:self.items forKey:kRSSChannelItems];
        UVFeedChannel *channel = [UVFeedChannel objectWithDictionary:self.channelDictionary];
        if(channel) {
            self.channel = channel;
        } else {
            [parser abortParsing];
        }
        
        [_channelDictionary release];
        _channelDictionary = nil;
    }
    
    if([self.plainTextNodes containsObject:elementName]) {
        NSString *result = [self.parsingString stringByReplacingOccurrencesOfString:@"<[^>]+>"
                                                                         withString:@""
                                                                            options:NSRegularExpressionSearch
                                                                              range:NSMakeRange(0, self.parsingString.length)];
        if(self.isItem) {
            self.itemDictionary[elementName] = result;
        } else {
            self.channelDictionary[elementName] = result;
        }
        
        [_parsingString release];
        _parsingString = nil;
    }
    
    if([elementName isEqualToString:kRSSItem]) {
        UVFeedItem *item = [UVFeedItem objectWithDictionary:self.itemDictionary];
        if(item) {
            [self.items addObject:item];
        }
        self.isItem = NO;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if(self.completion) {
        self.completion(self.channel, nil);
        [_items release];
        _items = nil;
        [_parser release];
        _parser = nil;
        [_channel release];
        _channel = nil;
        [_completion release];
        _completion = nil;
        [_parsingString release];
        _parsingString = nil;
        [_itemDictionary release];
        _itemDictionary = nil;
        [_channelDictionary release];
        _channelDictionary = nil;
    }
}

// MARK: - Lazy

- (NSMutableArray<UVFeedItem *> *)items {
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

- (NSSet<NSString *> *)plainTextNodes {
    if(!_plainTextNodes) {
        _plainTextNodes = [[NSSet setWithArray:@[
            titleTag,
            linkTag,
            kRSSItemCategory,
            kRSSItemPubDate,
            kRSSItemSummary,
            kRSSChannelTitle,
            kRSSChannelDescription
        ]] retain];
    }
    return _plainTextNodes;
}

- (void)dealloc
{    
    [_items release];
    _items = nil;
    [_parser release];
    _parser = nil;
    [_channel release];
    _channel = nil;
    [_completion release];
    _completion = nil;
    [_parsingString release];
    _parsingString = nil;
    [_itemDictionary release];
    _itemDictionary = nil;
    [_channelDictionary release];
    _channelDictionary = nil;
    [_plainTextNodes release];
    _plainTextNodes = nil;
    [super dealloc];
}

@end
