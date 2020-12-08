//
//  UVLinksPresenter.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import "UVLinksPresenter.h"
#import "UVDataRecognizer.h"

@interface UVLinksPresenter ()

@property (nonatomic, retain) id<UVDataRecognizerType> recognizer;

@end

@implementation UVLinksPresenter

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
{
    self = [super init];
    if (self) {
        _recognizer = [recognizer retain];
    }
    return self;
}



- (id<UVDataRecognizerType>)recognizer {
    if(!_recognizer) {
        _recognizer = [UVDataRecognizer new];
    }
    return _recognizer;
}

@end
