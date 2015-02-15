//
//  CellView.h
//  ConwaysGame
//
//  Created by tyler on 2/13/15.
//  Copyright (c) 2015 tyler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView

@property (nonatomic) BOOL activated;
@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;

@end
