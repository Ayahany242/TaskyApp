//
//  ViewController.m
//  Taskie
//
//  Created by AYA on 19/04/2024.
//

#import "DoneViewController.h"
#import "InProgressViewController.h"
#import "DetailsViewController.h"
#import "AddTaskViewController.h"
#import "UserDefaults.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyListLabel;
@property NSMutableArray<TaskModel *>* taskHigh, *taskMediam, *taskLow;
@property Boolean isFilter;
@end

@implementation DoneViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks = [NSMutableArray new];
    _showsTasks = [NSMutableArray new];
    self.emptyListLabel.hidden = YES;

}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //rgba(140,159,95,255)
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor  colorWithRed:0/255.0f green:128/255.0f blue:0/255.0f alpha:1.0f]}];
    [self loadDataFromUserDefault];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * t = @"To Do Tasks";
    if(_isFilter){
        switch (section) {
            case 0:
                t = @"High Priority Tasks";
                break;
            case 1:
                t = @"Medium Priority Tasks";
                break;
            case 2:
                t = @"Low Priority Tasks";
                break;
            default:
                break;
        }
        return t;
    }else
        return @"Done Tasks";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isFilter)
        return 3;
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //[self updateShowList];
    if(_isFilter){
        self.emptyListLabel.hidden = YES;
        switch (section) {
            case 0:
                return _taskHigh.count;
                break;
            case 1:
                return _taskMediam.count;
                break;
            case 2:
                return _taskLow.count;
                break;
            default:
                return 0;
                break;
        }
    }else{
        self.emptyListLabel.hidden = (_showsTasks.count > 0);
        return _showsTasks.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //[self applyFilter:(int)indexPath.section];
    TaskModel *task;
    if (!_isFilter) {
        task = _showsTasks[indexPath.row];
        printf("cell !filter");
    } else {
        printf("cell filter");
        switch (indexPath.section) {
            case 0:
                task = _taskHigh[indexPath.row];
                break;
            case 1:
                task = _taskMediam[indexPath.row];
                break;
            case 2:
                task = _taskLow[indexPath.row];
                break;
            default:
                return 0;
                break;
        }
    }
    cell.textLabel.text = task.title;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.detailTextLabel.text = task.date;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", task.taskPriority]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    vc.taskProtocol = self;
    vc.btnMethod = 2;
    vc.task = _showsTasks[indexPath.row];
    vc.taskIndex =(int) [_tasks indexOfObject:_showsTasks[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self confirmDeleteItemAtIndexPath:indexPath];
        }];
        
        UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self editItemAtIndexPath:indexPath];
        }];
        
        return @[deleteAction, editAction];
}
- (void)confirmDeleteItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteItemAtIndexPath:indexPath];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:yes];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tasks removeObject:_showsTasks[indexPath.row]];
    [self updateShowList];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   [self saveTask];
}

- (void)editItemAtIndexPath:(NSIndexPath *)indexPath {
    AddTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    vc.taskProtocol = self;
    vc.btnMethod = 1;
    vc.task = _showsTasks[indexPath.row];
    vc.taskIndex =(int) [_tasks indexOfObject:_showsTasks[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateTask:(TaskModel *)task index:(int)index{
     [_tasks replaceObjectAtIndex:index withObject:task];
    [self updateShowList];
    [self saveTask];
    [self.tableView reloadData];
}

-(void) loadDataFromUserDefault{
   _tasks = [UserDefaults loadTasksFromUserDefaults];
    if ([_tasks count] != 0) {
        printf("[tasksArray count] != 0 %d \n",(int)_tasks.count);
        [self updateShowList];
        [self.tableView reloadData];
    }
}
-(void) saveTask{
    [UserDefaults saveData:_tasks];
}
-(void) updateShowList{
    [_showsTasks removeAllObjects];
    for (TaskModel *task in _tasks) {
        switch (task.statue) {
            case 2:
                [_showsTasks addObject:task];
                printf(".count [_showsTasks %d\n",(int)_showsTasks.count);
                break;
            default:
                break;
        }
    }
}
- (void)applyFilter{
    if (_isFilter) {
        for (TaskModel *t in _showsTasks) {
                switch (t.taskPriority) {
                    case 0:
                        [_taskHigh addObject:t];
                        printf("high %d\n",(int)_taskHigh.count);
                        break;
                    case 1:
                        [_taskMediam addObject:t];
                        printf("mediam %d\n",(int)_taskMediam.count);
                        break;
                    case 2:
                        [_taskLow addObject:t];
                        printf("low %d\n",(int)_taskLow.count);
                        break;
                    default:
                        break;
                }
            }
    }else{
        _taskLow.removeAllObjects;
        _taskHigh.removeAllObjects;
        _taskMediam.removeAllObjects;
    }
}
- (IBAction)filterBtn:(id)sender {
    _isFilter = !_isFilter;
    [self updateShowList];
    [self applyFilter];
    [self.tableView reloadData];
}
@end

