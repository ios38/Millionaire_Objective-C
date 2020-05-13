//
//  ResultsCaretaker.m
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ResultsCaretaker.h"
#import "Game.h"
#import "GameSettings.h"

@implementation ResultsCaretaker

NSString *directory() {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/GameResults.txt"];
}

-(void) saveResults:(NSMutableArray *)gameResults {
    //NSLog(@"ResultsCaretaker: saveResults does not work now!");
    /*
    GameSettings *gameSettings = [[GameSettings alloc] init];
    gameSettings.gameResults = gameResults;
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameSettings requiringSecureCoding:NO error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    [data writeToFile: directory() atomically:YES];
    NSLog(@"gameResults saved!");
    */
}

-(void) loadResults {
    //NSLog(@"ResultsCaretaker: loadResults does not work now!");
    //GameSettings *gameSettings = [NSKeyedUnarchiver unarchiveObjectWithFile:directory()];
    //
    //if(![gameSettings isEqual:[NSNull null]]) {
    //    Game.shared.gameResults = gameSettings.gameResults;
    //    NSLog(@"gameResults loaded!");
    //}
    
}

@end
