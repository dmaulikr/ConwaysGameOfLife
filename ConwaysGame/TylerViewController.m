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
@property (nonatomic,strong) UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UISwitch *StartStopSwitchOutlet;
@property (weak, nonatomic) IBOutlet UIStepper *RowStepperOutlet;
@property (weak, nonatomic) IBOutlet UIStepper *ColumnStepperOutlet;
@property (strong, nonatomic) NSArray *boundaryConditionList;
@property (weak, nonatomic) IBOutlet UIPickerView *BoundaryConditionPicker;

@property (nonatomic) unsigned numOfRows;
@property (nonatomic) unsigned numOfColumns;
@property (nonatomic) BoundaryCondition boundaryCondition;
@property (atomic) float timerInterval;

@property (nonatomic,strong) ConwaysGame *game;
@property (nonatomic,strong) NSTimer *gameTimer;



@end

@implementation TylerViewController

- (IBAction)RowsStepper:(UIStepper *)sender {
    self.StartStopSwitchOutlet.on = NO;
    [self stopGame];
    
    self.numOfRows = sender.value;
    
    [self reInitializeAGame];
    
}

- (IBAction)ColumnsStepper:(UIStepper *)sender {
    self.StartStopSwitchOutlet.on = NO;
    [self stopGame];
    
    self.numOfColumns = sender.value;
    
    [self reInitializeAGame];
}
- (IBAction)SpeedSlider:(UISlider *)sender {
    // max time interval is: 2*1+0.01 = 2.01s
    // min time interval is: 2*0+0.01 = 0.01s
    // default interval is 2*0.5+0.01 = 1.01s
    self.timerInterval = (1-sender.value)*2+0.01;
}
- (IBAction)StartStopSwitch:(UISwitch *)sender {
    if (sender.on) {
        [self startGame];
    }
    else {
        [self stopGame];
    }
}


- (IBAction)clear2DGrid:(UIButton *)sender {
    
    self.StartStopSwitchOutlet.on = NO;
    [self stopGame];
    
    // Make sure the number of cells in the model
    // is the same as the number of cells displayed in
    // current cellGridView
    if (self.game.cellGrid.cells.count == self.cellGridView.count) {
        for (int i = 0; i < self.numOfRows; i++) {
            for (int j = 0; j < self.numOfColumns; j++) {
                unsigned index = i*self.numOfColumns+j;
                ((Cell *)[self.game.cellGrid.cells objectAtIndex:index]).alive = NO;
            }
        }
    }
    
    [self updateCellGridView];
}


- (void) reInitializeAGame
{
    self.game = [[ConwaysGame alloc]initWithBoundaryCondition:self.boundaryCondition NumOfRows:self.numOfRows NumOfColumns:self.numOfColumns];
    [self removeCellGridView];
    [self addCellGridViewWithNumOfRows:self.numOfRows NumOfColumns:self.numOfColumns DuringAppLaunch:NO];
    [self updateGameCellGrid];
}

- (void) startGame
{
    [self updateGameCellGrid];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval
                                                      target:self
                                                    selector:@selector(simulateAGameStepAndUpdateCellView)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void) stopGame
{
    [self.gameTimer invalidate];
    [self enalbeGestureRecognizerOfCellGridView];
}

- (void) enalbeGestureRecognizerOfCellGridView
{
    // Make sure the number of cells in the model
    // is the same as the number of cells displayed in
    // current cellGridView
    if (self.game.cellGrid.cells.count == self.cellGridView.count) {
        for (int i = 0; i < self.numOfRows; i++) {
            for (int j = 0; j < self.numOfColumns; j++) {
                unsigned index = i*self.numOfColumns+j;
                ((CellView*)[self.cellGridView objectAtIndex:index]).tapGestureRecognizer.enabled = YES;
            }
        }
    }
    
}

- (void) disableGestureRecognizerOfCellGridView
{
    // Make sure the number of cells in the model
    // is the same as the number of cells displayed in
    // current cellGridView
    if (self.game.cellGrid.cells.count == self.cellGridView.count) {
        for (int i = 0; i < self.numOfRows; i++) {
            for (int j = 0; j < self.numOfColumns; j++) {
                unsigned index = i*self.numOfColumns+j;
                ((CellView*)[self.cellGridView objectAtIndex:index]).tapGestureRecognizer.enabled = NO;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self setup];

    //[self removeCellGridView];
    //[self addCellGridViewWithNumOfRows:1 NumOfColumns:1];
    
}

- (void)setup
{
    self.cellGridView = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithRed:47.0f/255.0f
                                                  green:60.0f/255.0f
                                                   blue:73.0f/255.0f
                                                  alpha:1.0f]];
    [self addQuestionLabel];
    
    self.numOfRows = 8;
    self.numOfColumns = 14;
    self.boundaryCondition = Finite;
    self.game = [[ConwaysGame alloc] initWithBoundaryCondition:Finite
                                                     NumOfRows:self.numOfRows
                                                  NumOfColumns:self.numOfColumns];
    
    [self addCellGridViewWithNumOfRows:self.numOfRows NumOfColumns:self.numOfColumns DuringAppLaunch:YES];
    //[self updateCellGridView];
    [self updateGameCellGrid];
    
    self.gameTimer = nil;
    self.timerInterval = 1.0f;
    
    self.RowStepperOutlet.value = self.numOfRows;
    self.ColumnStepperOutlet.value = self.numOfColumns;

    self.boundaryConditionList = @[@"Finite",@"Toroidal"];
    self.BoundaryConditionPicker.dataSource = self;
    self.BoundaryConditionPicker.delegate = self;
    
}

