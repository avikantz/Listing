//
//  TVShow.h
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVShow : NSObject

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Detail;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
