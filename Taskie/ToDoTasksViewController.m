//
//  ToDoTasksViewController.m
//  Taskie
//
//  Created by AYA on 19/04/2024.
//

#import "ToDoTasksViewController.h"
#import "AddTaskViewController.h"
#import "DetailsViewController.h"
#import "UserDefaults.h"
#import <UserNotifications/UserNotifications.h>

@interface ToDoTasksViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *search;
@property NSMutableArray<TaskModel *> *searchedTasks;
@property (weak, nonatomic) IBOutlet UIImageView *emptyListLabel;
@property Boolean isFilter;
@property TaskModel *tt;
@property NSMutableArray<TaskModel *>* taskHigh, *taskMediam, *taskLow;

@end

@implementation ToDoTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestToPermission];
    _tasks = [NSMutableArray new];
    _showsTasks = [NSMutableArray new];
    _search.delegate = self;
    _taskHigh = [NSMutableArray new];
    _taskMediam = [NSMutableArray new];
    _taskLow = [NSMutableArray new];
    //[self saveTask];
}
- (void)viewWillAppear:(BOOL)animated{
    //[_tasks addObject:_tt];
//    [self loadDataFromUserDefault];
    
    [self loadDataFromUserDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //rgba(140,159,95,255)
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor  colorWithRed:0/255.0f green:128/255.0f blue:0/255.0f alpha:1.0f]}];
    
}

- (IBAction)addTaskBtn:(id)sender {
    AddTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    vc.taskProtocol = self;
    vc.btnMethod = 0;
    [self.navigationController pushViewController:vc animated:YES];
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
        return @"To Do Tasks";
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isFilter)
        return 3;
    else
        return 1;
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
    //[self.showsTasks removeObjectAtIndex:indexPath.row];
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

- (void)addNewTask:(TaskModel *)task{
    printf("addNewTask tha task is %d \n",task.taskPriority);
    [self.tasks addObject:task];
    //_showsTasks = _tasks;
    [self updateShowList];
    [self.tableView reloadData];
    [self saveTask];
    printf("Tasks count addNewTask = %d \n", (int)_tasks.count);
}

- (void)updateTask:(TaskModel *)task index:(int)index{
     [_tasks replaceObjectAtIndex:index withObject:task];
    printf("_tasks.count  %d\n",(int)_tasks.count);
    [self updateShowList];
    [self saveTask];
    [self.tableView reloadData];
}
-(void) updateShowList{
    printf("before _showsTasks.count %d\n",(int)_tasks.count);
    [_showsTasks removeAllObjects];
    for (TaskModel *task in _tasks) {
        printf("task loop %d",(int)task.statue);
        if(task.statue == 0){
            [_showsTasks addObject:task];
            printf("_showsTasks.count %d\n",(int)_showsTasks.count);
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"Search text changed: %@", searchText);
    
    if (searchText.length == 0) {
        [self updateShowList];
        [self.tableView reloadData];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH[cd] %@", searchText];
        NSArray<TaskModel *> *filteredTasks = [_tasks filteredArrayUsingPredicate:predicate];
        
        _showsTasks = [NSMutableArray arrayWithArray:filteredTasks];
        [self.tableView reloadData];
    }
    return YES;
}
-(void) loadDataFromUserDefault{
   _tasks  = [UserDefaults loadTasksFromUserDefaults];
    if ([_tasks count] != 0) {
        printf("[tasksArray count] != 0 %d \n",(int)_tasks.count);
        //[toDoList addObjectsFromArray:tasksArray];
        //_showsTasks = [NSMutableArray arrayWithArray:_tasks];
        [self updateShowList];
        [self.tableView reloadData];
    }
}
-(void) saveTask{
    [UserDefaults saveData:_tasks];
}
- (IBAction)filterBtn:(id)sender {
    _isFilter = !_isFilter;
    [self updateShowList];
    [self applyFilter];
    [self.tableView reloadData];
}
-(void) requestToPermission{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (error) {
                                  NSLog(@"Error requesting authorization for notifications: %@", error);
                              } else {
                                  if (granted) {
                                      NSLog(@"Notification authorization granted");
                                      
                                  } else {
                                      NSLog(@"Notification authorization denied");
                                  }
                              }
                          }];
}
@end
