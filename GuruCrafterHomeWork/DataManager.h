//
//  DataManager.h
//  GuruCrafterHomeWork
//
//  Created by Syngmaster on 19/05/2017.
//  Copyright © 2017 Syngmaster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseMO;
@class StudentMO;

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (DataManager *)sharedManager;
- (void) addRandomStudent;

- (NSArray *)getAllStudentsInCourse:(CourseMO *) course;
- (NSArray *)getAllCoursesOfStudent:(StudentMO *) student;

@end
