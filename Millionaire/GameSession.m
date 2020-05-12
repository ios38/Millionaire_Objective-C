//
//  GameSession.m
//  Millionaire
//
//  Created by Maksim Romanov on 09.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "GameSession.h"
#import "Game.h"

@implementation GameSession

- (instancetype) init {
    self = [super init];
    if (self) {
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

- (void) didEndGameWithResult: (NSUInteger) result {
    NSLog(@"GameSession: didEndGameWithResult: %lu",(unsigned long)result);
    [Game.shared endGameWithResult:result];
}

@end
