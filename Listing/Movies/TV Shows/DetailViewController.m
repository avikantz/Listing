//
//  DetailViewController.m
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import "DetailViewController.h"
#import "TVShow.h"

#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface DetailViewController ()

@end

@implementation DetailViewController {
	BOOL isEditing;
}

-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:(20.f)]}];
	[_editButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]} forState:UIControlStateNormal];
//	[self setTabBarVisible:NO animated:YES];
//	[self.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
//	[self setTabBarVisible:YES animated:YES];
//	[self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = [self.Show.Title uppercaseString];
	
	isEditing = NO;
	
	[_editButton setTitle:@"EDIT"];
	
	self.navigationItem.rightBarButtonItem = _editButton;
	
	self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.Show.Title]];
	
	if (self.imageView.image == nil) {
		self.imageView.image = [UIImage imageNamed:@"TVIcon.png"];
	}
	
	_DetailLabel.text = [self.Show.Detail stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ - ", self.Show.Title] withString:@""];
	_DetailLabel.keyboardAppearance = UIKeyboardAppearanceDark;
	
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editAction:(id)sender {
	if (isEditing) {
		_DetailLabel.contentInset = UIEdgeInsetsMake(25, 0, 25, 0);
		[_editButton setTitle:@"EDIT"];
		_DetailLabel.editable = NO;
		[_DetailLabel resignFirstResponder];
		
		NSMutableArray *NewFullList = [[NSMutableArray alloc] init];
		for (int i = 0; i<[_data count]; ++i) {
			NSMutableDictionary *Show = [[NSMutableDictionary alloc] init];
			if ([[[_data objectAtIndex:i] objectForKey:@"Title"] isEqualToString:self.Show.Title]) {
				Show = [NSMutableDictionary dictionaryWithDictionary:@{
						 @"Title": self.Show.Title,
						 @"Detail": self.DetailLabel.text
						 }];
			}
			else
				Show = [_data objectAtIndex:i];
			[NewFullList addObject:Show];
		}
		
		NSData *data = [NSJSONSerialization dataWithJSONObject:NewFullList options:kNilOptions error:nil];
		NSString *filepath = [self documentsPathForFileName:[NSString stringWithFormat:@"FullList.json"]];
		[data writeToFile:filepath atomically:YES];
	}
	else {
		_DetailLabel.contentInset = UIEdgeInsetsMake(0, 0, 180, 0);
		[_editButton setTitle:@"DONE"];
		_DetailLabel.editable = YES;
		[_DetailLabel becomeFirstResponder];
	}
	isEditing = !isEditing;
}

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
}

#pragma mark - Tab Bar Hiding Animation

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
	if ([self tabBarIsVisible] == visible)
		return;
	CGRect frame = self.tabBarController.tabBar.frame;
	CGFloat height = frame.size.height;
	CGFloat offsetY = (visible)? -height : height;
	CGFloat duration = (animated)? 0.3 : 0.0;
	[UIView animateWithDuration:duration animations:^{
		self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
	}];
}

- (BOOL)tabBarIsVisible {
	return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

@end
