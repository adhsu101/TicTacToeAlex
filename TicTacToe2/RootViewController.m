//
//  ViewController.m
//  TicTacToe2
//
//  Created by Vala Kohnechi on 10/23/14.
//  Copyright (c) 2014 Vala Kohnechi. All rights reserved.
//

#import "RootViewController.h"
#define kTimerStart 10

@interface RootViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;
@property (strong, nonatomic) IBOutlet UILabel *label7;
@property (strong, nonatomic) IBOutlet UILabel *label8;
@property (strong, nonatomic) IBOutlet UILabel *label9;
@property (nonatomic) BOOL playerIsX;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property CGPoint playerLabelOriginalCenter;
@property NSInteger timeTick;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property NSTimer *timer;
@property BOOL isComputersTurn;

@end

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerIsX = YES;
    self.playerLabel.text = @"X";
    self.playerLabelOriginalCenter = self.playerLabel.center;
    [self startRepeatingTimer];
    self.isComputersTurn = NO;
    
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer*)gesture
{
    if (self.isComputersTurn) return;
    
    CGPoint touchPoint = [gesture locationInView:self.view];
    UILabel *tappedLabel = [self findLabelUsingPoint:touchPoint];
    
    if ([tappedLabel.text isEqualToString:@""])
    {
        // restart timer
        [self startRepeatingTimer];
        
        // enter X or O into grid
        tappedLabel.text = self.playerLabel.text;
        
        // color X or O
        if ([self.playerLabel.text isEqualToString:@"O"])
        {
            tappedLabel.textColor = [UIColor redColor];
        }
        else
        {
            tappedLabel.textColor = [UIColor blueColor];
        }
        
        // check for win
        NSString *winner = [self whoWon:tappedLabel.tag:[self gameStateFromLabels:self.labels]];
        if (winner == nil)
        {
            [self checkForTie];
            [self changePlayers];
        }
        else
        {
            // call method to alert with winner
            [self winnerAlert];            
        }
        
    }
    
    NSArray *tempCheckForBestMoveAndScore = [[NSArray alloc]init];
    tempCheckForBestMoveAndScore = [self decideOnMove:[self gameStateFromLabels:self.labels] :self.playerIsX];

}

- (IBAction)panHandler:(UIPanGestureRecognizer *)gesture
{
    if (self.isComputersTurn) return;
    
    CGPoint touchPoint = [gesture locationInView:self.view];
    self.playerLabel.center = touchPoint;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {

        UILabel *hoveredLabel = [self findLabelUsingPoint:touchPoint];
        
        if ([hoveredLabel.text isEqualToString:@""])
        {
            [self startRepeatingTimer];

            // enter X or O into grid
            hoveredLabel.text = self.playerLabel.text;
            
            // color X or O
            if ([self.playerLabel.text isEqualToString:@"O"])
            {
                hoveredLabel.textColor = [UIColor redColor];
            }
            else
            {
                hoveredLabel.textColor = [UIColor blueColor];
            }

            
            // check for win
            NSString *winner = [self whoWon:hoveredLabel.tag:[self gameStateFromLabels:self.labels]];
            if (winner == nil)
            {
                [self checkForTie];
                [self changePlayers];
            }
            else
            {
                // call method to alert with winner
                [self winnerAlert];
            }
            
        }
        else
        {
        // animate to original position
            [UIView animateWithDuration:.5 animations:^{
                self.playerLabel.center = self.playerLabelOriginalCenter;
            }];
        }
        
    }
}


# pragma mark - Helper methods

- (NSArray *)gameStateFromLabels: (NSArray*) currentLabels
{
    NSMutableArray *gameState = [[NSMutableArray alloc] init];
    
    for (UILabel *label in currentLabels)
    {
        NSString *squareState = @"0";
        if ([label.text isEqualToString:@"X"])
        {
            squareState = @"1";
        }
        else if ([label.text isEqualToString:@"O"])
            {
                squareState = @"2";
            }
        [gameState addObject:squareState];
    }
    return gameState;
}


 


-(UILabel *)findLabelUsingPoint: (CGPoint) point
{
    for (UILabel *label in self.labels)
    {
        if (CGRectContainsPoint(label.frame, point))
        {
                return label;
        }

    }
    return nil;
}

- (void)changePlayers
{
    if ([self.playerLabel.text isEqualToString:@"O"])
    {
        self.playerLabel.text = @"X";
    }
    else
    {
        self.playerLabel.text = @"O";
    }
}

