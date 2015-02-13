//
//  CellGrid.m
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import "CellGrid.h"

@implementation CellGrid

-(instancetype)initWithRowNum: (unsigned) numOfRows
                    ColumnNum: (unsigned) numOfColums
{
    self = [super init];
    if (self) {
        self.cells = [[NSMutableArray alloc]init];
        
        self.M = numOfRows;
        self.N = numOfColums;
        for (int i = 0; i < self.M; i++) {
            for (int j = 0; j < self.N; j++) {
                Cell *aCell = [[Cell alloc]init];
                aCell.alive = true;
                [self.cells addObject: aCell];
            }
        }

    }
    return self;
}

-(instancetype)initByCopyingAnotherCellGrid:(CellGrid*) cellGrid
{
    self = [super init];
    if (self) {
        self.cells = [[NSMutableArray alloc] initWithArray:cellGrid.cells copyItems:YES];
        self.M = cellGrid.M;
        self.N = cellGrid.N;
    }
    
    return self;
}

- (Cell*) getTheCellAtRow:(int)i
                   Column:(int)j
{
    // Since I use 1D array to represent 2D grid
    // in order to access the Cell at (i,j)
    // I have to first turn 2D (i,j) index into
    // the 1D index. which is: i*N+j
    
    // first we need to check if i, j are valide
    if (i >= self.M || j >= self.N)
        return nil;
    // if we pass the check then
    int index = i*self.N+j;
    return [self.cells objectAtIndex:index];
}


@end
