//
//  GameSession.m
//  Millionaire
//
//  Created by Maksim Romanov on 09.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "GameSession.h"
#import "Game.h"


@interface GameSession ()

//@property (assign,nonatomic) NSUInteger trueAnswersCount;

@end

@implementation GameSession

- (instancetype) init {
    self = [super init];
    if (self) {
        self.trueAnswersCount = 0;
        NSLog(@"GameSession created");
    }
    return self;
}

- (void) dealloc {
    NSLog(@"GameSession deallocated");
}

-(void)startGame:(UIViewController *)mainMenuController {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *gameController = [storyboard instantiateViewControllerWithIdentifier:@"GameController"];
    gameController.modalPresentationStyle = UIModalPresentationFullScreen;
    [mainMenuController presentViewController:gameController animated:NO completion:nil];
}

- (void) trueAnswer {
    self.trueAnswersCount += 1;
}

- (void) didEndGame {
    NSLog(@"GameSession: didEndGame with result: %lu",(unsigned long)self.trueAnswersCount);
    [Game.shared endGameWithResult:self.trueAnswersCount];
}

@end
