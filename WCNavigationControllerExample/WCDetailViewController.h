//
//  WCDetailViewController.h
//  WCNavigationControllerExample
//
//  Created by Patrick Tescher on 9/13/12.
//
//

#import <UIKit/UIKit.h>

@interface WCDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (nonatomic) BOOL imageIsFullscreen;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *hideButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
