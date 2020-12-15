//
//  UVLinksPresenter.h
//  rss-reader
//
//  Created by Uladzislau Volchyk on 8.12.20.
//

#import <Foundation/Foundation.h>
#import "UVLinksPresenterType.h"
#import "UVDataRecognizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface UVLinksPresenter : NSObject <UVLinksPresenterType>

@property (nonatomic, retain, readonly) id<UVDataRecognizerType> recognizer;

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer;

@end

NS_ASSUME_NONNULL_END
