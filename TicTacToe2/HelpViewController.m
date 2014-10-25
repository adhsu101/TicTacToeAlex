//
//  HelpViewController.m
//  TicTacToe2
//
//  Created by Vala Kohnechi on 10/25/14.
//  Copyright (c) 2014 Vala Kohnechi. All rights reserved.
//

#import "HelpViewController.h"
#import "RootViewController.h"

@interface HelpViewController ()
<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *helpWebView;

@end

@implementation HelpViewController

-(void) loadURL :(NSString *)theURL
{
    NSURL *url = [NSURL URLWithString:theURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.helpWebView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadURL:@"http://en.wikipedia.org/wiki/Tic-tac-toe"];
    
}

@end
