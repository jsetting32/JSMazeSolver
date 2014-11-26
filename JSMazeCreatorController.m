//
//  JSMazeCreatorController.m
//  3D Maze Solver
//
//  Created by John Setting on 11/25/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSMazeCreatorController.h"

@interface JSMazeCreatorController ()
@property (nonatomic) NSMutableArray *maze;
@property (nonatomic) UITextField *xMaze;
@property (nonatomic) UITextField *yMaze;
@property (nonatomic) UITextField *zMaze;
@property (nonatomic) UITextField *xStart;
@property (nonatomic) UITextField *yStart;
@property (nonatomic) UITextField *zStart;
@property (nonatomic) UITextField *xEnd;
@property (nonatomic) UITextField *yEnd;
@property (nonatomic) UITextField *zEnd;
@end

@implementation JSMazeCreatorController
@synthesize xMaze;
@synthesize yMaze;
@synthesize zMaze;
@synthesize xStart;
@synthesize yStart;
@synthesize zStart;
@synthesize xEnd;
@synthesize yEnd;
@synthesize zEnd;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed:)];

    float frameWidthByThree = self.view.frame.size.width / 3.0f;
    float viewPastNavbar = 100;
    
    
    UILabel *xyzLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewPastNavbar - 20, self.view.frame.size.width, 20)];
    [xyzLabel setText:@"Maze Dimensions"];
    [xyzLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:xyzLabel];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolbar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)]]];

    xMaze = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 0.0f + 70,
                                                          viewPastNavbar,
                                                          50,
                                                          50)];
    [xMaze setBackgroundColor:[UIColor lightGrayColor]];
    [xMaze setPlaceholder:@"x"];
    [xMaze setTextAlignment:NSTextAlignmentCenter];
    [xMaze setKeyboardType:UIKeyboardTypeNumberPad];
    [xMaze setInputAccessoryView:toolbar];
    [self.view addSubview:xMaze];
    
    yMaze = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 1.0f + 25,
                                                          viewPastNavbar,
                                                          50,
                                                          50)];
    [yMaze setBackgroundColor:[UIColor lightGrayColor]];
    [yMaze setPlaceholder:@"y"];
    [yMaze setTextAlignment:NSTextAlignmentCenter];
    [yMaze setKeyboardType:UIKeyboardTypeNumberPad];
    [yMaze setInputAccessoryView:toolbar];
    [self.view addSubview:yMaze];

    zMaze = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 2.0f - 20,
                                                          viewPastNavbar,
                                                          50,
                                                          50)];
    [zMaze setBackgroundColor:[UIColor lightGrayColor]];
    [zMaze setPlaceholder:@"z"];
    [zMaze setTextAlignment:NSTextAlignmentCenter];
    [zMaze setKeyboardType:UIKeyboardTypeNumberPad];
    [zMaze setInputAccessoryView:toolbar];
    [self.view addSubview:zMaze];
    
    
    
    UILabel *beginningParensLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMaze.frame.origin.x - 20,
                                                                              viewPastNavbar,
                                                                              10,
                                                                              50)];
    [beginningParensLabel setText:@"("];
    [beginningParensLabel setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [beginningParensLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:beginningParensLabel];
    
    UILabel *firstCommaLabel = [[UILabel alloc] initWithFrame:CGRectMake(xMaze.frame.origin.x + xMaze.frame.size.width,
                                                                         viewPastNavbar,
                                                                         10,
                                                                         50)];
    [firstCommaLabel setText:@","];
    [firstCommaLabel setTextAlignment:NSTextAlignmentCenter];
    [firstCommaLabel setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [self.view addSubview:firstCommaLabel];
    
    UILabel *secondCommaLabel = [[UILabel alloc] initWithFrame:CGRectMake(yMaze.frame.origin.x + yMaze.frame.size.width,
                                                                          viewPastNavbar,
                                                                          10,
                                                                          50)];
    [secondCommaLabel setText:@","];
    [secondCommaLabel setTextAlignment:NSTextAlignmentCenter];
    [secondCommaLabel setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [self.view addSubview:secondCommaLabel];
    
    UILabel *endingParensLabel = [[UILabel alloc] initWithFrame:CGRectMake(zMaze.frame.origin.x + zMaze.frame.size.width + 10,
                                                                           viewPastNavbar,
                                                                           10,
                                                                           50)];
    [endingParensLabel setText:@")"];
    [endingParensLabel setTextAlignment:NSTextAlignmentCenter];
    [endingParensLabel setFont:[UIFont boldSystemFontOfSize:32.0f]];
    [self.view addSubview:endingParensLabel];
    
    
    UILabel *startPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, viewPastNavbar - 20 + 75, self.view.frame.size.width, 20)];
    [startPoint setText:@"Start Point"];
    [startPoint setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:startPoint];

    xStart = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 0.0f + 70,
                                                          viewPastNavbar + 75,
                                                          50,
                                                          50)];
    [xStart setBackgroundColor:[UIColor lightGrayColor]];
    [xStart setPlaceholder:@"x"];
    [xStart setTextAlignment:NSTextAlignmentCenter];
    [xStart setKeyboardType:UIKeyboardTypeNumberPad];
    [xStart setInputAccessoryView:toolbar];
    [self.view addSubview:xStart];
    
    yStart = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 1.0f + 25,
                                                          viewPastNavbar + 75,
                                                          50,
                                                          50)];
    [yStart setBackgroundColor:[UIColor lightGrayColor]];
    [yStart setPlaceholder:@"y"];
    [yStart setTextAlignment:NSTextAlignmentCenter];
    [yStart setKeyboardType:UIKeyboardTypeNumberPad];
    [yStart setInputAccessoryView:toolbar];
    [self.view addSubview:yStart];
    
    zStart = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 2.0f - 20,
                                                          viewPastNavbar + 75,
                                                          50,
                                                          50)];
    [zStart setBackgroundColor:[UIColor lightGrayColor]];
    [zStart setPlaceholder:@"z"];
    [zStart setTextAlignment:NSTextAlignmentCenter];
    [zStart setKeyboardType:UIKeyboardTypeNumberPad];
    [zStart setInputAccessoryView:toolbar];
    [self.view addSubview:zStart];
    
    
    UILabel *endPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, viewPastNavbar - 20 + 150, self.view.frame.size.width, 20)];
    [endPoint setText:@"End Point"];
    [endPoint setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:endPoint];

    xEnd = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 0.0f + 70,
                                                           viewPastNavbar + 150,
                                                           50,
                                                           50)];
    [xEnd setBackgroundColor:[UIColor lightGrayColor]];
    [xEnd setPlaceholder:@"x"];
    [xEnd setTextAlignment:NSTextAlignmentCenter];
    [xEnd setKeyboardType:UIKeyboardTypeNumberPad];
    [xEnd setInputAccessoryView:toolbar];
    [self.view addSubview:xEnd];
    
    yEnd = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 1.0f + 25,
                                                           viewPastNavbar + 150,
                                                           50,
                                                           50)];
    [yEnd setBackgroundColor:[UIColor lightGrayColor]];
    [yEnd setPlaceholder:@"y"];
    [yEnd setTextAlignment:NSTextAlignmentCenter];
    [yEnd setKeyboardType:UIKeyboardTypeNumberPad];
    [yEnd setInputAccessoryView:toolbar];
    [self.view addSubview:yEnd];
    
    zEnd = [[UITextField alloc] initWithFrame:CGRectMake(frameWidthByThree * 2.0f - 20,
                                                           viewPastNavbar + 150,
                                                           50,
                                                           50)];
    [zEnd setBackgroundColor:[UIColor lightGrayColor]];
    [zEnd setPlaceholder:@"z"];
    [zEnd setTextAlignment:NSTextAlignmentCenter];
    [zEnd setKeyboardType:UIKeyboardTypeNumberPad];
    [zEnd setInputAccessoryView:toolbar];
    [self.view addSubview:zEnd];
}

