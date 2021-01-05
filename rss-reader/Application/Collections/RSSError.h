//
//  RSSErrorType.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/27/20.
//

#ifndef RSSErrorType_h
#define RSSErrorType_h

typedef NS_ENUM(NSInteger, RSSError) {
    RSSErrorTypeBadNetwork,
    RSSErrorTypeBadURL,
    RSSErrorTypeParsingError,
    RSSErrorNoRSSLinks
};

#endif /* RSSErrorType_h */
