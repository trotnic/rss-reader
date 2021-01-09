//
//  RSSFeedRawDataFactory.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 2.01.21.
//

#import "RSSDataFactory.h"
#import "NSArray+Util.h"

#import "UVRSSSourceKeys.h"
#import "UVRSSLinkKeys.h"
#import "UVFeedChannelKeys.h"
#import "UVFeedItemKeys.h"

@implementation RSSDataFactory

+ (NSData *)rawGarbageData {
    return [NSData dataWithBytes:(unsigned char[]){0x00} length:1];
}

+ (NSData *)rawXMLData {
    NSString *file = [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingString:@"/tutbyfeed.xml"];
    return [NSData dataWithContentsOfFile:file];
}

+ (NSData *)rawHTMLDataNoRSS {
    NSString *file = [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingString:@"/tutbynorss.html"];
    return [NSData dataWithContentsOfFile:file];
}

+ (NSData *)rawHTMLData {
    NSString *file = [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingString:@"/tutby.html"];
    return [NSData dataWithContentsOfFile:file];
}

+ (NSData *)rawDataNil {
    return nil;
}

+ (UVFeedChannel *)channel {
    NSDictionary *rawChannel = @{
        kRSSChannelTitle : @"TUT.BY: Новости ТУТ - Главные новости",
        kRSSChannelLink : @"https://news.tut.by/rss/index.rss",
        kRSSChannelDescription : @"Последние новости образования, здравоохранения, транспорта, ЖКХ и других сфер. Новости экономики и политики в мире, происшествия и др.",
        kRSSItemPubDate : @"Fri, 01 Jan 2021 20:39:16 +0300",
        kRSSChannelItems : @[
                @{
                    kRSSItemTitle : @" Докшицком районе столкнулись легковушка и маршрутка. Погибли двое детей - 7 и 10 лет",
                    kRSSItemLink : @"https://auto.tut.by/news/accidents/713474.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"Водитель и еще один пассажир Skoda госпитализированы, пассажиры и водитель микроавтобуса не пострадали.",
                    kRSSItemCategory : @"Происшествия",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 16:47:00 +0300"
                },
                @{
                    kRSSItemTitle : @"Местным властям разрешили ввести сбор за выезд за границу на машине",
                    kRSSItemLink : @"https://auto.tut.by/news/road/713455.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"В Беларуси местным властям разрешили ввести сбор для тех, кто пересекает границу на машине. В качестве обоснования приводится консолидация расходов бюджета для борьбы с COVID-19.",
                    kRSSItemCategory : @"Дорога",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 12:38:00 +0300"
                },
                @{
                    kRSSItemTitle : @"Внимание, автовладельцы! Официально ввели транспортный налог и отвязали его от техосмотра",
                    kRSSItemLink : @"https://auto.tut.by/news/road/713454.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"Ставки налога в сравнении с госпошлиной снизятся. Размер транспортного налога будет зависеть от веса и фактического времени владения машиной.",
                    kRSSItemCategory : @"Дорога"
                    ,kRSSItemPubDate : @"Fri, 01 Jan 2021 11:52:00 +0300"
                },
                @{
                    kRSSItemTitle : @"В Беларуси с 1 января выросла базовая величина. А вместе с ней - пособия, выплаты и штрафы",
                    kRSSItemLink : @"https://finance.tut.by/news713451.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"В соответствии с документом размер базовой величины состави",
                    kRSSItemCategory : @"Личный счет",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 11:04:00 +0300"
                },
                @{
                    kRSSItemTitle : @"Экс-президент Украины взял на себя ответственность за операцию «33 боевика из ЧВК Вагнера в Беларуси»",
                    kRSSItemLink : @"https://news.tut.by/economics/713450.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"Он также призвал привлечь к ответственности виновных в срыве операции. Он заявил, что не позволит обесценить «подвиг десятков украинских героев, которые готовили операцию по задержанию тех, кто причастен к крушению самолета MH17».",
                    kRSSItemCategory : @"Деньги и власть",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 10:43:00 +0300"
                },
        ]
    };
    
    return [UVFeedChannel objectWithDictionary:rawChannel];
}

