//
//  AppCoordinator.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 10.02.21.
//

#import "AppCoordinator.h"

#import "UVCoordinatorState.h"
#import "UVCoordinatorTransition.h"

#import "NSArray+Util.h"

@interface AppCoordinator ()

@property (nonatomic, strong) id<PresentationFactoryType> factory;
@property (nonatomic, strong) id<UVNetworkType> network;
@property (nonatomic, strong) id<UVSourceManagerType> source;
@property (nonatomic, strong) id<UVDataRecognizerType> recognizer;

@property (nonatomic, strong) UINavigationController *controller;

@property (nonatomic, strong) UVCoordinatorState *currentState;

@property (nonatomic, strong) NSSet<UVCoordinatorState *> *states;
@property (nonatomic, strong) NSSet<UVCoordinatorTransition *> *transitions;

@end

@implementation AppCoordinator

- (instancetype)initWithPresentationFactory:(id<PresentationFactoryType>)factory
                                    network:(id<UVNetworkType>)network
                                     source:(id<UVSourceManagerType>)source
                                 recognizer:(id<UVDataRecognizerType>)recognizer{
    self = [super init];
    if (self) {
        _factory = factory;
        _network = network;
        _source = source;
        _recognizer = recognizer;
        [self setupStates];
    }
    return self;
}

- (void)setRootNavigationController:(UINavigationController *)controller {
    self.controller = controller;
}

- (void)showScreen:(Transactions)screen {
    
    for (UVCoordinatorTransition *obj in self.transitions) {
        if (obj.identifier == screen /* && obj.initial.identifier == self.currentState.identifier */) {
            if (self.currentState) {
                self.currentState.exitCallback();
            }
            
            self.currentState = obj.terminal;
            self.currentState.enterCallback();
            return;
        }
    };
//    for (UVCoordinatorState *obj in self.states) {
//        if (obj.identifier == state) {
//            [self setState:obj];
//            return;
//        }
//    }
    //    PresentationBlockType type = [self fromScreen:state];
    //    UIViewController *vc = [self.factory presentationBlockOfType:type network:self.network
    //                                                          source:self.source parser:self.recognizer
    //                                                     coordinator:self];
    //    [self.controller pushViewController:vc animated:YES];
}

// MARK: - Private

- (void)setState:(UVCoordinatorState *)state {
    if (self.currentState) {
        self.currentState.exitCallback();
    }
    self.currentState = state;
    self.currentState.enterCallback();
}

- (PresentationBlockType)fromScreen:(ScreenState)state {
    switch (state) {
        case ScreenStateSources:
            return PresentationBlockSources;
        case ScreenStateFeed:
            return PresentationBlockFeed;
        case ScreenStateSearch:
            return PresentationBlockSearch;
    }
}

- (void)setupStates {
    __block typeof(self)weakSelf = self;
    
    UVCoordinatorState *feedState = [[UVCoordinatorState alloc] initWithIdentifier:ScreenStateFeed];
    feedState.enterCallback = ^{
        UIViewController *controller = [weakSelf controllerOf:PresentationBlockFeed];
        [weakSelf.controller pushViewController:controller animated:NO];
    };
    feedState.exitCallback = ^{
//        [weakSelf.controller popViewControllerAnimated:YES];
    };

    UVCoordinatorState *sourcesState = [[UVCoordinatorState alloc] initWithIdentifier:ScreenStateSources];
    sourcesState.enterCallback = ^{
        UIViewController *controller = [weakSelf controllerOf:PresentationBlockSources];
        [weakSelf.controller pushViewController:controller animated:YES];
    };
    sourcesState.exitCallback = ^{
        [weakSelf.controller popViewControllerAnimated:YES];
    };

    UVCoordinatorState *searchState = [[UVCoordinatorState alloc] initWithIdentifier:ScreenStateSearch];
    searchState.enterCallback = ^{
        UIViewController *controller = [weakSelf controllerOf:PresentationBlockSearch];
        [weakSelf.controller pushViewController:controller animated:YES];
    };
    searchState.exitCallback = ^{
        [weakSelf.controller popViewControllerAnimated:YES];
    };
    
    self.states = [NSSet setWithArray:@[feedState, sourcesState, searchState]];
//    self.currentState = feedState;
//    self.currentState.enterCallback();
    
    UVCoordinatorTransition *t1 = [[UVCoordinatorTransition alloc] initWithInitial:feedState terminal:sourcesState identifier:TRSource];
    UVCoordinatorTransition *t2 = [[UVCoordinatorTransition alloc] initWithInitial:sourcesState terminal:searchState identifier:TRSearch];
    UVCoordinatorTransition *t3 = [[UVCoordinatorTransition alloc] initWithInitial:searchState terminal:sourcesState identifier:TRSource];
    UVCoordinatorTransition *t4 = [[UVCoordinatorTransition alloc] initWithInitial:sourcesState terminal:feedState identifier:TRFeed];
    
    self.transitions = [NSSet setWithArray:@[t1, t2, t3, t4]];
}

- (UIViewController *)controllerOf:(PresentationBlockType)type {
    return [self.factory presentationBlockOfType:type
                                         network:self.network
                                          source:self.source
                                          parser:self.recognizer
                                     coordinator:self];
}

@end
