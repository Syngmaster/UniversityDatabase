//
//  PickStudentViewController.h
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 21/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CourseMO;

@interface PickStudentViewController : UITableViewController

@property (strong, nonatomic) CourseMO *course;
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseSubject;
@property (strong, nonatomic) NSString *courseDepartment;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
