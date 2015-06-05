//
//  TableViewController.h
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface ShowsTableViewController : UITableViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AlphabeticalButton;

- (IBAction)EditAction:(id)sender;
- (IBAction)AlphabeticalAction:(id)sender;


@end
