//
//  TableViewController.m
//  TVListing3
//
//  Created by Avikant Saini on 12/29/14.
//  Copyright (c) 2014 avikantz. All rights reserved.
//

#import "ShowsTableViewController.h"
#import "TVShow.h"
#import "TableViewCell.h"
#import "topView2.h"

#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface ShowsTableViewController (){
	topView2 *topV;
	NSMutableArray *FullList;
	NSMutableArray *SearchResults;
	NSMutableArray *ShowList;
	BOOL isAlphabetical;
	
	CGFloat previousScrollViewYOffset;
}

@end

@implementation ShowsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.tabBarController.tabBar setBarTintColor:UIColorFromRGBWithAlpha(0x000000, 0.5)];
	[self.tabBarController.tabBar setTintColor:UIColorFromRGBWithAlpha(0x66ffcc, 1)];
	
	isAlphabetical = NO;
	
	NSString *filepath = [self documentsPathForFileName:[NSString stringWithFormat:@"FullList.json"]];
	if (![NSData dataWithContentsOfFile:filepath]) {
//		NSLog(@"Original Store");
		FullList = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"TVList" ofType:@"json"]] options:kNilOptions error:nil];
		[[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"TVList" ofType:@"json"]] writeToFile:filepath atomically:YES];
		[[NSUserDefaults standardUserDefaults] setObject:filepath forKey:@"DownloadedListPath"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		FullList = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filepath] options:kNilOptions error:nil];
