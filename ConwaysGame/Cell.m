//
//  Cell.m
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id)copyWithZone:(NSZone *)zone {
    Cell *newCell = [[Cell alloc]init];
    newCell.alive = self.alive;
    return newCell;
}

@end
