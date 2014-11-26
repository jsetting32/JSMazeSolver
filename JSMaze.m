//
//  Maze.m
//  MazeSolver
//
//  Created by John Setting on 9/16/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSMaze.h"

@interface Node : NSObject
@property NSArray * coords;
@property Node * parent;
@end

@implementation Node
@end

@interface JSMaze()
@property NSString *fileName;
@property BOOL update;
@property float seconds;
@property NSMutableArray *gamemaze;
@property NSMutableArray *endPosition;
@property NSMutableArray *startPosition;
@property NSInteger bots;
@property NSMutableArray *queue;
@property BOOL success;
@end

@implementation JSMaze

- (id)initWithMaze:(NSString *)maze andUpdate:(BOOL)update everyXSeconds:(float)seconds withXNumOfBots:(NSInteger)bots algorithm:(NSInteger)algorithm
{
    if(!(self = [super init])) return nil;
    self.bots = bots;
    self.seconds = seconds;
    self.update = update;
    self.fileName = maze;
    self.endPosition = nil;
    self.startPosition = nil;
    self.moveSequence = [NSMutableString string];
    self.queue = [NSMutableArray array];
    self.success = false;
    self.algorithm = algorithm;
    self.running = true;
    return self;
}

- (BOOL)parseFile
{
    NSString* theFileName = [[self.fileName lastPathComponent] stringByDeletingPathExtension];
    NSString * myFile = [[NSBundle mainBundle] pathForResource:theFileName ofType:@"txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: myFile ]) {
        NSLog(@"Couldn't Find File At Path: %@", myFile);
        return false;
    }
    
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:myFile encoding:NSUTF8StringEncoding error:&error];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
    
    int rowsInMaze = 0;
    for (NSString *s in array) {
        if ([s isEqualToString:@""]) break;
        rowsInMaze++;
    }
    
    NSArray *noEmptyStrings = [array filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"length > 0"]];
    
    NSMutableArray *a = [NSMutableArray array];
    NSMutableArray *b = [NSMutableArray array];
    
    int i = 0;
    for (NSString *s in noEmptyStrings) {
        i++;
        if (i % rowsInMaze != 0) {
            NSMutableArray *colsarr = [NSMutableArray array];
            NSUInteger len = [s length];
            unichar buffer[len+1];
            [s getCharacters:buffer range:NSMakeRange(0, len)];
            for(int iter = 0; iter < len; iter++) {
                [colsarr addObject:[NSString stringWithFormat:@"%C",[s characterAtIndex:iter]]];
            }
            [a addObject:colsarr];
        } else {
            NSMutableArray *colsarr = [NSMutableArray array];
            NSUInteger len = [s length];
            unichar buffer[len+1];
            [s getCharacters:buffer range:NSMakeRange(0, len)];
            for(int iter = 0; iter < len; iter++) {
                [colsarr addObject:[NSString stringWithFormat:@"%C",[s characterAtIndex:iter]]];
            }
            [a addObject:colsarr];
            [b addObject:a];
            a = [NSMutableArray array];
        }
    }
    
    self.gamemaze = [NSMutableArray arrayWithArray:b];
    return true;
}

- (NSString *)printMazeVertically
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"\n\n"];
    
    for (NSArray *str1 in self.gamemaze) {
        for (NSArray *str2 in str1) {
            for (NSString *s in str2)
                [string appendString:[NSString stringWithFormat:@"%@", s]];
            [string appendString:@"\n"];
        }
        [string appendString:@"\n"];
    }
    [string appendString:@"\n"];
    
    return string;
}

- (NSString *)printMazeHorizontally
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"\n\n"];
    
    for (int j = 0; j < [self mazeLength]; j++) {
        for (int i = 0; i < [self mazeHeight]; i++) {
            for (NSString *str in [[self.gamemaze objectAtIndex:i] objectAtIndex:j])
                [string appendString:str];
            [string appendString:@"  "];
        }
        [string appendString:@"\n"];
    }
    [string appendString:@"\n"];
    
    return string;
}

