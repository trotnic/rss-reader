//
//  UVSourceRepository.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import "UVSourceRepository.h"
#import "KeyConstants.h"
#import "NSArray+Util.h"

@interface UVSourceRepository ()

@property (nonatomic, copy) NSString *path;

@end

@implementation UVSourceRepository

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _path = [path copy];
    }
    return self;
}

- (void)dealloc
{
    [_path release];
    [super dealloc];
}

- (NSArray<NSDictionary *> *)fetchData:(out NSError **)error {
    NSData *data = [NSData dataWithContentsOfFile:self.path];
    if (!data) {
        return @[];
    }
    return [NSPropertyListSerialization propertyListWithData:data
                                                     options:0
                                                      format:nil
                                                       error:error];
}

- (BOOL)updateData:(NSArray<NSDictionary *> *)data error:(out NSError **)error {
    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:data
                                                               format:NSPropertyListXMLFormat_v1_0
                                                              options:0
                                                                error:error];
    [plist writeToFile:self.path atomically:YES];
    return YES;
}

@end
