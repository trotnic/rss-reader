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

@interface AppCoordinator () <UINavigationControllerDelegate>

@property (nonatomic, strong) id<PresentationFactoryType> factory;
@property (nonatomic, strong) id<UVNetworkType> network;
@property (nonatomic, strong) id<UVSourceManagerType> source;
@property (nonatomic, strong) id<UVDataRecognizerType> recognizer;

@property (nonatomic, strong) UVNavigationController *controller;

@property (nonatomic, strong) UVCoordinatorState *currentState;
@property (nonatomic, strong) UVCoordinatorTransition *lastTransition;

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

- (void)setRootNavigationController:(UVNavigationController *)controller {
    self.controller = controller;
    self.controller.delegate = self;
    
    __block typeof(self)weakSelf = self;
    
    self.controller.popCallback = ^{
        weakSelf.currentState = weakSelf.lastTransition.initial;
        if (weakSelf.currentState.enterCallback) weakSelf.currentState.enterCallback();
    };
}

- (void)showScreen:(Transactions)screen {
    
    for (UVCoordinatorTransition *obj in self.transitions) {
        if (obj.identifier == screen) {
            self.currentState = obj.terminal;
            self.currentState.enterCallback();
            return;
        }
    };
}

// MARK: - Private

- (void)setState:(UVCoordinatorState *)state {
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

    UVCoordinatorState *sourcesState = [[UVCoordinatorState alloc] initWithIdentifier:ScreenStateSources];
    sourcesState.enterCallback = ^{
        UIViewController *controller = [weakSelf controllerOf:PresentationBlockSources];
        [weakSelf.controller pushViewController:controller animated:YES];
    };

    UVCoordinatorState *searchState = [[UVCoordinatorState alloc] initWithIdentifier:ScreenStateSearch];
    searchState.enterCallback = ^{
        UIViewController *controller = [weakSelf controllerOf:PresentationBlockSearch];
        [weakSelf.controller pushViewController:controller animated:YES];
    };
    
    self.states = [NSSet setWithArray:@[feedState, sourcesState, searchState]];
    
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

// MARK: - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController.viewControllers containsObject:viewController]) {
        
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
