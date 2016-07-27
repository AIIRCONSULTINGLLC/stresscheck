//
//  VideoViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright AVAI 2009. All rights reserved.
//

#import "VideoViewController.h"

@implementation VideoViewController

@synthesize videos = _videos;
@synthesize mViewController;
@synthesize videoCell;
@synthesize videoTable;
@synthesize currentMediaType = _currentMediaType;

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
	self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];	
	if (self != nil) {
	}
		
	return self;
}

-(void)navigationController:(UINavigationController *)aNavigationController willShowViewController:(UIViewController *) aViewController animated:(BOOL) animated
{
	//if(aViewController == self)
	//{
	//	self.title = @"";
	//}
}


- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
	NSLog(@"viewDidAppear");
	NSLog([@"loading " stringByAppendingString:self.tabBarController.selectedViewController.title]);
	//self.videoTable.backgroundColor = [UIColor clearColor];
	self.videoTable.delegate = self;
	self.videoTable.dataSource = self;
	self.videoTable.allowsSelection = YES;
	
	self.view.backgroundColor = [UIColor clearColor];
	
	self.navigationController.delegate = self;
	
	self.currentMediaType = self.tabBarController.selectedViewController.title;
	if([self.currentMediaType isEqualToString:@"Movement"])
		self.videoTable.rowHeight = 92;
	else
		self.videoTable.rowHeight = 92;
	self.videoTable.separatorColor = [UIColor whiteColor];
	self.videos  = [[NSMutableArray alloc] init];
	
	NSString *sql = @"SELECT title, description, thumbnailFilename, mediaFilename, mediaLength, mediaCategory, warning FROM Media ";
	sql = [sql stringByAppendingString:@"JOIN MediaType ON MediaType.id = Media.mediaTypeId WHERE MediaType.name=\""];
	sql = [sql stringByAppendingString:self.currentMediaType];
	sql = [sql stringByAppendingString:@"\""];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil)
	{
		Video *video = [[Video alloc] init];
		video.title = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 0)];
		video.description = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 1)];
		video.thumbnailFilename = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 2)];
		video.videoPath = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 3)];
		video.mediaLength = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 4)];
		video.mediaCategory = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 5)];
		char *warning = (char *)sqlite3_column_text(sqlStatement, 6);
		if(warning != nil) {
			video.warning = [[NSString alloc] initWithCString:(char *)warning];
		}
		else {
			video.warning = @"";
		}
		video.mediaType = self.currentMediaType;
		[self.videos addObject:video];
		[video release];
	}
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	NSLog(@"didReceiveMemoryWarning");

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	[self.mViewController release];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	NSLog(@"viewDidUnload");
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
	[self.mViewController release];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Number of rows in section");
	return [self.videos count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Video *temp = [self.videos objectAtIndex:indexPath.row];
	if([self.currentMediaType isEqualToString:@"Mind"])
	{
		MindCell *cell = (MindCell *)[tableView dequeueReusableCellWithIdentifier:@"MyMindCell"];
		if (cell == nil)
		{
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MindCell" owner:self options:nil];
			id firstObject = [topLevelObjects objectAtIndex:0];
			
			if([firstObject isKindOfClass:[UITableViewCell class]]){
				cell = (MindCell *) firstObject;
			}
			else cell = [topLevelObjects objectAtIndex:1];
		}
		cell.titleLabel.text = [temp title];
		cell.descriptionLabel.text = [temp description];
		cell.lengthLabel.text = [temp mediaLength];
		cell.thumbnailImageView.image = [UIImage imageNamed:[temp thumbnailFilename]];
		return cell;
	}
	else
	{
		MovementCell *cell = (MovementCell *)[tableView dequeueReusableCellWithIdentifier:@"MyMovementCell"];
		if (cell == nil)
		{
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MovementCell" owner:self options:nil];
			id firstObject = [topLevelObjects objectAtIndex:0];
			if ( [ firstObject isKindOfClass:[UITableViewCell class]] ){
				cell = (MovementCell *) firstObject;
			}
			else cell = [topLevelObjects objectAtIndex:1];
		}
		[cell setSelected:NO animated:NO];
		cell.titleLabel.text = [temp title];
		if([temp mediaLength] != nil)
			cell.lengthLabel.text = [temp mediaLength];
		if([temp mediaCategory] != nil)
			cell.categoryLabel.text = [[temp mediaCategory] uppercaseString];
		if([temp thumbnailFilename] != nil)
		{
			NSString *thumbnailName = [@"OH_thumb_" stringByAppendingString:[temp thumbnailFilename]];
			NSLog(@"thumbnailName:%@", thumbnailName);
			cell.thumbnailImageView.image = [UIImage imageNamed:thumbnailName];
		}
		if([temp description] != nil)
			cell.descriptionLabel.text = [temp description];
		
		//cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		return cell;
	}
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"didSelectRowAtIndexPath");
	
	[tableView reloadData];
	
	Video *temp = [[Video alloc] init];
	temp = [self.videos objectAtIndex:indexPath.row];
	
	if([self.currentMediaType isEqualToString:@"Mind"])
	{
		MyViewController *myViewController = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:[NSBundle mainBundle]];
		self.mViewController = myViewController;
		[myViewController release];
		[self.mViewController initMoviePlayerWithFilePath:temp.videoPath withExtension:@"m4v"];
		[self.mViewController playMovie:self]; 
	}
	else
	{
		MovementDetailViewController *movementDetail = [[MovementDetailViewController alloc] initWithVideo:temp];
		[self.navigationController pushViewController:movementDetail animated:YES];
		[movementDetail release];
	}
}

- (void)dealloc {
	self.mViewController = nil;
	self.videoCell = nil;
	self.videoTable = nil;
	[self.currentMediaType release];
    [super dealloc];
}


@end

