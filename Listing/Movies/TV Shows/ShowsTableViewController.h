//
//  TableViewController.h
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "UICustomActionSheet.h"

@interface ShowsTableViewController : UITableViewController <UIScrollViewDelegate, UIActionSheetDelegate, UICustomActionSheetDelegate>

typedef NS_ENUM(NSInteger, SortOrder) {
	SortOrder_RANKING = 0,
	SortOrder_ALPHABETICAL = 1,
	SortOrder_CURRENTLY_FOLLOWING = 2,
	SortOrder_TO_BE_DOWNLOADED = 3,
	SortOrder_TO_BE_ENCODED = 4,
	SortOrder_EPISODE_COUNT = 5,
	SortOrder_SIZE = 6,
};

@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *followingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tbdButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;


- (IBAction)followingAction:(id)sender;
- (IBAction)tbdAction:(id)sender;

- (IBAction)sortAction:(id)sender;

- (IBAction)EditAction:(id)sender;



@end
