//
//  FeedXMLParser.m
//  rss-reader
//
//  Created by Uladzislau on 11/17/20.
//

#import "FeedXMLParser.h"

@interface FeedXMLParser () 

@property (nonatomic, copy) ParseHandler completion;

@property (nonatomic, retain) NSMutableArray<FeedItem *> *results;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSMutableString *parsingString;
@property (nonatomic, retain) NSMutableArray *mediaLinks;

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
    NSString *tagName = @"item";
    
    if ([elementName isEqualToString:tagName]) {
        self.item = [NSMutableDictionary dictionary];
        self.mediaLinks = [NSMutableArray array];
    }
    
    [tagName release];
    tagName = @"title";
    if([elementName isEqualToString:tagName] ||
       [elementName isEqualToString:@"link"]) {
        self.parsingString = [NSMutableString string];
    }
    
    if([elementName isEqualToString:@"description"]) {
        self.parsingString = [NSMutableString stringWithFormat:@"%@", [attributeDict valueForKey:@"src"]];
    }
    
    if([elementName isEqualToString:@"media:content"]) {
        [self.mediaLinks addObject:[attributeDict valueForKey:@"url"]];
    }
    
    [tagName release];
    
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"title"] ||
       [elementName isEqualToString:@"link"] ||
       [elementName isEqualToString:@"img"]) {
        [self.item setValue:self.parsingString forKey:elementName];
        self.parsingString = nil;
    }
    
    if([elementName isEqualToString:@"item"]) {
        [self.item setValue:self.mediaLinks forKey:@"mediaLinks"];
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
    [_mediaLinks release];
    [_results release];
    [_item release];
    [_completion release];
    [super dealloc];
}

@end
