//
//  DetailsViewController.m
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuesLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = _task.title;
    _noteLabel.text = _task.note;
    _dateLabel.text = _task.date;
    switch (_task.taskPriority) {
        case 0:
            _priorityLabel.text = @"High";
            break;
        case 1:
            _priorityLabel.text = @"Medium";
            break;
        case 2:
            _priorityLabel.text = @"Low";
            break;
        default:
            break;
    }
    switch (_task.statue) {
        case 0:
            _statuesLabel.text = @"To Do";
            break;
        case 1:
            _statuesLabel.text = @"In Progress";
            break;
        case 2:
            _statuesLabel.text = @"Done";
            break;
        default:
            break;
    }
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
