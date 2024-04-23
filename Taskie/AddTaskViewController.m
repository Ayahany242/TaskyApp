//
//  AddTaskViewController.m
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import "AddTaskViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AddTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet UITextField *noteTf;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorities;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statues;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UISwitch *switchOutLet;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    switch (_btnMethod) {
        case 0:
            _task = [[TaskModel alloc] init];
            [self isItemsEnabled:YES];
            _screenTitle.text = @"Add new task";
            break;
        case 2:
            _screenTitle.text = @"Details";
            [self isItemsEnabled:NO];
            [self setData];
            break;
        default:
            _screenTitle.text = @"Update Task";
            [self setData];
            [self isItemsEnabled:YES];
            break;
    }
    printf("viewWillAppear btn Method %d",_btnMethod);
}
-(void) setData{
    _titleTf.text = _task.title;
    _noteTf.text = _task.note;
    _priorities.selectedSegmentIndex = _task.taskPriority;
    _statues.selectedSegmentIndex = _task.statue;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    NSDate *specificDate = [formatter dateFromString:_task.date];
    [self.datePicker setDate:specificDate animated:YES];
}
-(void) isItemsEnabled: (Boolean) isShowDetailes{
    _saveBtn.hidden = !isShowDetailes;
    _titleTf.enabled = isShowDetailes;
    _noteTf.enabled = isShowDetailes;
    _datePicker.enabled = isShowDetailes;
    //_priorities.enabled = isShowDetailes;
    _priorities.userInteractionEnabled = isShowDetailes;
    _statues.userInteractionEnabled = isShowDetailes;
    _switchOutLet.hidden = !isShowDetailes;
    _alarmLabel.hidden = !isShowDetailes;
    //_statues.enabled = isShowDetailes;
}

-(void ) addTask{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Task" message:@"Task Added Successfully" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //navigate
        NSLog(@"addTask View Controller Task %@\n",self->_task.title);
        [self.taskProtocol addNewTask:self->_task];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    [okBtn setValue:[UIColor colorWithRed:0/255.0f green:128/255.0f blue:0/255.0f alpha:1.0f] forKey:@"titleTextColor"];
    [alert addAction:okBtn];
    [self presentViewController:alert animated:YES completion:nil];
    if(_titleTf.text != nil){
        _task.title =_titleTf.text;
    }
    if(_noteTf.text != nil){
        _task.note = _noteTf.text;
    }
    _task.date = [self setDate];
    NSLog(@"%@", _task.date);
    _task.statue = (int)_statues.selectedSegmentIndex;
    _task.taskPriority =(int)_priorities.selectedSegmentIndex;
}
-(void ) updateTask{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Update Task" message:@"Are you sure you want to update this task?" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //navigate
        
        TaskModel * t = [TaskModel new];
        t.title = self->_titleTf.text;
        t.note =self->_noteTf.text ;
        t.date = [self setDate] ;
        t.taskPriority=(int)self->_priorities.selectedSegmentIndex ;
        t.statue  =(int)self->_statues.selectedSegmentIndex;
        [self->_taskProtocol updateTask:t index:self->_taskIndex];
        
        //[self.taskProtocol addNewTask:self->_task];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:cancelBtn];
    [alert addAction:okBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}
-(NSString *) setDate {
    NSDate *selectedDate = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    return [formatter stringFromDate:selectedDate];
}
- (IBAction)saveTask:(id)sender {
    switch (_btnMethod) {
        case 0:
            [self addTask];
            break;
        case 1:
            [self updateTask];
            break;
        default:
            break;
    }
    
}
- (IBAction)dismissTask:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchAction:(id)sender {
    UISwitch *theSwitch = (UISwitch *)sender;
    if (theSwitch.isOn) {
        NSLog(@"Switch is ON");
        [self scheduleAlarm];
    } else {
        NSLog(@"Switch is OFF");
    }
}

- (void)scheduleAlarm{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Tasky";
    content.body = [NSString stringWithFormat:@"It's time to do %@ ", _titleTf.text];
    content.sound = [UNNotificationSound defaultSound];
    
//    //get the date from string
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"EEEE, MMMM d, yyyy"];
//    NSDate *specificDate = [formatter dateFromString:_task.date];
    NSDate *specificDate = _datePicker.date;

    //set date to Calender to use it in NSDateComponents
    NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:specificDate];
        
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
    
    // Create a request with a unique identifier
    NSString *identifier = [NSString stringWithFormat:@"TaskNotification_%@", [[NSUUID UUID] UUIDString]];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content
                                                                          trigger:trigger];
    
    // Add the request to the notification center
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error scheduling alarm: %@", error);
        } else {
            NSLog(@"Alarm scheduled successfully");
        }
    }];
}

@end
