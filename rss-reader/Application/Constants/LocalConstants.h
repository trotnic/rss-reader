//
//  LocaleConstants.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 11/27/20.
//

#ifndef LocalConstants_h
#define LocalConstants_h

// TITLES

static NSString *const RSS_LINKS_TITLE                      = @"RSS feeds";
static NSString *const DONE_LIST                            = @"Done list";

// PLACEHOLDERS

static NSString *const SEARCH_RSS_SOURCE_PLACEHOLDER        = @"Feed address";
static NSString *const DONE                                 = @"Done";
static NSString *const READ                                 = @"Read";
static NSString *const DELETE                               = @"Delete";

// ALERTS

static NSString *const ALERT_OK_BUTTON_TITLE                = @"OK";

static NSString *const NO_NETWORK_CONNECTION_TITLE          = @"No internet connection";
static NSString *const NO_NETWORK_CONNECTION_DESCRIPTION    = @"Check your internet connection and try to reload a feed";

static NSString *const BAD_RSS_FEED_TITLE                   = @"RSS error";
static NSString *const BAD_RSS_FEED_DESCRIPTION             = @"Can't recognize RSS feed, use another one";

static NSString *const BAD_URL_TITLE                        = @"URL you input is wrong";
static NSString *const BAD_URL_DESCRIPTION                  = @"Check if you type correct and try again";

static NSString *const NO_RSS_LINKS_DISCOVERED_TITLE        = @"No RSS feeds";
static NSString *const NO_RSS_LINKS_DISCOVERED_DESCRIPTION  = @"Try to input another site address";

static NSString *const NO_RSS_LINK_SELECTED_TITLE           = @"No RSS feed selected";
static NSString *const NO_RSS_LINK_SELECTED_DESCRIPTION     = @"Provide a URL of RSS feed and select it in settings";

// MESSAGES

static NSString *const NO_CONTENTS_MESSAGE                  = @"No contents to show 🙃";

#endif /* LocaleConstants_h */
