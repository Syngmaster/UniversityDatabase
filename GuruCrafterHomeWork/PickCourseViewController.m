//
//  PickCourseViewController.m
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 20/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import "PickCourseViewController.h"
#import "CourseMO+CoreDataClass.h"
#import "DataManager.h"
#import "StudentMO+CoreDataClass.h"

@interface PickCourseViewController ()

@end

@implementation PickCourseViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Pick a Course";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;

    self.student.firstName = self.studentFirstName;
    self.student.lastName = self.studentLastName;
    self.student.email = self.studentEmail;

}

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[DataManager sharedManager] persistentContainer].viewContext;
    }
    return _managedObjectContext;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"Course"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* courseDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[courseDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Action

- (void)doneAction:(UIBarButtonItem *) sender {

    [self.managedObjectContext save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    CourseMO *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
        for (CourseMO *obj in self.student.courses) {
            
            if ([obj.name isEqualToString:course.name]) {
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CourseMO *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
        
        [course addStudentsObject:self.student];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
    } else {
            
        [course removeStudentsObject:self.student];
        cell.accessoryType = UITableViewCellAccessoryNone;
            
    }

}

@end
