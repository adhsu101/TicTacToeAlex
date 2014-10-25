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
@property (nonatomic) BOOL isPlayerO;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property CGPoint playerLabelOriginalCenter;
@property NSInteger timeTick;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property NSTimer *timer;

@end

@implementation RootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPlayerO = NO;
    self.playerLabel.text = @"X";
    self.playerLabelOriginalCenter = self.playerLabel.center;
    [self startRepeatingTimer];
    
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer*)gesture
{
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
        NSString *winner = [self whoWon:tappedLabel];
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
    
}

- (IBAction)panHandler:(UIPanGestureRecognizer *)gesture
{
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
            NSString *winner = [self whoWon:hoveredLabel];
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

-(UILabel *)findLabelUsingPoint: (CGPoint) point
{
    for (UILabel* label in self.labels)
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

- (NSString *)whoWon: (UILabel*) tappedLabel
{
    BOOL winnerExists = 0;
    NSString *winner = nil;
    switch (tappedLabel.tag)
    {
        case 1:
            if ([self didWinCol1] || [self didWinRow1] || [self didWinDiag1])
                winnerExists = 1;
            break;
        case 2:
            if ([self didWinRow1] || [self didWinCol2])
                winnerExists = 1;
            break;
        case 3:
            if ([self didWinCol3] || [self didWinRow1] || [self didWinDiag3])
            winnerExists = 1;

            break;
        case 4:
            if ([self didWinCol1] || [self didWinRow4])
                winnerExists = 1;
            break;
        case 5:
            if ([self didWinCol2] || [self didWinRow4] || [self didWinDiag1] || [self didWinDiag3])
                winnerExists = 1;
            break;
        case 6:
            if ([self didWinCol3] || [self didWinRow4])
                winnerExists = 1;
            break;
        case 7:
            if ([self didWinCol1] || [self didWinRow7] || [self didWinDiag3])
                winnerExists = 1;
           break;
        case 8:
            if ([self didWinCol2] || [self didWinRow7])
                winnerExists = 1;
            break;
        case 9:
            if ([self didWinCol3] || [self didWinRow7] || [self didWinDiag1])
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
    for (UILabel* label in self.labels)
    {
        label.text = @"";
        
    }
    [self startRepeatingTimer];
}

# pragma mark - Win conditions

-(BOOL)didWinCol1
{
    if ([self.label1.text isEqualToString:self.label4.text] && [self.label1.text isEqualToString:self.label7.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;
}

-(BOOL)didWinCol2
{
    if ([self.label2.text isEqualToString:self.label5.text] && [self.label2.text isEqualToString:self.label8.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinCol3
{
    if ([self.label3.text isEqualToString:self.label6.text] && [self.label3.text isEqualToString:self.label9.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinRow1
{
    if ([self.label1.text isEqualToString:self.label2.text] && [self.label1.text isEqualToString:self.label3.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinRow4
{
    if ([self.label4.text isEqualToString:self.label5.text] && [self.label4.text isEqualToString:self.label6.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinRow7
{
    if ([self.label7.text isEqualToString:self.label8.text] && [self.label7.text isEqualToString:self.label9.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinDiag1
{
    if ([self.label1.text isEqualToString:self.label5.text] && [self.label1.text isEqualToString:self.label9.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

-(BOOL)didWinDiag3
{
    if ([self.label3.text isEqualToString:self.label5.text] && [self.label3.text isEqualToString:self.label7.text])
    {
        NSLog(@"Winner!");
        return YES;
    }
    return NO;}

@end
