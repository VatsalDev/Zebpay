//
//  ZebpayTestTests.m
//  ZebpayTestTests
//
//  Created by vatsal raval on 10/08/2017.
//  Copyright © 2017 vatsal raval. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "Music.h"

@interface ZebpayTestTests : XCTestCase
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSPersistentStore *store;
    Music *testMusic;
    UICollectionView *colView;
}
@end

@implementation ZebpayTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObjectModel];
    store = [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    
//
    managedObjectContext = [[NSManagedObjectContext alloc]init];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

//    let context = self.fetchedResultsController.managedObjectContext
//    let entity = self.fetchedResultsController.fetchRequest.entity!
//    let person = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! Person

    
//
//    dataProvider = PeopleListDataProvider()
//    dataProvider.managedObjectContext = managedObjectContext
//    
//    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PeopleListViewController") as! PeopleListViewController
//    viewController.dataProvider = dataProvider
//    
//    tableView = viewController.tableView
//    
//    testRecord = PersonInfo(firstName: "TestFirstName", lastName: "TestLastName", birthday: NSDate())
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    managedObjectContext = nil;
    
    NSError *error = nil;
    XCTAssert([persistentStoreCoordinator removePersistentStore:store error:&error],@"couldn't remove persistant store");
    
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

-(void) testThatStoreIsSetUp {
    XCTAssertNotNil(store, "no persitant store");
}

-(void)testInsertIntoCoreDataSuccess{
    testMusic = (Music *)[NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:managedObjectContext];

    testMusic.artistId = @"1";
    testMusic.artistName = @"ZebpayTest";
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error -> %@",error);
        abort();
    }
    
    XCTAssertTrue([managedObjectContext save:&error]);
}

-(void)testFetchFromCoreData{
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Music"];
    NSString *predicateString = [NSString stringWithFormat:@"artistId == %@",@"1"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetch setPredicate:predicate];
    
    XCTAssertTrue([[managedObjectContext executeFetchRequest:fetch error:nil] mutableCopy]);
}

-(void)testCaseFailFetchingFromWrongEntity{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Music1"];
    NSString *predicateString = [NSString stringWithFormat:@"artistId == %@",@"123"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    [fetch setPredicate:predicate];
    
    XCTAssertTrue([[managedObjectContext executeFetchRequest:fetch error:nil] mutableCopy]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
