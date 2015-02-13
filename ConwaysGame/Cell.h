//
//  Cell.h
//  ConwaysGame
//
//  Created by tyler on 2/12/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject <NSCopying>

@property (nonatomic) BOOL alive;

-(id)copyWithZone:(NSZone *)zone;

@end
