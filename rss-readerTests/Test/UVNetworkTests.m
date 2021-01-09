//
//  UVNetworkTests.m
//  rss-readerTests
//
//  Created by Uladzislau Volchyk on 9.01.21.
//

#import <XCTest/XCTest.h>
#import "UVNetwork.h"

@interface UVNetworkTests : XCTestCase

@property (nonatomic, retain) UVNetwork *sut;

@end

@implementation UVNetworkTests

- (void)setUp {
    _sut = [UVNetwork new];
}

- (void)tearDown {
    [_sut release];
}

- (void)testValidateEmptyAddressErrorOccures {
    NSString *address = @"";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}

- (void)testValidateNilAddressErrorOccures {
    NSString *address = nil;
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}

- (void)testValidateAddressWithHTTPS {
    NSString *address = @"https://tut.by";
    NSString *expected = @"https://tut.by";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNotNil(obtained);
    XCTAssertNil(error);
    XCTAssertEqualObjects(expected, obtained.absoluteString);
}

- (void)testValidateAddressWithHTTP {
    NSString *address = @"http://tut.by";
    NSString *expected = @"http://tut.by";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNotNil(obtained);
    XCTAssertNil(error);
    XCTAssertEqualObjects(expected, obtained.absoluteString);
}

- (void)testValidateAddressWithNoScheme {
    NSString *address = @"tut.by";
    NSString *expected = @"https://tut.by";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNotNil(obtained);
    XCTAssertNil(error);
    XCTAssertEqualObjects(expected, obtained.absoluteString);
}

- (void)testValidateAddressWithSchemeOnly {
    NSString *address = @"https://";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}

- (void)testValidateAddressWithWrongSchemeOnly {
    NSString *address = @"hts://";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}

- (void)testValidateAddressWithSchemeArbitraryHost {
    NSString *address = @"https://l &@*)_+_)D";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}


- (void)testValidateAddressWithArbitraryString {
    NSString *address = @"not url &@*)_+_)DS\"some string";
    NSError *error = nil;
    NSURL *obtained = [self.sut validateAddress:address error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertNil(obtained);
}

- (void)testValidateURLWithNoScheme {
    NSURL *url = [NSURL URLWithString:@"tut.by"];
    NSURL *expected = [NSURL URLWithString:@"https://tut.by"];
    NSError *error = nil;
    NSURL *obtained = [self.sut validateURL:url error:&error];
    
    XCTAssertNotNil(obtained);
    XCTAssertNil(error);
    XCTAssertEqualObjects(expected, obtained);
}

- (void)testValidateURLWithHTTPScheme {
    NSURL *url = [NSURL URLWithString:@"http://tut.by"];
    NSURL *expected = [NSURL URLWithString:@"http://tut.by"];
    NSError *error = nil;
    NSURL *obtained = [self.sut validateURL:url error:&error];
    
    XCTAssertNotNil(obtained);
    XCTAssertNil(error);
    XCTAssertEqualObjects(expected, obtained);
}

- (void)testValidateNilURLErrorOccures {
    NSURL *url = nil;
    NSError *error = nil;
    NSURL *obtained = [self.sut validateURL:url error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}

- (void)testValidateEmptyURLErrorOccures {
    NSURL *url = [NSURL URLWithString:@""];
    NSError *error = nil;
    NSURL *obtained = [self.sut validateURL:url error:&error];
    
    XCTAssertNil(obtained);
    XCTAssertNotNil(error);
}

@end