- (NSInteger)mazeWidth
{
    return [[[self.gamemaze objectAtIndex:0] objectAtIndex:0] count];
}

- (NSInteger)mazeLength
{
    return [[self.gamemaze objectAtIndex:0] count];
}

- (NSInteger)mazeHeight
{
    return [self.gamemaze count];
}

- (void)BotXYPosition
{
    NSInteger i = 0;
    for (NSArray * height in self.gamemaze) {
        NSInteger j = 0;
        for (NSArray * row in height) {
            NSInteger k = 0;
            for (NSString * col in row) {
                if ([col isEqualToString:@"B"]) {
                    self.startPosition = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%i", (int)k],
                                                                          [NSString stringWithFormat:@"%i", (int)j],
                                                                          [NSString stringWithFormat:@"%i", (int)i]]];
                    return;
                }
                k++;
            }
            j++;
        }
        i++;
    }
}

- (void)FinishPosition
{
    NSInteger i = 0;
    for (NSArray * height in self.gamemaze) {
        NSInteger j = 0;
        for (NSArray * row in height) {
            NSInteger k = 0;
            for (NSString * col in row) {
                if ([col isEqualToString:@"E"]) {
                    self.endPosition = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%i", (int)k],
                                                                        [NSString stringWithFormat:@"%i", (int)j],
                                                                        [NSString stringWithFormat:@"%i", (int)i]]];
                    return;
                }
                k++;
            }
            j++;
        }
        i++;
    }
}

- (void)solve {
    
    if (![self parseFile])
        return;
    
    if (self.algorithm != AlgorithmBacktracking) {
        if ([self BFS_DFS_solve:-1 y:-1 z:-1]) {
            NSLog(@"Escapable: %@", self.moveSequence);
            return;
        }
        NSLog(@"Unescapable");
        return;
    }
    
    if ([self BacktrackingSolve:-1 y:-1 z:-1]) {
        NSLog(@"Escapable: %@", self.moveSequence);
        return;
    }

    NSLog(@"Unescapable");
    return;
}

