//
//  ViewController.m
//  TicTacToe2
//
//  Created by Vala Kohnechi on 10/23/14.
//  Copyright (c) 2014 Vala Kohnechi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPlayerO = NO;
    self.playerLabel.text = @"X";
    
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer*)tapLabel
{
    CGPoint point = [tapLabel locationInView:self.view];
    UILabel *tappedLabel = [self findLabelUsingPoint:point];
    
    if ([tappedLabel.text isEqualToString:@""])
    {
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
            if ([self.playerLabel.text isEqualToString:@"O"])
            {
                self.playerLabel.text = @"X";
            }
            else
            {
                self.playerLabel.text = @"O";
            }
        }
        else
        {
            // call method to alert with winner
            [self winnerAlert];            
        }
        
    }
    
// set winner here
    
}

# pragma mark - Helper

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

- (void)winnerAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Player %@", self.playerLabel.text]  message:@"We have a winner!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];

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