+ (NSDictionary *)rawChannel {
    return @{
        kRSSChannelTitle : @"TUT.BY: Новости ТУТ - Главные новости",
        kRSSChannelLink : @"https://news.tut.by/rss/index.rss",
        kRSSChannelDescription : @"Последние новости образования, здравоохранения, транспорта, ЖКХ и других сфер. Новости экономики и политики в мире, происшествия и др.",
        kRSSItemPubDate : @"Fri, 01 Jan 2021 20:39:16 +0300",
        kRSSChannelItems : @[
                @{
                    kRSSItemTitle : @" Докшицком районе столкнулись легковушка и маршрутка. Погибли двое детей - 7 и 10 лет",
                    kRSSItemLink : @"https://auto.tut.by/news/accidents/713474.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"Водитель и еще один пассажир Skoda госпитализированы, пассажиры и водитель микроавтобуса не пострадали.",
                    kRSSItemCategory : @"Происшествия",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 16:47:00 +0300"
                },
                @{
                    kRSSItemTitle : @"Местным властям разрешили ввести сбор за выезд за границу на машине",
                    kRSSItemLink : @"https://auto.tut.by/news/road/713455.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"В Беларуси местным властям разрешили ввести сбор для тех, кто пересекает границу на машине. В качестве обоснования приводится консолидация расходов бюджета для борьбы с COVID-19.",
                    kRSSItemCategory : @"Дорога",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 12:38:00 +0300"
                },
                @{
                    kRSSItemTitle : @"Внимание, автовладельцы! Официально ввели транспортный налог и отвязали его от техосмотра",
                    kRSSItemLink : @"https://auto.tut.by/news/road/713454.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"Ставки налога в сравнении с госпошлиной снизятся. Размер транспортного налога будет зависеть от веса и фактического времени владения машиной.",
                    kRSSItemCategory : @"Дорога"
                    ,kRSSItemPubDate : @"Fri, 01 Jan 2021 11:52:00 +0300"
                },
                @{
                    kRSSItemTitle : @"В Беларуси с 1 января выросла базовая величина. А вместе с ней - пособия, выплаты и штрафы",
                    kRSSItemLink : @"https://finance.tut.by/news713451.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"В соответствии с документом размер базовой величины состави",
                    kRSSItemCategory : @"Личный счет",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 11:04:00 +0300"
                },
                @{
                    kRSSItemTitle : @"Экс-президент Украины взял на себя ответственность за операцию «33 боевика из ЧВК Вагнера в Беларуси»",
                    kRSSItemLink : @"https://news.tut.by/economics/713450.html?utm_campaign=news-feed&#x26;utm_medium=rss&#x26;utm_source=rss-news",
                    kRSSItemSummary : @"Он также призвал привлечь к ответственности виновных в срыве операции. Он заявил, что не позволит обесценить «подвиг десятков украинских героев, которые готовили операцию по задержанию тех, кто причастен к крушению самолета MH17».",
                    kRSSItemCategory : @"Деньги и власть",
                    kRSSItemPubDate : @"Fri, 01 Jan 2021 10:43:00 +0300"
                },
        ]
    };
}

+ (RSSLink *)linkSelected:(BOOL)selected {
    NSDictionary *rawLink = @{
        kRSSLinkTitle : @"TUT.BY - Главные новости недели",
        kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
        kRSSLinkSelected : [NSNumber numberWithBool:selected]
    };
    return [RSSLink objectWithDictionary:rawLink];
}

+ (RSSSource *)sourceNoLinksSelected:(BOOL)selected {
    NSDictionary *rawSource = @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[],
        kRSSSourceSelected : [NSNumber numberWithBool:selected]
    };
    return [RSSSource objectWithDictionary:rawSource];
}

