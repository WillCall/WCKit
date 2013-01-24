//
//  WCDetailViewController.m
//  WCNavigationControllerExample
//
//  Created by Patrick Tescher on 9/13/12.
//
//

#import "WCDetailViewController.h"
#import "WCPhysicsViewAnimation.h"
#import "UIView+Physics.h"

@interface WCDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation WCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height);
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height);
    self.image.originalFrame = self.image.frame;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Actions

- (IBAction)expand:(id)sender {
    self.navigationItem.rightBarButtonItem = self.hideButton;
    [self.image snapToAlternateFrame];
}

- (IBAction)hide:(id)sender {
    self.navigationItem.rightBarButtonItem = nil;
    [self.image snapToOriginalFrame];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
