//
//  JSMazeCreatorController.h
//  3D Maze Solver
//
//  Created by John Setting on 11/25/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSMazeCreatorDelegate;

@interface JSMazeCreatorController : UIViewController
@property (nonatomic, weak)id<JSMazeCreatorDelegate>delegate;
@end

@protocol JSMazeCreatorDelegate <NSObject>
- (void)JSMazeCreatorController:(JSMazeCreatorController *)controller didCreateMaze:(NSMutableArray *)maze;
- (void)JSMazeCreatorController:(JSMazeCreatorController *)controller didCancelMazeCreation:(UIBarButtonItem *)button;
@end