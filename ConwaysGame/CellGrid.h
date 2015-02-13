//
//  CellGrid.h
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Cell.h"

@interface CellGrid : NSObject

@property (strong, nonatomic) NSMutableArray *cells;
@property (nonatomic) unsigned M; // number of rows
@property (nonatomic) unsigned N; // number of columns

-initWithRowNum:(unsigned) numOfRows
      ColumnNum:(unsigned) numOfColums;

-initByCopyingAnotherCellGrid:(CellGrid*) cellGrid;

-(Cell*) getTheCellAtRow:(int) i
                  Column:(int) j;

@end
