//
//  Maze.h
//  MazeSolver
//
//  Created by John Setting on 9/16/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    
    AlgorithmAstar = 0,
    AlgorithmBFS = 1,
    AlgorithmDFS = 2,
    AlgorithmBacktracking = 3
    
}; NSInteger AlgorithmTypes;

@protocol MazeProtocol;

@interface JSMaze : NSObject

/*! @name Configuring Maze behaviors */
/// The delegate that responds to the moves made by the maze
@property (nonatomic) id<MazeProtocol>delegate;

/*! @name Creating a Maze object */
/*!
 Initializes a Maze to be solved
 @param maze NSString: The name/path of the file that contains the maze
 @param update BOOL: When flagged true, updates the UI with the steps taken by the computer
 @param seconds float: Amount of time before the next move will be made.
 @param bots NSInteger: Number of bots entering the maze.
 @param algorithm NSInteger: 0 = backtracking, 1 = depth-first search, 2 = breadth-first search
 */
- (id)initWithMaze:(NSString *)maze andUpdate:(BOOL)update everyXSeconds:(float)seconds withXNumOfBots:(NSInteger)bots algorithm:(NSInteger)algorithm;

/*! @name Parses the file (e.g Maze.txt) */
/*!
 Parses the file passed to the initializer and loads the maze into a 3d NSMutableArray
 IMPORTANT: This method must be called before running the solve method
 */
- (BOOL)parseFile;

/*! @name Prints the maze in a vertical format */
/*!
 If the maze is 2-Dimensional, the difference between vertical and horizontal is voided
 */
- (NSString *)printMazeVertically;

/*! @name Prints the maze in a horizontal format */
/*!
 If the maze is 2-Dimensional, the difference between vertical and horizontal is voided
 */
- (NSString *)printMazeHorizontally;

/*! @name Calls the algorithm to solve the maze */
/*!
 IMPORTANT: This method must be used to solve the maze
 */
- (void)solve;

/*! @name Solves the given maze using backtracking */
/*!
 BacktrackingSolve:y:z: will recursively solve the maze
 IMPORTANT: To initially start this method, the client must pass in variables less than 0 to either x,y,or z. The
 method will first look for the starting position labeled 'B' and the end point 'E'. Then iterate through all the moves
 possible (NORTH, EAST, SOUTH, WEST, UP, DOWN) and recursively call itself until no more possible moves are available while moving
 in the committed direction, backtrack, and start over but moving in another direction.
 
 @param x NSInteger: The x coordinate
 @param y NSInteger: The y coordinate
 @param z NSInteger: The z coordinate
 */
- (BOOL)BacktrackingSolve:(NSInteger)x y:(NSInteger)y z:(NSInteger)z;


/*! @name Solves the given maze using breadth-first search */
/*!
 BFS_DFS_Solve:y:z: will iteratively solve the maze
 IMPORTANT: To initially start this method, the client must pass in variables less than 0 to either x,y,or z. 
 The method will solve the maze using depth first search or breadth first search depending on how the client initialized the maze object.
 Difference between BFS and DFS, DFS uses a stack implementation and BFS uses a queue implementation
 
 @param x NSInteger: The x coordinate
 @param y NSInteger: The y coordinate
 @param z NSInteger: The z coordinate
 */
- (BOOL)BFS_DFS_solve:(NSInteger)x y:(NSInteger)y z:(NSInteger)z;

/*! @name Stops the algorithm from running */
/*!
 */
- (void)stop;

/** @name Get the final move sequence */
/*!
 Returns a string object of the moves made to solve the maze.
 */
@property (nonatomic) NSMutableString *moveSequence;

/** @name Gets the puzzle solver choice */
/*!
 Returns the decision of the client of which algorithm to use
 */
@property (nonatomic) NSInteger algorithm;


/** @name Returns the variable that checks if the maze is being solved */
/*!
 Returns the variable
 */
@property (nonatomic, getter=isRunning) BOOL running;

@end

/*!
 The protocol defines methods a delegate of a Maze should implement.
 All methods of the protocol are optional but should be used if a delegate is set.
 */
@protocol MazeProtocol <NSObject>
@optional

/// Sent to the delegate when a move has been made.
- (void)didMakeMove:(NSString *)maze;
@end