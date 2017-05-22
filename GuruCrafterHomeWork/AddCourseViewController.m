//
//  AddCourseViewController.m
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "AddCourseViewController.h"
#import "AddStudentViewController.h"
#import "PickStudentViewController.h"
#import "AddCourseViewCell.h"

#import "DataManager.h"

#import "CourseMO+CoreDataClass.h"
#import "StudentMO+CoreDataClass.h"


@interface AddCourseViewController ()

@property (strong, nonatomic) UITextField *courseTextField;
@property (strong, nonatomic) UITextField *subjectTextField;
@property (strong, nonatomic) UITextField *departmentTextField;

@property (strong, nonatomic) NSArray *studentsArray;
@property (strong, nonatomic) NSMutableArray *lecturerArray;

@end

@implementation AddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    if (self.course) {
        self.studentsArray = [[DataManager sharedManager] getAllStudentsInCourse:self.course];
    } 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
    if (self.course) {
        self.studentsArray = [[DataManager sharedManager] getAllStudentsInCourse:self.course];
    } else {
        CourseMO *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
        self.course = course;
    }
}


#pragma mark - Action

- (void)saveAction:(UIBarButtonItem *) sender {

    self.course.name = self.courseTextField.text;
    self.course.subject = self.subjectTextField.text;
    self.course.department = self.departmentTextField.text;

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
        return 3;
    } else {
        if (self.course) {
            return [self.course.students count] + 1;
        } else {
            return [self.studentsArray count] + 1;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        AddCourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
                
            case 0:
                cell.nameLabel.text = @"Course name";
                self.courseTextField = cell.textField;
                if (self.course) {
                    cell.textField.text = self.course.name;
                }
                break;
                    
            case 1:
                cell.nameLabel.text = @"Subject";
                self.subjectTextField = cell.textField;
                if (self.course) {
                    cell.textField.text = self.course.subject;
                }
                break;
                    
            case 2:
                cell.nameLabel.text = @"Department";
                self.departmentTextField = cell.textField;
                if (self.course) {
                    cell.textField.text = self.course.department;
                }
                break;

        }
        
        return cell;

    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Add students";
            cell.textLabel.textColor = [UIColor redColor];
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
            [self.course removeStudentsObject:student];

            
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
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.course = self.course;
        vc.courseName = self.courseTextField.text;
        vc.courseSubject = self.subjectTextField.text;
        vc.courseDepartment = self.departmentTextField.text;
        
        [self presentViewController:navVC animated:YES completion:nil];
        
    }
    
    if (indexPath.section == 1 && indexPath.row != 0) {

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        StudentMO *student = [self.studentsArray objectAtIndex:indexPath.row-1];

        AddStudentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddStudentViewController"];
        vc.student = student;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end