+ (RSSSource *)sourceWithLinksSelectedYES {
    NSDictionary *rawSource = @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[
                @{
                    kRSSLinkTitle : @"TUT.BY - Главные новости недели",
                    kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Новости компаний",
                    kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
                    kRSSLinkSelected : @(1)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Все новости за день",
                    kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
                    kRSSLinkSelected : @(0)
                }
        ],
        kRSSSourceSelected : @(1)
    };
    return [RSSSource objectWithDictionary:rawSource];
}

+ (NSDictionary *)rawSourceFromHTML {
    return @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[
                @{
                    kRSSLinkTitle : @"TUT.BY - Главные новости недели",
                    kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Новости компаний",
                    kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Все новости за день",
                    kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
                }
        ],
        kRSSSourceSelected : @(0)
    };
}

+ (NSDictionary *)rawLinkFromXML {
    return @{
        kRSSLinkTitle : @"TUT.BY - Главные новости недели",
        kRSSLinkURL : @"https://news.tut.by/rss/index.rss"
    };
}

+ (NSDictionary *)rawSourceFromPlistSelectedYES {
    return @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[
                @{
                    kRSSLinkTitle : @"TUT.BY - Главные новости недели",
                    kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Новости компаний",
                    kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Все новости за день",
                    kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
                    kRSSLinkSelected : @(1)
                }
        ],
        kRSSSourceSelected : @(1)
    };
}

+ (NSDictionary *)rawSourceFromPlistSelectedNO {
    return @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[
                @{
                    kRSSLinkTitle : @"TUT.BY - Главные новости недели",
                    kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Новости компаний",
                    kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Все новости за день",
                    kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
                    kRSSLinkSelected : @(0)
                }
        ],
        kRSSSourceSelected : @(0)
    };
}

+ (RSSSource *)sourceFromPlistSelectedYES {
    NSDictionary *rawSource = @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[
                @{
                    kRSSLinkTitle : @"TUT.BY - Главные новости недели",
                    kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Новости компаний",
                    kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Все новости за день",
                    kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
                    kRSSLinkSelected : @(1)
                }
        ],
        kRSSSourceSelected : @(1)
    };
    return [RSSSource objectWithDictionary:rawSource];
}

+ (RSSSource *)sourceFromPlistSelectedNO {
    NSDictionary *rawSource = @{
        kRSSSourceURL : @"https://www.tut.by",
        kRSSSourceLinks : @[
                @{
                    kRSSLinkTitle : @"TUT.BY - Главные новости недели",
                    kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Новости компаний",
                    kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
                    kRSSLinkSelected : @(0)
                },
                @{
                    kRSSLinkTitle : @"TUT.BY - Все новости за день",
                    kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
                    kRSSLinkSelected : @(0)
                }
        ],
        kRSSSourceSelected : @(0)
    };
    return [RSSSource objectWithDictionary:rawSource];
}

+ (NSArray<NSDictionary *> *)rawLinksFromHTML {
    return @[
        @{
            kRSSLinkTitle : @"TUT.BY - Главные новости недели",
            kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
        },
        @{
            kRSSLinkTitle : @"TUT.BY - Новости компаний",
            kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
        },
        @{
            kRSSLinkTitle : @"TUT.BY - Все новости за день",
            kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
        }
    ];
}

+ (NSArray<RSSLink *> *)links {
    NSArray<NSDictionary *> *rawLinks = @[
        @{
            kRSSLinkTitle : @"TUT.BY - Главные новости недели",
            kRSSLinkURL : @"https://news.tut.by/rss/index.rss",
        },
        @{
            kRSSLinkTitle : @"TUT.BY - Новости компаний",
            kRSSLinkURL : @"https://news.tut.by/rss/press.rss",
        },
        @{
            kRSSLinkTitle : @"TUT.BY - Все новости за день",
            kRSSLinkURL : @"https://news.tut.by/rss/all.rss",
        }
    ];
    return [[rawLinks map:^id(NSDictionary *rawLink) {
        return [RSSLink objectWithDictionary:rawLink];
    }] autorelease];
}

@end
