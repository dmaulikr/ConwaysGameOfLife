//
//  TylerViewController.m
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import "TylerViewController.h"

#import "CellView.h"

@interface TylerViewController ()

@property (nonatomic,strong) NSMutableArray *cellGridView;

@end

@implementation TylerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:47.0f/255.0f
                                                  green:60.0f/255.0f
                                                   blue:73.0f/255.0f
                                                  alpha:1.0f]];
    
    [self addCellGridViewWithNumOfRows:8 NumOfColumns:12];
    
    
    ConwaysGame* game = [[ConwaysGame alloc] initWithBoundaryCondition:Finite
                                                             NumOfRows:3
                                                          NumOfColumns:3];
    [game simulateOneTimeStep];
    


}

- (void) addCellGridViewWithNumOfRows: (unsigned)rows
                         NumOfColumns: (unsigned)columns
{
    CGFloat cellGridViewWidth = self.view.bounds.size.height * 5.0f/6.0f;
    CGFloat cellGridViewHeight = self.view.bounds.size.width * 9.0f/14.0f;
    
    CGFloat cellViewWidthEstimatedFromCellGridViewWidth = cellGridViewWidth/(1.25f*columns);
    CGFloat cellViewWidthEstimatedFromCellGridViewHeight = cellGridViewHeight/(1.25f*rows);
    
    CGFloat cellViewWidth = MIN(cellViewWidthEstimatedFromCellGridViewWidth, cellViewWidthEstimatedFromCellGridViewHeight);
    CGFloat gapWidth = 0.125f*cellViewWidth;

    CGFloat C = cellViewWidth;
    CGFloat g = gapWidth;
    CGFloat cellViewCenterX = 1.25f*columns*C*0.5f;
    CGFloat cellViewCenterY = 1.25f*rows*C*0.5f;
    CGFloat deltaX = self.view.bounds.size.height/2.0f - cellViewCenterX;
    CGFloat deltaY = 0.8f*(self.view.bounds.size.width/2.0f) - cellViewCenterY;
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < columns; j++) {
            CGRect cellRectangle = CGRectMake(j*(C+2*g)+g+deltaX, i*(C+2*g)+g+deltaY, C, C);
            CellView* aCellView = [[CellView alloc]initWithFrame:cellRectangle];
            aCellView.activated = arc4random()%16 > 8? YES : NO;
            [self.view addSubview:aCellView]; // add to the view
            [self.cellGridView addObject:aCellView];// sort of outlet
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
