//
//  MainMenuController.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "MainMenuController.h"
#import "Game.h"


@interface MainMenuController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *resultsButton;

- (IBAction)testButton:(id)sender;

@end

@implementation MainMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.startButton addTarget:self action:@selector(startGameSession) forControlEvents:UIControlEventTouchUpInside];
    [self.resultsButton addTarget:self action:@selector(showResults) forControlEvents:UIControlEventTouchUpInside];
    [self.difficultySegmentedControl setSelectedSegmentIndex:1];
}

- (Difficulty) selectedDifficulty {
    switch (self.difficultySegmentedControl.selectedSegmentIndex) {
        case 0:
            return easy;
            break;
        case 1:
            return medium;
            break;
        case 2:
            return hard;
            break;
        case 3:
            return insane;
            break;
        default:
            return medium;
            break;
    }
}

- (IBAction)testButton:(id)sender {

}

- (void) startGameSession {
    Game.shared.gameSession = [[GameSession alloc] init];
    Game.shared.gameSession.difficulty = [self selectedDifficulty];
    [Game.shared.gameSession startGame:self];
}

- (void) showResults {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *resultsController = [storyboard instantiateViewControllerWithIdentifier:@"resultsController"];
    resultsController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:resultsController animated:NO completion:nil];
    
}

@end