- (void)dismissKeyboard:(UIBarButtonItem *)button
{
    [self.view endEditing:YES];
}

- (void)doneButtonPressed:(UIBarButtonItem *)button
{
    if ([xStart.text integerValue] > [xMaze.text integerValue] ||
        [yStart.text integerValue] > [yMaze.text integerValue] ||
        [zStart.text integerValue] > [zMaze.text integerValue] ||
        
        [xEnd.text integerValue] > [xMaze.text integerValue] ||
        [yEnd.text integerValue] > [yMaze.text integerValue] ||
        [zEnd.text integerValue] > [zMaze.text integerValue] ||
        
        ([xStart.text integerValue] == [xEnd.text integerValue] &&
         [yStart.text integerValue] == [yEnd.text integerValue] &&
         [zStart.text integerValue] == [zEnd.text integerValue]) ||
        
        ([xMaze.text integerValue] == 0 || [yMaze.text integerValue] == 0 || [zMaze.text integerValue] == 0) ||
        
        (xMaze.text.length == 0 || yMaze.text.length == 0 || zMaze.text.length == 0 ||
         xStart.text.length == 0 || yStart.text.length == 0 || zStart.text.length == 0 ||
         xEnd.text.length == 0 || yEnd.text.length == 0 || zEnd.text.length == 0)
        
    ){
        
        [[[UIAlertView alloc] initWithTitle:@"Maze Dimensions or Start/End Point" message:@"The Start or End point cannot be beyond the maze's dimensions and the start and end point cannot be the same and all boxes must be filled out. Please check your input" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSMazeCreatorController:didCreateMaze:)]) {
        [self.delegate JSMazeCreatorController:self didCreateMaze:self.maze];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonPressed:(UIBarButtonItem *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSMazeCreatorController:didCancelMazeCreation:)]) {
        [self.delegate JSMazeCreatorController:self didCancelMazeCreation:button];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)createMaze
{
    NSMutableArray *maze = [NSMutableArray array];
    
    NSArray *startPoint = [NSArray arrayWithObjects:xStart.text, yStart.text, zStart.text, nil];
    NSArray *endPoint = [NSArray arrayWithObjects:xEnd.text, yEnd.text, zEnd.text, nil];
    
    for (int z = 0; z < [zMaze.text integerValue]; z++) {
        for (int y = 0; y < [yMaze.text integerValue]; y++) {
            
            NSMutableArray *a = [NSMutableArray array];
            for (int x = 0; x < [xMaze.text integerValue]; x++) {
                
                if ([[startPoint objectAtIndex:0] integerValue] == x &&
                    [[startPoint objectAtIndex:1] integerValue] == y &&
                    [[startPoint objectAtIndex:2] integerValue] == z) {
                    [a addObject:@"B"];
                } else if ([[endPoint objectAtIndex:0] integerValue] == x &&
                    [[endPoint objectAtIndex:1] integerValue] == y &&
                    [[endPoint objectAtIndex:2] integerValue] == z) {
                    [a addObject:@"E"];
                } else {
                    [a addObject:@"."];
                }
            }
            [maze addObject:a];
        }
    }
    NSLog(@"%@", maze);
    
    return self.maze;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