- (BOOL)BFS_DFS_solve:(NSInteger)x y:(NSInteger)y z:(NSInteger)z
{
    if (x < 0 || y < 0 || z < 0) {
        x = [[self.startPosition objectAtIndex:0] integerValue];
        y = [[self.startPosition objectAtIndex:1] integerValue];
        z = [[self.startPosition objectAtIndex:2] integerValue];
        
        [self BotXYPosition];
        [self FinishPosition];
    }
    
    Node *node = [[Node alloc] init];
    node.coords = @[[NSNumber numberWithInteger:x], [NSNumber numberWithInteger:y], [NSNumber numberWithInteger:z]];
    [self.queue addObject:node];
    
    while (!self.success && [self.queue count] != 0) {
        
        if (!self.running) return false;
        
        if (self.algorithm == AlgorithmDFS) {
            node = [self.queue objectAtIndex:[self.queue count] - 1];
            [self.queue removeLastObject];
        } else if (self.algorithm == AlgorithmBFS) {
            node = [self.queue objectAtIndex:0];
            [self.queue removeObjectAtIndex:0];
        }
        
        NSInteger x = [[node.coords objectAtIndex:0] integerValue];
        NSInteger y = [[node.coords objectAtIndex:1] integerValue];
        NSInteger z = [[node.coords objectAtIndex:2] integerValue];
        
        [self enqueueForBFS_DFS:x-1 y:y z:z node:node];
        [self enqueueForBFS_DFS:x+1 y:y z:z node:node];
        [self enqueueForBFS_DFS:x y:y-1 z:z node:node];
        [self enqueueForBFS_DFS:x y:y+1 z:z node:node];
        [self enqueueForBFS_DFS:x y:y z:z-1 node:node];
        [self enqueueForBFS_DFS:x y:y z:z+1 node:node];
    }
    
    // If there was no path to the exit... return
    if (!self.success)
        return false;
    
    // Clear the maze of visited positions
    for(int z = 0; z < [self mazeHeight]; z++)
        for(int y = 0; y < [self mazeLength]; y++)
            for(int x = 0; x < [self mazeWidth]; x++)
                if([[[[self.gamemaze objectAtIndex:z] objectAtIndex:y] objectAtIndex:x] isEqualToString:@"*"])
                    [[[self.gamemaze objectAtIndex:z] objectAtIndex:y] replaceObjectAtIndex:x withObject:@"."];
    
    // Set the end position
    NSInteger endx = [[[self endPosition] objectAtIndex:0] integerValue];
    NSInteger endy = [[[self endPosition] objectAtIndex:1] integerValue];
    NSInteger endz = [[[self endPosition] objectAtIndex:2] integerValue];
    [[[self.gamemaze objectAtIndex:endz] objectAtIndex:endy] replaceObjectAtIndex:endx withObject:@"E"];
    
    
    if (self.update) {
        [self.delegate didMakeMove:self.printMazeVertically];
        [NSThread sleepForTimeInterval:self.seconds];
    }
    
    
    NSInteger x1 = [[self.endPosition objectAtIndex:0] integerValue];
    NSInteger y1 = [[self.endPosition objectAtIndex:1] integerValue];
    NSInteger z1 = [[self.endPosition objectAtIndex:2] integerValue];
    
    while(node.parent || node) {
        NSInteger x = [[node.coords objectAtIndex:0] integerValue];
        NSInteger y = [[node.coords objectAtIndex:1] integerValue];
        NSInteger z = [[node.coords objectAtIndex:2] integerValue];
        
        if (self.update) {
            [self.delegate didMakeMove:self.printMazeVertically];
            [NSThread sleepForTimeInterval:self.seconds];
        }
        
        if (x1 < x) {
            [self.moveSequence insertString:@"W" atIndex:0];
        } else if (x1 > x) {
            [self.moveSequence insertString:@"E" atIndex:0];
        } else if (y1 < y) {
            [self.moveSequence insertString:@"N" atIndex:0];
        } else if (y1 > y) {
            [self.moveSequence insertString:@"S" atIndex:0];
        } else if (z1 < z) {
            [self.moveSequence insertString:@"D" atIndex:0];
        } else if (z1 > z) {
            [self.moveSequence insertString:@"U" atIndex:0];
        }
        
        x1 = x;
        y1 = y;
        z1 = z;
        
        [[[self.gamemaze objectAtIndex:z] objectAtIndex:y] replaceObjectAtIndex:x withObject:@"*"];
        node = node.parent;
    }
     
    return true;
}



/*
 For each move, we must first check if the move being made is on the board AND
 (a non-visited open space OR the end position)
 Then recursively call the solve::: function
 E.g

 1.      2.      3.      4.      5.      6.      7.

 * . #   * * #   * . #   * . #   * . #   * . #   * . #
 . # .   . # .   . # .   * # .   * # .   * # .   * # .
 . . E   . . E   . . E   . . E   * . E   * * E   * * *


 1. Replace B with a star to label it as visited.

 2. Cannot move West
 Then move East and add a star to mark a visited position

 3. Cannot move West since it's already been visited, cannot move East, South, or North
 BackTrack x number of times

 4. Cannot move West, skip East since the solve has already passed it for this iteration
 Cannot move North
 Then move South and add a star to mark a visited position

 5. Cannot move West, East or North
 Then move South and add a star to mark a visited position

 6. Cannot move West
 Then move East and add a star to mark a visited position

 7. Cannot move West
 Then move East and add a star to mark a visited position

 8. x,y,z are all equal to the end position coordinates. We are finished.
*/

