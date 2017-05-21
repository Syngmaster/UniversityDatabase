//
//  AddStudentViewController.m
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "AddStudentViewController.h"
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "StudentMO+CoreDataClass.h"
#import "CoursesViewController.h"
#import "PickCourseViewController.h"


@interface AddStudentViewController () <UITextFieldDelegate>

@end

@implementation AddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.student) {
        self.firstNameTextField.text = self.student.firstName;
        self.lastNameTextField.text = self.student.lastName;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[DataManager sharedManager] persistentContainer].viewContext;
    }
    return _managedObjectContext;
}

- (IBAction)dismissAction:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)pickCourseAction:(UIButton *)sender {
    
    PickCourseViewController *vc = [[PickCourseViewController alloc] initWithStyle:UITableViewStylePlain];
    
    if (!self.student) {
    
        vc.studentFirstName = self.firstNameTextField.text;
        vc.studentLastName = self.lastNameTextField.text;
        
    } else {
        
        vc.student = self.student;
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameTextField]) {
        
        [self.lastNameTextField becomeFirstResponder];
    }
    
    if ([textField isEqual:self.lastNameTextField]) {
        
        [textField resignFirstResponder];
    }

    return YES;
}

@end
