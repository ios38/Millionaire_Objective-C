//
//  ResultsCaretaker.m
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ResultsCaretaker.h"
#import "Game.h"
#import "GameResult.h"
#import "GameSettings.h"

@implementation ResultsCaretaker

NSString *filePath() {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/GameResults"];
    //NSLog(@"%@",filePath);
    return filePath;
}

-(void) saveResults:(NSMutableArray *)gameResults {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    if (gameResults != nil) {
        [dataDict setObject:gameResults forKey:@"gameResults"];
    }
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataDict requiringSecureCoding:NO error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    [data writeToFile: filePath() atomically:YES];
    NSLog(@"gameResults saved!");
}

-(NSMutableArray *) loadResults {
    NSMutableArray *gameResults = [NSMutableArray array];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath()];
    
    //NSDictionary *dataDict = NSKeyedUnarchiver unarchivedObjectOfClass:<#(nonnull Class)#> fromData:data error:&error;
    NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    if (error) {
        NSLog(@"%@",error);
    }

    if ([dataDict objectForKey:@"gameResults"] != nil) {
        NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[dataDict objectForKey:@"gameResults"]];
        if ([results.lastObject isKindOfClass:[GameResult class]]) {
            NSLog(@"I'm GameResult");
        } else {
            NSLog(@"I'm not GameResult!");
        }
        gameResults = results;
    }
    return gameResults;
}

@end
