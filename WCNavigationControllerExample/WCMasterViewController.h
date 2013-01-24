//
//  WCMasterViewController.h
//  WCNavigationControllerExample
//
//  Created by Patrick Tescher on 9/13/12.
//
//

#import <UIKit/UIKit.h>

@class WCDetailViewController;

#import <CoreData/CoreData.h>

@interface WCMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) WCDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