- (NSString *)whoWon: (NSInteger)moveIndex : (NSArray *)gameState
{
    BOOL winnerExists = 0;
    NSString *winner = nil;
    switch (moveIndex)
    {
        case 0:
            if ([self didWinCol1:gameState] || [self didWinRow1:gameState] || [self didWinDiag1:gameState])
                winnerExists = 1;
            break;
        case 1:
            if ([self didWinRow1:gameState] || [self didWinCol2:gameState])
                winnerExists = 1;
            break;
        case 2:
            if ([self didWinCol3:gameState] || [self didWinRow1:gameState] || [self didWinDiag3:gameState])
            winnerExists = 1;

            break;
        case 3:
            if ([self didWinCol1:gameState] || [self didWinRow4:gameState])
                winnerExists = 1;
            break;
        case 4:
            if ([self didWinCol2:gameState] || [self didWinRow4:gameState] || [self didWinDiag1:gameState] || [self didWinDiag3:gameState])
                winnerExists = 1;
            break;
        case 5:
            if ([self didWinCol3:gameState] || [self didWinRow4:gameState])
                winnerExists = 1;
            break;
        case 6:
            if ([self didWinCol1:gameState] || [self didWinRow7:gameState] || [self didWinDiag3:gameState])
                winnerExists = 1;
           break;
        case 7:
            if ([self didWinCol2:gameState] || [self didWinRow7:gameState])
                winnerExists = 1;
            break;
        case 8:
            if ([self didWinCol3:gameState] || [self didWinRow7:gameState] || [self didWinDiag1:gameState])
                winnerExists = 1;
            break;
        default:
            NSLog (@"Integer out of range");
            break;
    }
    if (winnerExists) {
        winner = self.playerLabel.text;
    }
    return winner;
}

- (void)checkForTie
{
    BOOL isTie = YES;
    for (UILabel *label in self.labels)
    {
        if ([label.text isEqualToString:@""])
            isTie = NO;
        
    }
    
    if (isTie)
    {
        [self.timer invalidate];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"It's a tie!"  message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *playAgainButton = [UIAlertAction actionWithTitle:@"Play again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self restartGame];
        }];
        [alert addAction:playAgainButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)winnerAlert
{
    [self.timer invalidate];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Player %@", self.playerLabel.text]  message:@"We have a winner!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *playAgainButton = [UIAlertAction actionWithTitle:@"Play again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self restartGame];
    }];
    [alert addAction:playAgainButton];
    [self presentViewController:alert animated:YES completion:nil];

}



- (void)startRepeatingTimer {

    [self.timer invalidate];
    self.timerLabel.text = [NSString stringWithFormat:@"%d", kTimerStart];
    self.timeTick = kTimerStart;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountdown) userInfo:nil repeats:YES];
    
    self.timer = timer;
    
}

-(void)timerCountdown{
    self.timeTick--;
    if (self.timeTick == 0)
    {
        [self changePlayers];
        self.timeTick = kTimerStart;
    }
    NSString *timeString =[[NSString alloc]initWithFormat:@"%ld",(long)(self.timeTick)];
    self.timerLabel.text = timeString;
}

- (void)restartGame
{
    self.playerLabel.text = @"X";
    for (UILabel *label in self.labels)
    {
        label.text = @"";
        
    }
    [self startRepeatingTimer];
}

# pragma mark - AI methods

