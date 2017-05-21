//
//  AddStudentViewController.h
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class StudentMO;

@interface AddStudentViewController : UIViewController

@property (strong, nonatomic) StudentMO *student;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

- (IBAction)dismissAction:(UIButton *)sender;
- (IBAction)pickCourseAction:(UIButton *)sender;

@end
