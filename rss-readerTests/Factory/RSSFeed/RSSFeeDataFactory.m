//
//  RSSFeedRawDataFactory.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "RSSFeeDataFactory.h"

@implementation RSSFeeDataFactory

+ (NSData *)rawData {
    NSString *file = [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingString:@"/tutbyfeed.xml"];
    return [NSData dataWithContentsOfFile:file];
}

+ (UVFeedChannel *)channel {
    NSDictionary *itemDictionary =  @{
        @"title" : @"Соболенко, Басков, Недосеков и другие спортсмены снялись в новогоднем обращении Лукашенко",
        @"link" : @"https://sport.tut.by/news/aboutsport/713460.html?utm_campaign=news-feed&utm_medium=rss&utm_source=rss-news"
    };
    UVFeedItem *item = [UVFeedItem objectWithDictionary:itemDictionary];
    NSDictionary *rawChannel = @{
        @"title" : @"TUT.BY: Новости ТУТ - Главные новости",
        @"link" : @"https://news.tut.by/rss/index.rss",
        @"description" : @"",
        @"items" : @[
                item
        ]
    };
    
    return [UVFeedChannel objectWithDictionary:rawChannel];
}

@end
