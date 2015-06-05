//
//  TableViewCell.h
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (weak, nonatomic) IBOutlet UIImageView *TO_BE_ENCODED;
@property (weak, nonatomic) IBOutlet UIImageView *TO_BE_DOWNLOADED;
@property (weak, nonatomic) IBOutlet UIImageView *CURRENTLY_FOLLOWING;



@end
