3D-Maze-Solver
==============
A Three Dimensional Maze solver.

Instructions: 
1. Create a .txt file that has equal length and width dimensions with x number of levels with '.' as open paths and '#' as walls.
2. The initial starting position should be labeled 'B' as Bot. The end point should be labeled 'E'.
3. When initializing a Maze Object, use the initWithMaze:update:seconds:bots:algorithm method 
 
 - Initializes a Maze to be solved
 - @param maze NSString: The name/path of the file that contains the maze
 - @param update BOOL: When flagged true, updates the UI with the steps taken by the computer
 - @param seconds float: Amount of time before the next move will be made.
 - @param bots NSInteger: Number of bots entering the maze.
 - @param algorithm NSInteger: 0 = backtracking, 1 = depth-first search, 2 = breadth-first search
 
 *** Currently, the maze solver doesn't allow for more than one bot. ***
