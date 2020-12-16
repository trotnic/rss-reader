//
//  UVLinksPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVLinksPresenterType.h"
#import "UVDataRecognizerType.h"
#import "UVSourceManagerType.h"
#import "ErrorPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVLinksPresenter : ErrorPresenter <UVLinksPresenterType>

@property (nonatomic, retain, readonly) id<UVDataRecognizerType> recognizer;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer sourceManager:(id<UVSourceManagerType>)sourceManager;

@end

NS_ASSUME_NONNULL_END
