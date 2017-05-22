//
//  AddStudentViewController.m
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "AddStudentViewController.h"
#import "AddCourseViewController.h"
#import "PickCourseViewController.h"
#import "CoursesViewController.h"
#import "AddStudentViewCell.h"

#import "DataManager.h"
#import <CoreData/CoreData.h>

#import "StudentMO+CoreDataClass.h"
#import "CourseMO+CoreDataClass.h"


@interface AddStudentViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;

@property (strong, nonatomic) NSArray *coursesArray;

@end

@implementation AddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Add/edit a student";

    if (self.student) {
        self.coursesArray = [[DataManager sharedManager] getAllCoursesOfStudent:self.student];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
    if (self.student) {
        self.coursesArray = [[DataManager sharedManager] getAllCoursesOfStudent:self.student];
    } else {
        StudentMO *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
        self.student = student;
    }
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
        if (self.student) {
            return [self.student.courses count] + 1;
        } else {
            return [self.coursesArray count] + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        AddStudentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
                
            case 0:
                cell.nameLabel.text = @"First name";
                self.firstNameTextField = cell.textField;
                if (self.student) {
                    cell.textField.text = self.student.firstName;
                }
                break;
            case 1:
                cell.nameLabel.text = @"Last name";
                self.lastNameTextField = cell.textField;
                if (self.student) {
                    cell.textField.text = self.student.lastName;
                }
                break;
            case 2:
                cell.nameLabel.text = @"Email";
                self.emailTextField = cell.textField;
                if (self.student) {
                    cell.textField.text = self.student.email;
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
            
            cell.textLabel.text = @"Add courses";
            cell.textLabel.textColor = [UIColor redColor];
            
        } else {
            
            CourseMO *course = [self.coursesArray objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
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
            CourseMO *course = [self.coursesArray objectAtIndex:indexPath.row-1];
            [self.student removeCoursesObject:course];
            
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.coursesArray];
            [tempArray removeObject:course];
            self.coursesArray = tempArray;
            
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
        PickCourseViewController *vc = [[PickCourseViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.student = self.student;
        vc.studentFirstName = self.firstNameTextField.text;
        vc.studentLastName = self.lastNameTextField.text;
        vc.studentEmail = self.emailTextField.text;
        [self presentViewController:navVC animated:YES completion:nil];
        
    }
    
    if (indexPath.section == 1 && indexPath.row != 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        CourseMO *course = [self.coursesArray objectAtIndex:indexPath.row-1];
        
        AddCourseViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCourseViewController"];
        vc.course = course;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end
