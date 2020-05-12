//
//  MainMenuController.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "MainMenuController.h"
#import "Game.h"

typedef enum {
    easy,medium,hard,insane
} Difficulty;

@interface MainMenuController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentedControl;
//@property (assign,nonatomic) Difficulty selectedDifficulty;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *resultsButton;

- (IBAction)testButton:(id)sender;

@end

@implementation MainMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.startButton addTarget:self action:@selector(startGameSession) forControlEvents:UIControlEventTouchUpInside];
    [self.resultsButton addTarget:self action:@selector(showResults) forControlEvents:UIControlEventTouchUpInside];
}
/*
- (Difficulty) selectedDifficulty {
    switch (self.difficultySegmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"Easy difficulty selected");
            return easy;
            break;
        case 1:
            NSLog(@"Medium difficulty selected");
            return medium;
            break;
        case 2:
            NSLog(@"Hard difficulty selected");
            return hard;
            break;
        case 3:
            NSLog(@"Insane difficulty selected");
            return insane;
            break;
        default:
            return medium;
            break;
    }
}*/

- (IBAction)testButton:(id)sender {
    NSLog(@"Selected difficulty: %ld", (long)self.difficultySegmentedControl.selectedSegmentIndex);
}

- (void) startGameSession {
    Game.shared.gameSession = [[GameSession alloc] init];
    [Game.shared.gameSession startGame:self];
}

- (void) showResults {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *resultsController = [storyboard instantiateViewControllerWithIdentifier:@"resultsController"];
    resultsController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:resultsController animated:NO completion:nil];
    
}

@end
