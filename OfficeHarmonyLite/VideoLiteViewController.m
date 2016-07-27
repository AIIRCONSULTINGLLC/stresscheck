//
//  VideoViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright AVAI 2009. All rights reserved.
//

#import "VideoLiteViewController.h"

@implementation VideoLiteViewController

@synthesize videos = _videos;
@synthesize mViewController;
@synthesize videoCell;
@synthesize videoTable;
@synthesize currentMediaType = _currentMediaType;
@synthesize imageView = _imageView;
@synthesize playButton = _playButton;

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
	self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];	
	if (self != nil) {
	}
		
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
	NSLog(@"viewDidAppear");
	NSLog([@"loading " stringByAppendingString:self.tabBarController.selectedViewController.title]);
	self.navigationController.delegate = self;
	self.currentMediaType = self.tabBarController.selectedViewController.title;
	if([self.currentMediaType isEqualToString:@"Movement"])
	{
		self.imageView.image = [UIImage imageNamed:@"OH_bulls_and_bears.png"];
		[self.playButton setImage:[UIImage imageNamed:@"OH_butt_movement_play.png"] forState:UIControlStateNormal];
	}
	else
	{
		self.imageView.image = [UIImage imageNamed:@"OH_meadow_stroll.png"];
		[self.playButton setImage:[UIImage imageNamed:@"OH_butt_mind_play.png"] forState:UIControlStateNormal];
	}
	self.videoTable.separatorColor = [UIColor whiteColor];
	self.videos  = [[NSMutableArray alloc] init];
	
	NSString *sql = @"SELECT title, description, thumbnailFilename, mediaFilename, mediaLength, mediaCategory, warning FROM Media ";
	sql = [sql stringByAppendingString:@"JOIN MediaType ON MediaType.id = Media.mediaTypeId WHERE MediaType.name=\""];
	sql = [sql stringByAppendingString:self.currentMediaType];
	sql = [sql stringByAppendingString:@"\" AND Media.liteversion=1"];
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

-(IBAction) watchButtonTouch:(id)sender
{
	Video *temp = [[Video alloc] init];
	temp = [self.videos objectAtIndex:0];
	
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
    [self.playButton release];
	[self.imageView release];
	[super dealloc];
}

@end

