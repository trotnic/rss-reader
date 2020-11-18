//
//  FeedXMLParser.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedXMLParser.h"
#import "FeedChannel.h"

@interface FeedXMLParser () 

@property (nonatomic, copy) ParseHandler completion;

// MARK: Channel -
@property (nonatomic, retain) NSMutableArray<FeedItem *> *results;

// MARK: Item -
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, retain) NSMutableArray<MediaContent *> *mediaContent;

@end

@implementation FeedXMLParser

- (void)parseFeed:(NSData *)data
       completion:(ParseHandler)completion {
    self.completion = completion;
    self.results = [NSMutableArray array];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"item"]) {
        self.item = [NSMutableDictionary dictionary];
        self.mediaContent = [NSMutableArray array];
    }
    
    if([elementName isEqualToString:@"title"] ||
       [elementName isEqualToString:@"link"] ||
       [elementName isEqualToString:@"category"] ||
       [elementName isEqualToString:@"pubDate"]) {
        self.parsingString = [NSMutableString string];
    }
    
    if([elementName isEqualToString:@"description"]) {
        self.parsingString = [NSMutableString stringWithFormat:@"%@", [attributeDict valueForKey:@"src"]];
    }
    
    if([elementName isEqualToString:@"media:content"]) {
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
    
    
    // TODO: parse description
    if([elementName isEqualToString:@"title"] ||
       [elementName isEqualToString:@"link"] ||
       [elementName isEqualToString:@"category"] ||
       [elementName isEqualToString:@"pubDate"]) {
        [self.item setValue:self.parsingString forKey:elementName];
        self.parsingString = nil;
    }
    
    
    if([elementName isEqualToString:@"item"]) {
        [self.item setValue:self.mediaContent forKey:@"mediaContent"];
        FeedItem *item = [[FeedItem alloc] initWithDictionary:self.item];
        [self.results addObject:item];
        [item release];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.completion(self.results, nil);
}

- (void)dealloc
{
    [_parsingString release];
    [_mediaContent release];
    [_results release];
    [_item release];
    [_completion release];
    [super dealloc];
}

@end
