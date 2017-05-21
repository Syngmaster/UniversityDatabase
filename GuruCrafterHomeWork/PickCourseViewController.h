//
//  PickCourseViewController.h
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 20/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "MainTableViewController.h"
#import <CoreData/CoreData.h>

@class StudentMO;

@interface PickCourseViewController : UITableViewController 

@property (strong, nonatomic) StudentMO *student;
@property (strong, nonatomic) NSString *studentFirstName;
@property (strong, nonatomic) NSString *studentLastName;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
