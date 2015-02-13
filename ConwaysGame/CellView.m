//
//  CellView.m
//  ConwaysGame
//
//  Created by tyler on 2/13/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) setActivated:(BOOL)activated
{
    _activated = activated;
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [self setup];
}

- (void) setup
{
    self.activated = YES;
}

- (UIColor *) getActivatedColor
{
    return [UIColor colorWithRed: 148.0f/255.0f
                           green: 95.0f/255.0f
                            blue: 95.0f/255.0f
                           alpha: 1.0f];
}

- (UIColor *) getDeactivatedColor
{
    return [UIColor colorWithRed: 69.0f/255.0f
                           green: 61.0f/255.0f
                            blue: 61.0f/255.0f
                           alpha: 1.0f];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.activated) {
        [[self getActivatedColor] setFill];
        UIRectFill(self.bounds);
    }
    else {
        [[self getDeactivatedColor] setFill];
        UIRectFill(self.bounds);
    }
}


@end
