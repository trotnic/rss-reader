//
//  UVRSSParser.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 7.12.20.
//

#import "UVRSSLinksParser.h"
#import <libxml2/libxml/parser.h>
#import "NSXMLParser+DelegateInitializable.h"

@interface UVRSSLinksParser () <NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableArray<NSString *> *links;
@property (nonatomic, copy) void(^completion)(NSArray<NSString *> *, NSError *);

@end

@implementation UVRSSLinksParser

- (void)dealloc
{
    [_links release];
    [_completion release];
    [super dealloc];
}

static void print_element_names(xmlNode * a_node)
 {
     xmlNode *cur_node = NULL;
 
     for (cur_node = a_node; cur_node; cur_node =
         cur_node->next) {
      if (cur_node->type == XML_ELEMENT_NODE) {
          printf("node type: Element, name: %s\n",
               cur_node->name);
       }
       print_element_names(cur_node->children);
    }
}

- (void)parseContentsOfURL:(NSURL *)url withCompletion:(void(^)(NSArray<NSString *> *, NSError *))completion {
    xmlDoc *doc = xmlReadFile("http://www.tut.by", NULL, 0);
    xmlNode *root_element = NULL;
    
    if (!doc) {
        completion(nil, nil);
        return;
    }
    
    root_element = xmlDocGetRootElement(doc);
    print_element_names(root_element);
    xmlFreeDoc(doc);       // free document
    xmlCleanupParser();    // Free globals
}

- (void)parseContentsOfData:(NSData *)data
             withCompletion:(void(^)(NSArray<NSString *> *, NSError *))completion {
    self.completion = completion;
    
}

@end
