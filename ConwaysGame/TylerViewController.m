//
//  TylerViewController.m
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import "TylerViewController.h"

@interface TylerViewController ()

@end

@implementation TylerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ConwaysGame* game = [[ConwaysGame alloc] initWithBoundaryCondition:Finite
                                                             NumOfRows:3
                                                          NumOfColumns:3];
    [game simulateOneTimeStep];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