- (NSArray *)decideOnMove: (NSArray *)passedGameState : (BOOL)playerIsX
{
    NSString *playerMove;
    if (playerIsX) playerMove = @"1";
    else playerMove = @"2";
    
    // get available moves
    NSArray *availableMoves = [self availableMovesInGameState: passedGameState];
    
    // create hypothetical game states based on available moves
    NSMutableArray *possibleGameStates = [[NSMutableArray alloc] init];
    for (NSString *availableMove in availableMoves)
    {
        NSMutableArray *newGameState = [[NSMutableArray alloc] initWithArray:passedGameState];
        [newGameState replaceObjectAtIndex:[availableMove intValue] withObject:playerMove];
        [possibleGameStates addObject:newGameState];
    }
    
    // check game states for win and score each game state
    NSString *winner = nil;
    NSMutableArray *scores = [[NSMutableArray alloc] init];
    NSUInteger index = 0;
    for (NSArray *possibleGameState in possibleGameStates)
    {
        NSString *indexString = [availableMoves objectAtIndex:index];
        winner = [self whoWon:[indexString intValue] :possibleGameState];
        if ([winner isEqualToString:@"X"])
        {
            [scores addObject:@"10"];
        }
        else if ([winner isEqualToString:@"O"])
        {
            [scores addObject:@"-10"];
        }
        else
        {
            if (availableMoves.count == 1)
            {
                [scores addObject:@"0"];
            }
            else
            {
                NSArray *recursiveBestMoveAndScore = [[NSArray alloc] init];
                recursiveBestMoveAndScore = [self decideOnMove:possibleGameState:!playerIsX];
                NSNumber *score = [recursiveBestMoveAndScore objectAtIndex:1];
                [scores addObject:[NSString stringWithFormat:@"%@", score]];
            }
        }
        index++;
    }
    
    // convert score array to NSNumbers
    NSNumber *scoreNum = 0;
    NSMutableArray *scoreNumArray = [[NSMutableArray alloc] init];
    for (NSString *score in scores) {
        NSInteger scoreInteger = [score integerValue];
        scoreNum = [NSNumber numberWithInteger:scoreInteger];
        [scoreNumArray addObject:scoreNum];
    }
    
    // determine best move and score
    NSNumber *bestScore = 0;
    NSInteger bestMoveIndex = 0;
    if (playerIsX)
    {
        if (scoreNumArray.count == 1)
        {
            bestScore = scoreNumArray[0];
        }
        for (NSInteger x = 1; x < scoreNumArray.count; x++)
        {
            if (scoreNumArray[x-1] > scoreNumArray[x])
            {
                bestScore = scoreNumArray[x-1];
                bestMoveIndex = x-1;
            }
            else
            {
                bestScore = scoreNumArray[x];
                bestMoveIndex = x;
            }
        }
    }
    else
    {
        if (scoreNumArray.count == 1) {
            bestScore = scoreNumArray[0];
        }
        for (NSInteger x = 1; x < scoreNumArray.count; x++)
        {
            if (scoreNumArray[x-1] < scoreNumArray[x])
            {
                bestScore = scoreNumArray[x-1];
                bestMoveIndex = x-1;
            }
            else
            {
                bestScore = scoreNumArray[x];
                bestMoveIndex = x;
            }
        }
        
    }
    
    // return best move and score
    NSString *bestMove = availableMoves[bestMoveIndex];
    NSArray *bestMoveAndScore = [NSArray arrayWithObjects: bestMove, bestScore, nil];
    return bestMoveAndScore;
}

- (NSArray *)availableMovesInGameState: (NSArray*) gameState
{
    NSMutableArray *availableMovesArray = [[NSMutableArray alloc] init];
    NSInteger squareIndex = 0;
    NSString *availableMove = nil;

    for (NSString *square in gameState)
    {
        if ([square isEqualToString:@"0"])
        {
            availableMove = [NSString stringWithFormat:@"%lu", squareIndex];
            [availableMovesArray addObject:availableMove];
        }
        squareIndex++;
    }
    return availableMovesArray;
}

# pragma mark - Win conditions

-(BOOL)didWinCol1: (NSArray*) gameState
{
    if ([gameState[0] isEqualToString:gameState[3]] && [gameState[0] isEqualToString:gameState[6]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;
}

-(BOOL)didWinCol2: (NSArray*) gameState
{
    if ([gameState[1] isEqualToString:gameState[4]] && [gameState[1] isEqualToString:gameState[7]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinCol3: (NSArray*) gameState
{
    if ([gameState[2] isEqualToString:gameState[5]] && [gameState[2] isEqualToString:gameState[8]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinRow1: (NSArray*) gameState
{
    if ([gameState[0] isEqualToString:gameState[1]] && [gameState[0] isEqualToString:gameState[2]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinRow4: (NSArray*) gameState
{
    if ([gameState[3] isEqualToString:gameState[4]] && [gameState[3] isEqualToString:gameState[5]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinRow7: (NSArray*) gameState
{
    if ([gameState[6] isEqualToString:gameState[7]] && [gameState[6] isEqualToString:gameState[8]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinDiag1: (NSArray*) gameState
{
    if ([gameState[0] isEqualToString:gameState[4]] && [gameState[0] isEqualToString:gameState[8]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinDiag3: (NSArray*) gameState
{
    if ([gameState[2] isEqualToString:gameState[4]] && [gameState[2] isEqualToString:gameState[6]])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

@end
