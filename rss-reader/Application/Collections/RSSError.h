//
//  RSSErrorType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/27/20.
//

#ifndef RSSError_h
#define RSSError_h

typedef NS_ENUM(NSInteger, RSSError) {
    RSSErrorTypeNoNetworkConnection,
    RSSErrorTypeBadURL,
    RSSErrorTypeParsingError,
    RSSErrorNoRSSLinksDiscovered,
    RSSErrorNoRSSLinkSelected
};

#endif /* RSSError_h */