//		NSLog(@"Documents Data");
	}
	
	ShowList = [[NSMutableArray alloc] init];
	
	for(int i=0; i<[FullList count]; ++i){
		// Add a 'TVShow: NSObject' object
		TVShow *show = [TVShow new];
		
		// Add Details to the object
		show.Title = [NSString stringWithFormat:@"%@", [[FullList objectAtIndex:i] objectForKey:@"Title"]];
		show.Detail = [NSString stringWithFormat:@"%@",[[FullList objectAtIndex:i] objectForKey:@"Detail"]];
		
		// Add the object to the 'ShowList' Array
		[ShowList addObject:show];
	}

	// Add the topView 'XIB' with the number of shows and images...
	topV = [[[NSBundle mainBundle] loadNibNamed:@"topView2" owner:self options:nil] objectAtIndex:0];
	[topV setFrame:CGRectMake(0, -(self.view.frame.size.height), self.view.frame.size.width, self.view.frame.size.height)];
	topV.topLabel.text = [NSString stringWithFormat:@"%li SHOWS", (long)[ShowList count]];
	[self.tableView addSubview:topV];
	
	[self.tableView reloadData];
	
	// Adding the bar button items...
	self.navigationItem.rightBarButtonItem = _EditButton;
	self.navigationItem.leftBarButtonItem = _AlphabeticalButton;
	self.navigationController.toolbarHidden = YES;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	[backButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]} forState:UIControlStateNormal];
	[self.navigationItem setBackBarButtonItem:backButton];
	[self.EditButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]} forState:UIControlStateNormal];
	[self.EditButton setTitle:@"EDIT"];
	[self.AlphabeticalButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]} forState:UIControlStateNormal];
	[self.AlphabeticalButton setTitle:@"A..Z"];
	
	
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]}];
	self.navigationItem.title = @"TV SHOWS";
		
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor blackColor];
	self.searchDisplayController.searchResultsTableView.backgroundView.backgroundColor = [UIColor blackColor];
	self.searchDisplayController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
	NSString *filepath = [self documentsPathForFileName:[NSString stringWithFormat:@"FullList.json"]];
	if (![NSData dataWithContentsOfFile:filepath]) {
		//		NSLog(@"Original Store");
		FullList = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"TVList" ofType:@"json"]] options:kNilOptions error:nil];
		[[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"TVList" ofType:@"json"]] writeToFile:filepath atomically:YES];
		[[NSUserDefaults standardUserDefaults] setObject:filepath forKey:@"DownloadedListPath"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		FullList = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filepath] options:kNilOptions error:nil];
		//		NSLog(@"Documents Data");
	}
	ShowList = [[NSMutableArray alloc] init];
	for(int i=0; i<[FullList count]; ++i){
		TVShow *show = [TVShow new];
		show.Title = [NSString stringWithFormat:@"%@", [[FullList objectAtIndex:i] objectForKey:@"Title"]];
		show.Detail = [NSString stringWithFormat:@"%@",[[FullList objectAtIndex:i] objectForKey:@"Detail"]];
		[ShowList addObject:show];
	}
	if (!isAlphabetical) {
		
	}
	else {
		NSArray *sortedArray = [ShowList sortedArrayUsingComparator:^(TVShow *a, TVShow *b) {
			return [a.Title caseInsensitiveCompare:b.Title];
		}];
		ShowList = [[NSMutableArray alloc] initWithArray:sortedArray];
	}
	[self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.EditButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]} forState:UIControlStateNormal];
	[self.AlphabeticalButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:20.0f]} forState:UIControlStateNormal];
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, 1), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:(20.f)]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search display results

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	NSPredicate *resultPredicate = [NSPredicate
									predicateWithFormat:@"Title contains[cd] %@",
									searchText];
	
	SearchResults = [[NSMutableArray alloc]initWithArray:[ShowList filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self filterContentForSearchText:searchString
							   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
									  objectAtIndex:[self.searchDisplayController.searchBar
													 selectedScopeButtonIndex]]];
	return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return [SearchResults count];
		
	else
		return [ShowList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCell *cell = (TableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CID"];
	
	// Configuring the cell
	if(cell == nil){
		cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CID"];
	}
	
	// Display the show information in the table cell
	TVShow *show = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		cell.titleLabel.numberOfLines = 1;
		show = [SearchResults objectAtIndex:indexPath.row];
		cell.titleLabel.text = [NSString stringWithFormat:@"%@", show.Title];
		cell.rankLabel.text = @"";
	}
	else {
		cell.titleLabel.numberOfLines = 2;
		show = [ShowList objectAtIndex:indexPath.row];
		cell.titleLabel.text = [NSString stringWithFormat:@"%@", show.Title];
		cell.rankLabel.text = [NSString stringWithFormat:@"#%li", (long)indexPath.row + 1];
	}
	
	cell.cellImage.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@.jpg", show.Title]];
	if (cell.cellImage.image == nil) {
		cell.cellImage.image = [UIImage imageNamed:@"TVIcon.png"];
	}
	cell.cellImage.clipsToBounds = YES;

	cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", show.Detail];
	
	cell.TO_BE_DOWNLOADED.hidden = YES;
	cell.TO_BE_ENCODED.hidden = YES;
	cell.CURRENTLY_FOLLOWING.hidden = YES;
	if ([show.Detail containsString:@"TO_BE_ENCODED"])
		cell.TO_BE_ENCODED.hidden = NO;
	if ([show.Detail containsString:@"TO_BE_DOWNLOADED"])
		cell.TO_BE_DOWNLOADED.hidden = NO;
	if ([show.Detail containsString:@"CURRENTLY_FOLLOWING"])
		cell.CURRENTLY_FOLLOWING.hidden = NO;
	
	// Customizing the cell for SwipeCellView Methods
	// Adding utitlity buttons
	
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SID"]) {
		NSIndexPath *indexPath = nil;
		TVShow *show = nil;
		
		if(self.searchDisplayController.active){
			indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
			show = [SearchResults objectAtIndex:indexPath.row];
		}
		else{
			indexPath = [self.tableView indexPathForSelectedRow];
			show = [ShowList objectAtIndex:indexPath.row];
		}
		
		DetailViewController *dvc = segue.destinationViewController;
		dvc.Show = show;
		dvc.data = FullList;
		dvc.hidesBottomBarWhenPushed = YES;
	}
}

#pragma mark - Deselect row at index path

// Deselection of a selected row at index path
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Edit Action

- (IBAction)EditAction:(id)sender {
	if (self.editing) {
		self.editing = NO;
		[_EditButton setTitle:@"EDIT"];
		[self.tableView reloadData];
	}
	else{
		self.editing = YES;
		[_EditButton setTitle:@"DONE"];
		[self.tableView reloadData];
	}
}