- (BOOL)BacktrackingSolve:(NSInteger)x y:(NSInteger)y z:(NSInteger)z
{
    if (![self isRunning]) return false;
    
    // Set all variables
    if (x < 0 || y < 0 || z < 0) {
        x = [[self.startPosition objectAtIndex:0] integerValue];
        y = [[self.startPosition objectAtIndex:1] integerValue];
        z = [[self.startPosition objectAtIndex:2] integerValue];
        [self BotXYPosition];
        [self FinishPosition];
    }
    
    if (self.update) {
        [self.delegate didMakeMove:self.printMazeVertically];            
        [NSThread sleepForTimeInterval:self.seconds];
    }
    
    // Set visited
    [[[self.gamemaze objectAtIndex:z] objectAtIndex:y] replaceObjectAtIndex:x withObject:@"*"];

    // If the computer is at the end position, return true
    if (x == [[self.endPosition objectAtIndex:0] integerValue] &&
        y == [[self.endPosition objectAtIndex:1] integerValue] &&
        z == [[self.endPosition objectAtIndex:2] integerValue]) {
        return true;
    }
    
    // Move West
    if ([self makeMove:x-1 y:y z:z] && [self BacktrackingSolve:x-1 y:y z:z]) {
        [self.moveSequence insertString:@"W" atIndex:0];
        return true;
    }
    
    // Move East
    if ([self makeMove:x+1 y:y z:z] && [self BacktrackingSolve:x+1 y:y z:z]) {
        [self.moveSequence insertString:@"E" atIndex:0];
        return true;
    }
    
    //Move North
    if ([self makeMove:x y:y-1 z:z] && [self BacktrackingSolve:x y:y-1 z:z]) {
        [self.moveSequence insertString:@"N" atIndex:0];
        return true;
    }
    
    // Move South
    if ([self makeMove:x y:y+1 z:z] && [self BacktrackingSolve:x y:y+1 z:z]) {
        [self.moveSequence insertString:@"S" atIndex:0];
        return true;
    }
    
    // Move Down
    if ([self makeMove:x y:y z:z-1] && [self BacktrackingSolve:x y:y z:z-1]) {
        [self.moveSequence insertString:@"D" atIndex:0];
        return true;
    }
    
    // Move Up
    if ([self makeMove:x y:y z:z+1] && [self BacktrackingSolve:x y:y z:z+1]) {
        [self.moveSequence insertString:@"U" atIndex:0];
        return true;
    }
    
    // Backtrack
    [[[self.gamemaze objectAtIndex:z] objectAtIndex:y] replaceObjectAtIndex:x withObject:@"."];
    
    return false;
        
}

- (BOOL)makeMove:(NSInteger)x y:(NSInteger)y z:(NSInteger)z
{
    // Check if moving out of bounds
    if (!(x < 0 || x > [self mazeWidth] - 1 || y < 0 || y > [self mazeLength] - 1 || z < 0 || z > [self mazeHeight] - 1) &&
        // Check if moving into an open space or end point
        ([[[[self.gamemaze objectAtIndex:z] objectAtIndex:y] objectAtIndex:x] isEqualToString: @"."] ||
         [[[[self.gamemaze objectAtIndex:z] objectAtIndex:y] objectAtIndex:x] isEqualToString: @"E"]))
            return true;
    return false;
}

- (void)enqueueForBFS_DFS:(NSInteger)x y:(NSInteger)y z:(NSInteger)z node:(Node *)node
{
    if (self.success)
        return;
    
    if(x == [[[self endPosition] objectAtIndex:0] integerValue] &&
       y == [[[self endPosition] objectAtIndex:1] integerValue] &&
       z == [[[self endPosition] objectAtIndex:2] integerValue]) {
        self.success = true;
        return;
    }
    
    if ([self makeMove:x y:y z:z]) {
        
        [[[self.gamemaze objectAtIndex:z] objectAtIndex:y] replaceObjectAtIndex:x withObject:@"*"];

        if (self.update) {
            [self.delegate didMakeMove:self.printMazeVertically];
            [NSThread sleepForTimeInterval:self.seconds];
        }
        
        Node *newnode = [[Node alloc] init];
        newnode.parent = node;
        newnode.coords = @[[NSNumber numberWithInteger:x], [NSNumber numberWithInteger:y], [NSNumber numberWithInteger:z]];
        [self.queue addObject:newnode];
    }
}

- (void)stop {
    self.running = false;
}

- (BOOL)running {
    return self.running;
}


@end

