//
//  WCMasterViewController.m
//  WCNavigationControllerExample
//
//  Created by Patrick Tescher on 9/13/12.
//
//

#import <QuartzCore/QuartzCore.h>

#import "WCMasterViewController.h"
#import "WCDetailViewController.h"
#import <WCNavigationController/WCNavigationController.h>
#import "WCPhysicsViewAnimation.h"
#import "math.h"

@interface WCMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation WCMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    NSNumber *damping = @14;
    NSNumber *stiffness = @190;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (WCDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    __block WCMasterViewController *masterViewController = self;

    [(WCNavigationController*)self.navigationController setPushAnimationBlock:^(UIViewController *sourceViewController, UIViewController *destinationViewController, WCViewControllerAnimationCompletionBlock completionBlock){
        self.navigationController.view.userInteractionEnabled = FALSE;
        UIView *superView = sourceViewController.view.superview;
        [superView addSubview:destinationViewController.view];
        [destinationViewController viewWillAppear:YES];
        destinationViewController.view.frame = sourceViewController.view.frame;
        WCPhysicsViewAnimation *incomingAnimation = [WCPhysicsViewAnimation animationFrom:CGRectApplyAffineTransform(destinationViewController.view.frame, CGAffineTransformMakeTranslation(320, 0)) to:destinationViewController.view.frame];
        incomingAnimation.damping = damping;
        incomingAnimation.stiffness = stiffness;
        WCPhysicsViewAnimation *outgoingAnimation = [WCPhysicsViewAnimation animationFrom:sourceViewController.view.frame to:CGRectApplyAffineTransform(sourceViewController.view.frame, CGAffineTransformMakeTranslation(-320, 0))];
        outgoingAnimation.damping = damping;
        outgoingAnimation.stiffness = stiffness;
        [sourceViewController.view.layer addAnimation:outgoingAnimation forKey:@"transition"];
        [destinationViewController.view.layer addAnimation:incomingAnimation forKey:@"transition"];
        [NSTimer scheduledTimerWithTimeInterval:outgoingAnimation.duration target:masterViewController selector:@selector(completionTimer:) userInfo:completionBlock repeats:NO];
    }];

//    [(WCNavigationController*)self.navigationController setPopAnimatiobBlock:^(UIViewController *sourceViewController, UIViewController *destinationViewController, WCViewControllerAnimationCompletionBlock completionBlock){
//        UIView *superView = sourceViewController.view.superview;
//        [superView addSubview:destinationViewController.view];
//        [destinationViewController.view setFrame:sourceViewController.view.frame];
//        [destinationViewController.view setTransform:CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0)];
//        [UIView animateWithDuration:0.3 animations:^{
//            [sourceViewController.view setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
//            [destinationViewController.view setTransform:CGAffineTransformIdentity];
//        } completion:^(BOOL finished){
//            completionBlock(finished);
//            [sourceViewController.view setTransform:CGAffineTransformIdentity];
//        }];
//    }];

    [(WCNavigationController*)self.navigationController setPopAnimatiobBlock:^(UIViewController *sourceViewController, UIViewController *destinationViewController, WCViewControllerAnimationCompletionBlock completionBlock){
        self.navigationController.view.userInteractionEnabled = FALSE;
        UIView *superView = sourceViewController.view.superview;
        [superView addSubview:destinationViewController.view];
        [destinationViewController.view setFrame:sourceViewController.view.frame];
        
        WCPhysicsViewAnimation *incomingAnimation = [WCPhysicsViewAnimation animationFrom:CGRectApplyAffineTransform(destinationViewController.view.frame, CGAffineTransformMakeTranslation(-320, 0)) to:destinationViewController.view.frame];
        incomingAnimation.damping = damping;
        incomingAnimation.stiffness = stiffness;
        WCPhysicsViewAnimation *outgoingAnimation = [WCPhysicsViewAnimation animationFrom:sourceViewController.view.frame to:CGRectApplyAffineTransform(sourceViewController.view.frame, CGAffineTransformMakeTranslation(320, 0))];
        outgoingAnimation.damping = damping;
        outgoingAnimation.stiffness = stiffness;
        [sourceViewController.view.layer addAnimation:outgoingAnimation forKey:@"transition"];
        [destinationViewController.view.layer addAnimation:incomingAnimation forKey:@"transition"];
        [NSTimer scheduledTimerWithTimeInterval:outgoingAnimation.duration target:masterViewController selector:@selector(completionTimer:) userInfo:completionBlock repeats:NO];
    }];

}

- (void)completionTimer:(NSTimer*)timer {
    WCViewControllerAnimationCompletionBlock completionBlock = timer.userInfo;
    self.navigationController.view.userInteractionEnabled = TRUE;
    completionBlock(YES);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}

@end