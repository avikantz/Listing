//
//  TVShow.m
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import "TVShow.h"

@implementation TVShow

- (void)encodeWithCoder:(NSCoder *)encoder {
	//Encode properties, other class variables, etc
	[encoder encodeObject:self.Title forKey:@"Title"];
	[encoder encodeObject:self.Detail forKey:@"Detail"];
}
	   
- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if( self != nil ) {
		//decode properties, other class vars
		self.Title = [decoder decodeObjectForKey:@"Title"];
		self.Detail = [decoder decodeObjectForKey:@"Detail"];
	}
	return self;
}

@end
