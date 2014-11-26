//
//  MainViewController.m
//  3D Maze Solver
//
//  Created by John Setting on 9/14/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSMazeController.h"
#import "JSSettingsController.h"
#import "JSMaze.h"

@interface JSMazeController () <MazeProtocol>
@property (nonatomic) UITextView *maze;
@property (nonatomic) UIBarButtonItem *solveButton;
@property (nonatomic) JSMaze * aMaze;
@end

@implementation JSMazeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    [self.view addSubview:self.maze];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(presentSettingsPage:)];
    
    self.solveButton = [[UIBarButtonItem alloc] initWithTitle:@"Solve" style:UIBarButtonItemStyleDone target:self action:@selector(solveTheMaze:)];
    self.navigationItem.leftBarButtonItem = self.solveButton;
}

- (void)didMakeMove:(NSString *)maze {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.maze setText:maze];
    });
}

- (void)presentSettingsPage:(UIBarButtonItem *)button {
    [self.navigationController pushViewController:[[JSSettingsController alloc] init] animated:YES];
}

- (void)solveTheMaze:(UIBarButtonItem *)button {
    
    NSUserDefaults *filterResultsDefault = [[NSUserDefaults alloc] init];
    NSInteger algorithm = [filterResultsDefault integerForKey:@"algorithm"];
    
    float speed = 0.0;
    if ([filterResultsDefault integerForKey:@"speed"] == 0) {
        speed = .001;
    } else if ([filterResultsDefault integerForKey:@"speed"] == 1) {
        speed = .01;
    } else if ([filterResultsDefault integerForKey:@"speed"] == 2) {
        speed = .1;
    } else if ([filterResultsDefault integerForKey:@"speed"] == 3) {
        speed = .5;
    } else if ([filterResultsDefault integerForKey:@"speed"] == 4) {
        speed = 1;
    }
    
    if ([[button title] isEqualToString:@"Stop"]) {
        [self.aMaze stop];
        return;
    }
    
    self.aMaze = [[JSMaze alloc] initWithMaze:@"Maze3D.txt" andUpdate:true everyXSeconds:speed withXNumOfBots:1 algorithm:algorithm];
    [self.aMaze setDelegate:self];
    [self.solveButton setTitle:@"Stop"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *start = [NSDate date];
        [self.aMaze solve];
        NSTimeInterval end = [[NSDate date] timeIntervalSinceDate:start];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.aMaze isRunning]) {
                [[[UIAlertView alloc] initWithTitle:@"Time Elapsed" message:[NSString stringWithFormat:@"The maze was solved in %f seconds", end] delegate:nil cancelButtonTitle:@"Sweet!" otherButtonTitles:nil] show];
            }
            [self.solveButton setTitle:@"Solve"];
        });
    });
}

- (UITextView *)maze
{
    if (!_maze) {
        _maze = [[UITextView alloc] initWithFrame:self.view.frame];
    }
    return _maze;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
