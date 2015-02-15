//
//  ConwaysGame.m
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import "ConwaysGame.h"
#import "CellGrid.h"

@implementation ConwaysGame

- (instancetype) initWithBoundaryCondition:(BoundaryCondition) boundaryCondition
                                 NumOfRows:(unsigned) rows
                              NumOfColumns:(unsigned) cols
{
    self = [super init];
    if (self) {
        self.boundaryCondition = boundaryCondition;
        self.cellGrid = [[CellGrid alloc]initWithRowNum:rows
                                              ColumnNum:cols];
    }
    return self;
}

- (void) simulateOneTimeStep
{
    // allocate a new grid to store the next grid
    CellGrid *newCellGrid = [[CellGrid alloc]initByCopyingAnotherCellGrid:self.cellGrid];
    
    // Get number of rows and colums of current grid
    unsigned int M = self.cellGrid.M;
    unsigned int N = self.cellGrid.N;
    
    // for each cell in current grid
    for( int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            // calcuate its new state
            BOOL newState = [self calculateNewStateOfACellAtRow:i
                                                         Column:j];
            // store new state into the new grid
            [newCellGrid getTheCellAtRow:i
                                    Column:j].alive = newState;
        }
    }

    // replace old grid with new grid
    self.cellGrid = newCellGrid;
}

- (BOOL) calculateNewStateOfACellAtRow:(int) i
                                Column:(int) j
{
    BOOL newState = false;
    // collect information about 8 adjacent node
    int numOfAlivedAdjacentCells = 0;
    for (int l = i-1; l <= i+1; l++) {
        for (int k = j-1; k <= j+1; k++) {
            // skip the cell in the center
            if (l != i || k != j) {
              // warp using boundary condition
              int m = l;
              int n = k;
              [self warpBoundaryForRow:&m Column:&n using:self.boundaryCondition];
              if ([self.cellGrid getTheCellAtRow:m Column:n] != nil
                  &&[self.cellGrid getTheCellAtRow:m Column:n].alive)
                numOfAlivedAdjacentCells++;
            }
        }
    }
    
    // calculate new state based on Rule 1-4
    //R1
    if ([self.cellGrid getTheCellAtRow:i Column:j].alive
        && numOfAlivedAdjacentCells < 2 ) {
        newState = false;
    }
    // R2
    if ([self.cellGrid getTheCellAtRow:i Column:j].alive
        && (numOfAlivedAdjacentCells == 2
            || numOfAlivedAdjacentCells == 3)) {
        newState = true;
    }
    // R3
    if ([self.cellGrid getTheCellAtRow:i Column:j].alive
        && numOfAlivedAdjacentCells > 3) {
        newState = false;
    }
    // R4
    if (![self.cellGrid getTheCellAtRow:i Column:j].alive
        && numOfAlivedAdjacentCells == 3) {
        newState = true;
    }
    // return new state
    return newState;
}

- (void) warpBoundaryForRow:(unsigned*) i
                     Column:(unsigned*) j
                      using:(BoundaryCondition) condition
{
    // Get number of rows and colums of current grid
    unsigned int M = self.cellGrid.M;
    unsigned int N = self.cellGrid.N;
    
    if (condition == Toroidal) {
        if (*i == -1) // exceed top boundary
            *i = M-1;
        
        if (*i == M) // exceed bottom boundary
            *i = 0;
        
        if (*j == -1) // exceed left boundary
            *j = N-1;
        
        if (*j == N) // exceed right boundar
            *j = 0;
    }
    else if (condition == Finite) {
        // do nothing
    }
    else {
        // do nothing
    }
    
}



@end