- (void) simulateAGameStepAndUpdateCellView
{
    [self.game simulateOneTimeStep];
    [self updateCellGridView];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval
                                                      target:self
                                                    selector:@selector(simulateAGameStepAndUpdateCellView)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void) addCellGridViewWithNumOfRows: (unsigned)rows
                         NumOfColumns: (unsigned)columns
                      DuringAppLaunch:  (BOOL) duringAppLaunch
{
    CGFloat cellGridViewWidth;
    CGFloat cellGridViewHeight;
    if (duringAppLaunch) {
        cellGridViewWidth = self.view.bounds.size.height * 5.0f/6.0f;
        cellGridViewHeight = self.view.bounds.size.width * 9.0f/14.0f;
    }
    else {
        cellGridViewWidth = self.view.bounds.size.width * 5.0f/6.0f;
        cellGridViewHeight = self.view.bounds.size.height * 9.0f/14.0f;
    }
    
    CGFloat cellViewWidthEstimatedFromCellGridViewWidth = cellGridViewWidth/(1.25f*columns);
    CGFloat cellViewWidthEstimatedFromCellGridViewHeight = cellGridViewHeight/(1.25f*rows);
    
    CGFloat cellViewWidth = MIN(cellViewWidthEstimatedFromCellGridViewWidth, cellViewWidthEstimatedFromCellGridViewHeight);
    CGFloat gapWidth = 0.125f*cellViewWidth;

    CGFloat C = cellViewWidth;
    CGFloat g = gapWidth;
    CGFloat cellViewCenterX = 1.25f*columns*C*0.5f;
    CGFloat cellViewCenterY = 1.25f*rows*C*0.5f;
    
    CGFloat deltaX;
    CGFloat deltaY;
    if (duringAppLaunch) {
        deltaX = self.view.bounds.size.height/2.0f - cellViewCenterX;
        deltaY = 0.8f*(self.view.bounds.size.width/2.0f) - cellViewCenterY;
    }
    else {
        deltaX = self.view.bounds.size.width/2.0f - cellViewCenterX;
        deltaY = 0.8f*(self.view.bounds.size.height/2.0f) - cellViewCenterY;
    }
    
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

- (void) updateCellGridView
{
    // Make sure the number of cells in the model
    // is the same as the number of cells displayed in
    // current cellGridView
    if (self.game.cellGrid.cells.count == self.cellGridView.count) {
        for (int i = 0; i < self.numOfRows; i++) {
            for (int j = 0; j < self.numOfColumns; j++) {
                unsigned index = i*self.numOfColumns+j;
                ((CellView*)[self.cellGridView objectAtIndex:index]).activated
                  = ((Cell *)[self.game.cellGrid.cells objectAtIndex:index]).alive;
            }
        }
    }
}

- (void) updateGameCellGrid
{
    // Make sure the number of cells in the model
    // is the same as the number of cells displayed in
    // current cellGridView
    if (self.game.cellGrid.cells.count == self.cellGridView.count) {
        for (int i = 0; i < self.numOfRows; i++) {
            for (int j = 0; j < self.numOfColumns; j++) {
                unsigned index = i*self.numOfColumns+j;
                ((Cell *)[self.game.cellGrid.cells objectAtIndex:index]).alive =
                ((CellView*)[self.cellGridView objectAtIndex:index]).activated;
            }
        }
    }
}

- (void) removeCellGridView
{
    for (CellView *cellView in self.cellGridView) {
        [cellView removeFromSuperview];
    }
    [self.view setNeedsDisplay];
    [self.cellGridView removeAllObjects];
}

- (void) addQuestionLabel
{
    
    CGRect questionLabelRectangle = CGRectMake(141.0f, 580.0f, 822.0f, 77.0f);
    self.questionLabel = [[UILabel alloc]initWithFrame:questionLabelRectangle];
    self.questionLabel.font = [UIFont systemFontOfSize:34];
    self.questionLabel.text = @"Welcome to Conway's Game of Life!";
    self.questionLabel.textColor = [UIColor colorWithRed: 200.0f/255.0f
                                                   green: 155.0f/255.0f
                                                    blue: 155.0f/255.0f
                                                   alpha: 1.0f];
    [self.view addSubview:self.questionLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.boundaryConditionList.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.boundaryConditionList[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.boundaryConditionList[row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.StartStopSwitchOutlet.on = NO;
    [self stopGame];
    
    if ([self.boundaryConditionList[row] isEqualToString: @"Finite"])
    {
        self.boundaryCondition = Finite;
    }
    else if ([self.boundaryConditionList[row] isEqualToString: @"Toroidal"])
    {
        self.boundaryCondition = Toroidal;
    }
    
    [self reInitializeAGame];
}


@end
