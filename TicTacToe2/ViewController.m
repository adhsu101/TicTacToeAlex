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
    
    // array of labels
    
    // set label tags
    int labelTag = 1;
    for (UILabel* label in self.labels)
    {
        NSLog(@"Label tag is %d", labelTag);
        label.tag = labelTag;
        labelTag ++;
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onLabelTapped:(UITapGestureRecognizer*)tapLabel
{
    CGPoint point = [tapLabel locationInView:self.view];
    UILabel *tappedLabel = [self findLabelUsingPoint:point];
    
    if ([tappedLabel.text isEqualToString:@""]) {
        
        if (tappedLabel != nil)
        {
            if (self.isPlayerO){
                tappedLabel.text = @"O";
                self.playerLabel.text = @"Turn: Player X";
                tappedLabel.textColor = [UIColor blueColor];
            }
            else
            {
                tappedLabel.text = @"X";
                self.playerLabel.text = @"Turn: Player O";
                tappedLabel.textColor = [UIColor redColor];
            }
        self.isPlayerO = !self.isPlayerO;
        }
    }
    
    switch (tappedLabel.tag)
    {
        case 1:
            NSLog (@"one");
            break;
        case 2:
            NSLog (@"two");
            break;
        case 3:
            NSLog (@"three");
            break;
        case 4:
            NSLog (@"four");
            break;
        case 5:
            NSLog (@"five");
            break;
        case 6:
            NSLog (@"six");
            break;
        case 7:
            NSLog (@"sev");
            break;
        case 8:
            NSLog (@"eight");
            break;
        case 9:
            NSLog (@"nine");
            break;
        default:
            NSLog (@"Integer out of range");
            break;
    }
    
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

-(BOOL)col1Win
{
    if ([self.label1.text isEqualToString:self.label2.text] && [self.label1.text isEqualToString:self.label3.text]) {
        return YES;
    }
    NSLog(@"Winner!");
    return NO;
}

-(BOOL)col2Win
{
    return YES;
}

-(BOOL)col3Win
{
    return YES;
}

-(BOOL)row1Win
{
    return YES;
}

-(BOOL)row2Win
{
    return YES;
}

-(BOOL)row3Win
{
    return YES;
}

-(BOOL)diag1To9Win
{
    return YES;
}

-(BOOL)diag3To7Win
{
    return YES;
}

@end
