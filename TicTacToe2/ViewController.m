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
    self.playerLabel.text = @"Turn: Player X";
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer*)tapLabel
{
    CGPoint point = [tapLabel locationInView:self.view];
    UILabel *tappedLabel = [self findLabelUsingPoint:point];
    if (tappedLabel != nil)
    {
        if (self.isPlayerO){
            tappedLabel.text = @"O";
            self.playerLabel.text = @"Turn: Player X";
        }
        else
        {
            tappedLabel.text = @"X";
            self.playerLabel.text = @"Turn: Player O";
        }
    self.isPlayerO = !self.isPlayerO;
    }
}


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


@end
