//
//  UVSourceRepository.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 22.12.20.
//

#import "UVSourceRepository.h"

#import "UVErrorDomain.h"
#import "KeyConstants.h"

#import "NSArray+Util.h"

@interface UVSourceRepository ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, retain) dispatch_semaphore_t synchronizationSemaphore;

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
    [_synchronizationSemaphore release];
    [super dealloc];
}

// MARK: - Lazy Properties

- (dispatch_semaphore_t)synchronizationSemaphore {
    if (!_synchronizationSemaphore) {
        _synchronizationSemaphore = dispatch_semaphore_create(1);
    }
    return _synchronizationSemaphore;
}

// MARK: - Interface

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
    dispatch_semaphore_wait(self.synchronizationSemaphore, DISPATCH_TIME_NOW);
    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:data
                                                               format:NSPropertyListXMLFormat_v1_0
                                                              options:0
                                                                error:error];
    if (![plist writeToFile:self.path atomically:YES]) {
        if (error) *error = [self repositoryError];
        dispatch_semaphore_signal(self.synchronizationSemaphore);
        return NO;
    }
    dispatch_semaphore_signal(self.synchronizationSemaphore);
    return YES;
}

// MARK: - Private

- (NSError *)repositoryError {
    return [NSError errorWithDomain:UVNullDataErrorDomain code:10000 userInfo:nil];
}

@end
