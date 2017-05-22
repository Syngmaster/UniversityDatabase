//
//  AddCourseViewController.h
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CourseMO;

@interface AddCourseViewController : UITableViewController

@property (strong, nonatomic) CourseMO *course;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
