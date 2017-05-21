//
//  AddCourseViewController.m
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "AddCourseViewController.h"
#import "DataManager.h"
#import "AddCourseViewCell.h"
#import "CourseMO+CoreDataClass.h"
#import "StudentMO+CoreDataClass.h"
#import "PickStudentViewController.h"


@interface AddCourseViewController ()

@property (strong, nonatomic) UITextField *courseTextField;
@property (strong, nonatomic) UITextField *subjectTextField;
@property (strong, nonatomic) UITextField *departmentTextField;

@property (strong, nonatomic) NSArray *studentsArray;
@property (strong, nonatomic) CourseMO *addCourse;

@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    if (self.editCourse) {
        
        self.studentsArray = [[DataManager sharedManager] getAllStudentsInCourse:self.editCourse];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)saveAction:(UIBarButtonItem *) sender {
    
    self.addCourse.name = self.courseTextField.text;
    self.addCourse.subject = self.subjectTextField.text;
    self.addCourse.department = self.departmentTextField.text;
    [self.managedObjectContext save:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[DataManager sharedManager] persistentContainer].viewContext;
    }
    return _managedObjectContext;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 4;
    } else {
        if (self.editCourse) {
           return [self.editCourse.students count] + 1;
        } else {
            return [self.studentsArray count] + 1;
        }
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        AddCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
        
        if (self.editCourse) {
            
            switch (indexPath.row) {
                case 0:cell.nameLabel.text = @"Course name";
                    cell.textField.text = self.editCourse.name;
                    break;
                case 1:cell.nameLabel.text = @"Subject";
                    cell.textField.text = self.editCourse.subject;
                    break;
                case 2:cell.nameLabel.text = @"Department";
                    cell.textField.text = self.editCourse.department;
                    break;
                case 3:cell.nameLabel.text = @"Lecturer name";
                    break;
            }
            
        } else {
            
            switch (indexPath.row) {
                case 0:cell.nameLabel.text = @"Course name";
                    self.courseTextField = cell.textField;
                    break;
                case 1:cell.nameLabel.text = @"Subject";
                    self.subjectTextField = cell.textField;
                    break;
                case 2:cell.nameLabel.text = @"Department";
                    self.departmentTextField = cell.textField;
                    break;
                case 3:cell.nameLabel.text = @"Lecturer name";
                    break;
            }
        }
        
        return cell;

    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Add students";
        } else {
            
            StudentMO *student = [self.studentsArray objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            StudentMO *student = [self.studentsArray objectAtIndex:indexPath.row-1];
            [self.editCourse removeStudentsObject:student];

            
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.studentsArray];
            [tempArray removeObject:student];
            self.studentsArray = tempArray;
            
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
            [self.managedObjectContext save:nil];

        }
    }
}

#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PickStudentViewController *vc = [[PickStudentViewController alloc] init];
        
        vc.course = self.editCourse;
        vc.courseName = self.courseTextField.text;
        vc.courseSubject = self.subjectTextField.text;
        vc.courseDepartment = self.departmentTextField.text;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    /*if (!self.editCourse && indexPath.row != 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        StudentMO *student = [self.studentsArray objectAtIndex:indexPath.row-1];
        
        if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
            [self.addCourse addStudentsObject:student];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        } else {
            
            [self.addCourse removeStudentsObject:student];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }*/

    
}

@end
