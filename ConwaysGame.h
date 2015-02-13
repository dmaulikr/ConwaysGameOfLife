//
//  ConwaysGame.h
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Cell.h"
#import "CellGrid.h"

typedef
enum BoundaryCondition {Toroidal = 0, Finite = 1}
BoundaryCondition;

@interface ConwaysGame : NSObject

@property (strong, nonatomic) CellGrid *cellGrid;
@property (nonatomic) BoundaryCondition boundaryCondition;

- (instancetype) initWithBoundaryCondition:(BoundaryCondition)boundaryCondition
                                 NumOfRows:(unsigned) rows
                              NumOfColumns:(unsigned) cols;

- (void) simulateOneTimeStep;

- (BOOL) calculateNewStateOfACellAtRow:(int) i
                                Column:(int) j;

- (void) warpBoundaryForRow:(int*) i
                     Column:(int*) j
                      using:(BoundaryCondition) condition;


@end
