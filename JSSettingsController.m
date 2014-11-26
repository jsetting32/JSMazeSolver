//
//  JSSettingsController.m
//  3D Maze Solver
//
//  Created by John Setting on 11/25/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSSettingsController.h"
#import "JSMazeCreatorController.h"

@interface JSSettingsController () <UITableViewDataSource, UITableViewDelegate, JSMazeCreatorDelegate>
@property (nonatomic) UITableView *table;
@property (nonatomic) NSIndexPath *chosenAlgorithm;
@property (nonatomic) NSIndexPath *chosenSpeed;
@property (nonatomic) NSIndexPath *chosenMaze;
@end

@implementation JSSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.table];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    
    NSUserDefaults *filterResultsDefault = [[NSUserDefaults alloc] init];
    self.chosenAlgorithm = [NSIndexPath indexPathForRow:[filterResultsDefault integerForKey:@"algorithm"] inSection:0];
    self.chosenMaze = [NSIndexPath indexPathForRow:[filterResultsDefault integerForKey:@"maze"] inSection:1];
    self.chosenSpeed = [NSIndexPath indexPathForRow:[filterResultsDefault integerForKey:@"speed"] inSection:2];

}

- (void)doneButtonPressed:(UIBarButtonItem *)button {
    
    NSUserDefaults *filterResultsDefault = [[NSUserDefaults alloc] init];
    [filterResultsDefault setInteger:self.chosenAlgorithm.row forKey:@"algorithm"];
    [filterResultsDefault setInteger:self.chosenMaze.row forKey:@"maze"];
    [filterResultsDefault setInteger:self.chosenSpeed.row forKey:@"speed"];
    [filterResultsDefault synchronize];

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Algorithms";
    } else if (section == 1) {
        return @"Maze";
    } else {
        return @"Speed";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
     
        if([self.chosenAlgorithm isEqual:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if(self.chosenAlgorithm) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.chosenAlgorithm];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 0) {
            [[cell textLabel] setText:@"A star"];
        } else if (indexPath.row == 1) {
            [[cell textLabel] setText:@"Breadth-First Search"];
        } else if (indexPath.row == 2) {
            [[cell textLabel] setText:@"Depth-First Search"];
        } else if (indexPath.row == 3) {
            [[cell textLabel] setText:@"Backtracking"];
        }
        
    } else if (indexPath.section == 1) {
        
        if([self.chosenMaze isEqual:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if(self.chosenMaze) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.chosenMaze];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 0) {
            [[cell textLabel] setText:@"Use Default Maze"];
        } else if (indexPath.row == 1) {
            [[cell textLabel] setText:@"Create My Own Maze"];
        }
        
    } else {
        
        if([self.chosenSpeed isEqual:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if(self.chosenSpeed) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.chosenSpeed];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if (indexPath.row == 0) {
            [[cell textLabel] setText:@"Fastest"];
        } else if (indexPath.row == 1) {
            [[cell textLabel] setText:@"Fast"];
        } else if (indexPath.row == 2) {
            [[cell textLabel] setText:@"Normal"];
        } else if (indexPath.row == 3) {
            [[cell textLabel] setText:@"Slow"];
        } else if (indexPath.row == 4) {
            [[cell textLabel] setText:@"Slowest"];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {

        if(self.chosenAlgorithm) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.chosenAlgorithm];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.chosenAlgorithm = indexPath;
    
    } else if (indexPath.section == 1) {
    
        if(self.chosenMaze) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.chosenMaze];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.chosenMaze = indexPath;
        
        if (indexPath.row == 1) {
            JSMazeCreatorController *creator = [[JSMazeCreatorController alloc] init];
            [creator setDelegate:self];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:creator] animated:YES completion:nil];
        }
    
    } else {
        
        if(self.chosenSpeed) {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.chosenSpeed];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.chosenSpeed = indexPath;
        
    }
}

- (void)JSMazeCreatorController:(JSMazeCreatorController *)controller didCreateMaze:(NSMutableArray *)maze
{
    NSLog(@"%@", maze);
}

- (void)JSMazeCreatorController:(JSMazeCreatorController *)controller didCancelMazeCreation:(UIBarButtonItem *)button
{
    NSLog(@"didCancelMazeCreation");
    [self tableView:self.table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        [_table setDelegate:self];
        [_table setDataSource:self];
    }
    return _table;
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
