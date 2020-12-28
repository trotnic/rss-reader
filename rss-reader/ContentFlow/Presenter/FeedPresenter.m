//
//  FeedPresenter.m
//  rss-reader
//
//  Created by Uladzislau on 11/18/20.
//

#import <UIKit/UIKit.h>
#import "FeedPresenter.h"
#import "FeedChannel.h"
#import "FeedViewType.h"
#import "UVDataRecognizer.h"
#import "FeedXMLParser.h"
#import "UVNetwork.h"

@interface FeedPresenter ()

@property (nonatomic, retain) FeedChannel *channel;
@property (nonatomic, retain) id<UVDataRecognizerType> recognizer;
@property (nonatomic, retain) id<UVSourceManagerType> sourceManager;

@property (nonatomic, retain) id<UVNetworkManagerType> network;

@end

@implementation FeedPresenter

// MARK: -

- (instancetype)initWithRecognizer:(id<UVDataRecognizerType>)recognizer
                     sourceManager:(id<UVSourceManagerType>)sourceManager
{
    self = [super init];
    if (self) {
        _recognizer = [recognizer retain];
        _sourceManager = [sourceManager retain];
    }
    return self;
}

- (void)dealloc
{
    [_channel release];
    [_recognizer release];
    [_network release];
    [_sourceManager release];
    [super dealloc];
}

// MARK: - FeedPresenterType

- (void)updateFeed {
    [self.view toggleActivityIndicator:YES];
    
    __block typeof(self)weakSelf = self;
    
    
    NSURL *someURL = [NSURL URLWithString:self.sourceManager.selectedLink.link relativeToURL:self.sourceManager.selectedRSSSource.url];
    
    NSURL *url = [NSURL URLWithString:self.sourceManager.selectedLink.link];
    if (!url) {
        [self.view presentError:[self provideErrorOfType:RSSErrorTypeBadURL]];
        return;
    }
    [self.network fetchDataOnURL:someURL.absoluteURL
                      completion:^(NSData *data, NSError *error) {
        if(error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view toggleActivityIndicator:NO];
                [weakSelf.view presentError:[weakSelf provideErrorOfType:RSSErrorNoRSSLinks]];
            });
            return;
        }
        [weakSelf.recognizer processData:data parser:FeedXMLParser.parser completion:^(FeedChannel *channel, RSSError error) {
            switch (error) {
                case RSSErrorTypeNone: {
                    weakSelf.channel = channel;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view toggleActivityIndicator:NO];
                        [weakSelf.view updatePresentation];
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view toggleActivityIndicator:NO];
                        [weakSelf.view presentError:[weakSelf provideErrorOfType:error]];
                    });
                }
            }
        }];
    }];
}

- (void)selectRowAt:(NSInteger)row {
    [self.view presentWebPageOnLink:self.channel.items[row].link];
}

- (id<FeedChannelViewModel>)viewModel {
    return self.channel;
}

// MARK: - Lazy

- (id<UVNetworkManagerType>)network {
    if(!_network) {
        _network = [UVNetwork.shared retain];
    }
    return _network;
}

@end