- (IBAction)AlphabeticalAction:(id)sender {
	if (isAlphabetical) {
		[_AlphabeticalButton setTitle:@"A...Z"];
		self.EditButton.enabled = YES;
		ShowList = [[NSMutableArray alloc] init];
		for(int i=0; i<[FullList count]; ++i){
			TVShow *show = [TVShow new];
			show.Title = [NSString stringWithFormat:@"%@", [[FullList objectAtIndex:i] objectForKey:@"Title"]];
			show.Detail = [NSString stringWithFormat:@"%@",[[FullList objectAtIndex:i] objectForKey:@"Detail"]];
			[ShowList addObject:show];
		}
		[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.tableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
			self.tableView.alpha = 0.5f;
		} completion:^(BOOL finished) {
			self.tableView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
			[self.tableView reloadData];
			[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.tableView.transform = CGAffineTransformIdentity;
				self.tableView.alpha = 1.f;
			} completion:nil];
		}];
	}
	else {
		[_AlphabeticalButton setTitle:@"RANKING"];
		self.EditButton.enabled = NO;
		NSArray *sortedArray = [ShowList sortedArrayUsingComparator:^(TVShow *a, TVShow *b) {
			return [a.Title caseInsensitiveCompare:b.Title];
		}];
		ShowList = [[NSMutableArray alloc] initWithArray:sortedArray];
		[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.tableView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
			self.tableView.alpha = 0.5f;
		} completion:^(BOOL finished) {
			self.tableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
			[self.tableView reloadData];
			[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.tableView.transform = CGAffineTransformIdentity;
				self.tableView.alpha = 1.f;
			} completion:nil];
		}];
	}
	isAlphabetical = !isAlphabetical;
}

-(void)writeToDocuments {
	NSData *data = [NSJSONSerialization dataWithJSONObject:FullList options:kNilOptions error:nil];
	NSString *filepath = [self documentsPathForFileName:[NSString stringWithFormat:@"FullList.json"]];
	[data writeToFile:filepath atomically:YES];
	[[NSUserDefaults standardUserDefaults] setObject:filepath forKey:@"DownloadedListPath"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//#pragma mark - Scroll View Delegates

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//	CGRect frame = self.navigationController.navigationBar.frame;
//	CGFloat size = frame.size.height - 21;
//	CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
//	CGFloat scrollOffset = scrollView.contentOffset.y;
//	CGFloat scrollDiff = scrollOffset - previousScrollViewYOffset;
//	CGFloat scrollHeight = scrollView.frame.size.height;
//	CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
//	
//	if (scrollOffset <= -scrollView.contentInset.top) {
//		frame.origin.y = 20;
//	} else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
//		frame.origin.y = -size;
//	} else {
//		frame.origin.y = MIN(20, MAX(-size, frame.origin.y - (frame.size.height * (scrollDiff / scrollHeight))));
//	}
//	
//	[self.navigationController.navigationBar setFrame:frame];
//	[self updateBarButtonItems:(1 - framePercentageHidden)];
//	previousScrollViewYOffset = scrollOffset;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//	[self stoppedScrolling];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//				  willDecelerate:(BOOL)decelerate
//{
//	if (!decelerate) {
//		[self stoppedScrolling];
//	}
//}
//
//- (void)stoppedScrolling {
//	CGRect frame = self.navigationController.navigationBar.frame;
//	if (frame.origin.y < 20) {
//		[self animateNavBarTo:-(frame.size.height - 21)];
//	}
//}
//
//- (void)updateBarButtonItems:(CGFloat)alpha {
//	[self.EditButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, alpha), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:alpha*20.0f]} forState:UIControlStateNormal];
//	[self.AlphabeticalButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, alpha), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:alpha*20.0f]} forState:UIControlStateNormal];
//	[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGBWithAlpha(0x66ffcc, alpha), NSFontAttributeName: [UIFont fontWithName:@"EtelkaNarrowTextPro" size:(alpha*20.f)]}];
//}
//
//- (void)animateNavBarTo:(CGFloat)y
//{
//	[UIView animateWithDuration:0.2 animations:^{
//		CGRect frame = self.navigationController.navigationBar.frame;
//		CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
//		frame.origin.y = y;
//		[self.navigationController.navigationBar setFrame:frame];
//		[self updateBarButtonItems:alpha];
//	}];
//}

#pragma mark - Tableview Editing Delegates

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
	TVShow *showObjectToMove = [ShowList objectAtIndex:sourceIndexPath.row];
	[ShowList removeObjectAtIndex:sourceIndexPath.row];
	[ShowList insertObject:showObjectToMove atIndex:destinationIndexPath.row];
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:FullList];
	NSDictionary *toMove = [array objectAtIndex:sourceIndexPath.row];
	[array removeObjectAtIndex:sourceIndexPath.row];
	[array insertObject:toMove atIndex:destinationIndexPath.row];
	FullList = array;
	
	[self writeToDocuments];
}

 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	 if (self.searchDisplayController.isActive || isAlphabetical){
		 return NO;
	 }
	 return YES;
 }

 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	 if (editingStyle == UITableViewCellEditingStyleDelete) {
		 // DO NOT DELETE FROM FULL LIST
		 [ShowList removeObjectAtIndex:indexPath.row];
		 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		 [self.tableView reloadData];
	 }
 }

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:name];
}

@end
