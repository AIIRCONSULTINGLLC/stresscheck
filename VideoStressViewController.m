//
//  VideoStressViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright AVAI 2009. All rights reserved.
//

#import "VideoStressViewController.h"

NSString* meditationId = @"com.kirschner.stresscheck.meditation";
NSString* movementId = @"com.kirschner.stresscheck.movement";

@implementation VideoStressViewController

@synthesize videos = _videos;
@synthesize videoCell;
@synthesize videoTable;
@synthesize currentMediaType = _currentMediaType;
@synthesize progressView = _progressView;
@synthesize statusMessage = _statusMessage;
@synthesize buyButton = _buyButton;
@synthesize restoreButton = _restoreButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize iapView = _iapView;
@synthesize transaction = _transaction;
@synthesize backgroundImage = _backgroundImage;
@synthesize titleLabel;

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
	NSLog(@"viewDidAppear - loading %@", self.tabBarController.selectedViewController.title);
	self.statusMessage.hidden = YES;
	self.progressView.hidden = YES;
	self.activityIndicator.hidden = YES;
	
	if([self.tabBarController.selectedViewController.title isEqualToString:@"Mind"]) {
		[self.titleLabel setText:@"Meditations"];
	} else {
		[self.titleLabel setText:@"Office Yoga"];
	}
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	if([userDefaults boolForKey:self.tabBarController.selectedViewController.title])
	{
		[self.iapView removeFromSuperview];
	}
	
	self.videoTable.delegate = self;
	self.videoTable.dataSource = self;
	self.videoTable.allowsSelection = YES;
	
	self.view.backgroundColor = [UIColor clearColor];
	NSString *imageName = [NSString stringWithFormat:@"OH_%@_splash.png", self.tabBarController.selectedViewController.title];
	
	self.backgroundImage.image = [UIImage imageNamed:imageName];
	NSString *buyButtonImageName = [NSString stringWithFormat:@"OH_butt_download_%@.png", self.tabBarController.selectedViewController.title];
	[self.buyButton setImage:[UIImage imageNamed:buyButtonImageName] forState:UIControlStateNormal];
    NSString *restoreButtonImageName = [NSString stringWithFormat:@"OH_butt_restore_%@.png", self.tabBarController.selectedViewController.title];
    [self.restoreButton setImage:[UIImage imageNamed:restoreButtonImageName] forState:UIControlStateNormal];
    
    CGRect buyButtonFrame = self.buyButton.frame;
    buyButtonFrame.origin.x = (self.view.frame.size.width - (buyButtonFrame.size.width*2+10)) / 2.0;
    self.buyButton.frame = buyButtonFrame;
    CGRect restoreButtonFrame = self.restoreButton.frame;
    restoreButtonFrame.origin.x = buyButtonFrame.origin.x+buyButtonFrame.size.width+10;
    self.restoreButton.frame = restoreButtonFrame;

    if([self.tabBarController.selectedViewController.title isEqualToString:@"Mind"]) {
        /*CGRect buyButtonFrame = self.buyButton.frame;
        buyButtonFrame.origin.x = (self.view.frame.size.width - (buyButtonFrame.size.width*2+10)) / 2.0;
        self.buyButton.frame = buyButtonFrame;
        CGRect restoreButtonFrame = self.restoreButton.frame;
        restoreButtonFrame.origin.x = buyButtonFrame.origin.x+buyButtonFrame.size.width+10;
        self.restoreButton.frame = restoreButtonFrame;*/
    }
    else
    {
        CGRect buyButtonFrame = self.buyButton.frame;
        buyButtonFrame.origin.y = 320;
        self.buyButton.frame = buyButtonFrame;
        CGRect restoreButtonFrame = self.restoreButton.frame;
        restoreButtonFrame.origin.y = 320;
        self.restoreButton.frame = restoreButtonFrame;
    }
	self.navigationController.delegate = self;
	
	self.currentMediaType = self.tabBarController.selectedViewController.title;
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
    [query release];
    
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)viewDidLayoutSubviews
{

    _iapView.frame = self.view.bounds;
    videoTable.frame = CGRectMake(0, self.metalBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.metalBar.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
	NSLog(@"didReceiveMemoryWarning");

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

}

- (IBAction) buyButtonTouch:(id)sender {	
	if([[Reachability reachabilityForInternetConnection] isReachable]) {
		//If iapDownloadInProgress flag is true, don't start a second IAP download.
		OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
		if(mainDelegate.iapDownloadInProgress) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download in progress" message:@"Please wait until your first purchase has finished downloading." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		else
		{	
			//Set iapDownloadInProgress flag so that we don't have more than one IAP download at once.
			mainDelegate.iapDownloadInProgress = YES;
			//Remove buy button, update status.
			[self downloadStatus:@"Processing purchase..." progress: -1.0];
			[MKStoreManager sharedManager].delegate = self;
			if([self.tabBarController.selectedViewController.title isEqualToString:@"Mind"])
				[[MKStoreManager sharedManager] buyFeature:meditationId];
			else
				[[MKStoreManager sharedManager] buyFeature:movementId];
		}
	} else {	
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kNoConnectivityErrorTitle message:kNoConnectivityErrorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)restoreButtonTouch:(id)sender {
    if([[Reachability reachabilityForInternetConnection] isReachable]) {
        //If iapDownloadInProgress flag is true, don't start a second IAP download.
        OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
        if(mainDelegate.iapDownloadInProgress) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download in progress" message:@"Please wait until your first purchase has finished downloading." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            //Set iapDownloadInProgress flag so that we don't have more than one IAP download at once.
            mainDelegate.iapDownloadInProgress = YES;
            //Remove buy button, update status.
            [self downloadStatus:@"Restoring purchase..." progress: -1.0];
            [MKStoreManager sharedManager].delegate = self;
            if([self.tabBarController.selectedViewController.title isEqualToString:@"Mind"])
                mainDelegate.restoreTarget = meditationId;
            else
                mainDelegate.restoreTarget = movementId;
            [[MKStoreManager sharedManager] restoreAllPurchases];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kNoConnectivityErrorTitle message:kNoConnectivityErrorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)downloadStatus:(NSString *)status progress:(float)progress
{
	NSLog(@"downloadStatus: %@, progress, %f", status, progress);
	self.buyButton.hidden = YES;
    self.restoreButton.hidden = YES;
	self.statusMessage.hidden = NO;
	self.statusMessage.text = status;
	if([status isEqualToString:@"Installation Complete."])
	{
		[self revealContent];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	else if([status isEqualToString:@"Failed"])
	{
		self.activityIndicator.hidden = YES;
		self.progressView.hidden = YES;
		self.statusMessage.hidden = YES;
		self.buyButton.hidden = NO;
        self.restoreButton.hidden = NO;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		// Update the iapDownloadInProgress flag to indicate that the download was cancelled.
		OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
		mainDelegate.iapDownloadInProgress = NO;
	}
	else if(progress == -1.0)
	{
		NSLog(@"hiding progressView and showing activityIndicator");
		self.activityIndicator.hidden = NO;
		self.progressView.hidden = YES;
		NSLog(@"hid progressView and show'd activityIndicator");
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	} else {
		self.activityIndicator.hidden = YES;
		self.progressView.hidden = NO;
		self.progressView.progress = progress;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
}

-(void) revealContent {
	//Reveal content
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:self.tabBarController.selectedViewController.title];
	[self.iapView removeFromSuperview];
}

- (void)dealloc {
	self.videoCell = nil;
	self.videoTable = nil;
	[self.currentMediaType release];
	[self.progressView release];
	[self.statusMessage release];
	[self.buyButton release];
	[self.activityIndicator release];
	[self.iapView release];
	[self.transaction release];
	[self.backgroundImage release];
	[self.titleLabel release];
    [_metalBar release];
    [_restoreButton release];
    [super dealloc];
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
			
			if ([firstObject isKindOfClass:[UITableViewCell class]]){
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
		
		return cell;
	}
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView reloadData];
	Video *temp = [self.videos objectAtIndex:indexPath.row];
	if([self.currentMediaType isEqualToString:@"Mind"]) {
		moviePlayer = [[[CustomMoviePlayerViewController alloc] initWithFilename:temp.videoPath extension:@"m4v"] autorelease];
		[self presentModalViewController:moviePlayer animated:YES];
		[moviePlayer readyPlayer];    
	} else {
		MovementDetailViewController *movementDetail = [[MovementDetailViewController alloc] initWithVideo:temp];
		[self.navigationController pushViewController:movementDetail animated:YES];
		[movementDetail release];
	}
}


@end

