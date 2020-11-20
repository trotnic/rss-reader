//
//  FeedXMLParser.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedXMLParser.h"
#import "FeedChannel.h"

@interface FeedXMLParser () <NSXMLParserDelegate>

@property (nonatomic, copy) ParseHandler completion;

// MARK: - Channel
@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, retain) NSMutableDictionary *channelDictionary;
@property (nonatomic, retain) NSMutableArray<FeedItem *> *items;

// MARK: - Item
@property (nonatomic, retain) NSMutableDictionary *itemDictionary;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, retain) NSMutableArray<MediaContent *> *mediaContent;

// MARK: - Util
@property (nonatomic, assign) BOOL isItem;

@end

@implementation FeedXMLParser

- (void)parseFeed:(NSData *)data completion:(ParseHandler)completion {
    self.completion = completion;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    [parser release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if(self.completion) {
        self.completion(nil, parseError);
    }
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if([elementName isEqualToString:kRSSChannel]) {
        _isItem = NO;
        _channelDictionary = [NSMutableDictionary new];
        _items = [NSMutableArray new];
    }
    
    if ([elementName isEqualToString:kRSSItem]) {
        self.isItem = YES;
        self.itemDictionary = [NSMutableDictionary dictionary];
        self.mediaContent = [NSMutableArray array];
    }
    
    if([elementName isEqualToString:kRSSItemTitle] ||
       [elementName isEqualToString:kRSSItemLink] ||
       [elementName isEqualToString:kRSSItemCategory] ||
       [elementName isEqualToString:kRSSItemPubDate] ||
       
       [elementName isEqualToString:kRSSChannelTitle] ||
       [elementName isEqualToString:kRSSChannelLink] ||
       [elementName isEqualToString:kRSSChannelDescription]) {
        self.parsingString = [NSMutableString string];
    }
    
    if([elementName isEqualToString:kRSSItemSummary]) {
        self.parsingString = [NSMutableString stringWithFormat:@"%@", attributeDict[@"src"]];
    }
    
    if([elementName isEqualToString:kRSSMediaContent]) {
        MediaContent *content = [[MediaContent alloc] initWithDictionary:attributeDict];
        [self.mediaContent addObject:content];
        [content release];
    }
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:kRSSChannel]) {
        [self.channelDictionary setValue:self.items forKey:kRSSChannelItems];
        FeedChannel *channel = [[FeedChannel alloc] initWithDictionary:self.channelDictionary];
        self.channel = channel;
        [channel release];
        
        [_channelDictionary release];
        _channelDictionary = nil;
    }
    
    if([elementName isEqualToString:kRSSItemTitle] ||
       [elementName isEqualToString:kRSSItemLink] ||
       [elementName isEqualToString:kRSSItemCategory] ||
       [elementName isEqualToString:kRSSItemPubDate] ||
       
       [elementName isEqualToString:kRSSChannelTitle] ||
       [elementName isEqualToString:kRSSChannelLink] ||
       [elementName isEqualToString:kRSSChannelDescription]) {
        
        if(self.isItem) {
            self.itemDictionary[elementName] = self.parsingString;
        } else {
            self.channelDictionary[elementName] = self.parsingString;
        }
        
        [_parsingString release];
        _parsingString = nil;
    }
    
    if([elementName isEqualToString:kRSSItem]) {
        [self.itemDictionary setValue:self.mediaContent forKey:kRSSMediaContent];
        FeedItem *item = [[FeedItem alloc] initWithDictionary:self.itemDictionary];
        [self.items addObject:item];
        [item release];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if(self.completion) {
        self.completion(self.channel, nil);
        [_channel release];
    }
}

- (void)dealloc
{
    [_parsingString release];
    [_mediaContent release];
    [_items release];
    [_itemDictionary release];
    [_completion release];
    [_channel release];
    [_channelDictionary release];
    [super dealloc];
}

@end
