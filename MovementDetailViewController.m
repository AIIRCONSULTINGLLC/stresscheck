//
//  MovementDetailViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/6/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import "MovementDetailViewController.h"

@implementation MovementDetailViewController

@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize warningLabel = _warningLabel;
@synthesize lengthLabel = _lengthLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize previewImage = _previewImage;
@synthesize video = _video;
@synthesize scrollView = _scrollView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(id) initWithVideo:(Video *) video
{
	NSLog(@"setting titlelabel to %@", video.title);
	self.video = video;
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	self.titleLabel.text = self.video.title;
	self.descriptionLabel.text = self.video.description;
	self.warningLabel.text = self.video.warning;
	self.lengthLabel.text = self.video.mediaLength;
	self.categoryLabel.text = [self.video.mediaCategory uppercaseString];
	if([self.video.title isEqualToString:@"Headache"])
		self.descriptionLabel.frame = CGRectMake(12,230,296,94);
	self.previewImage.image = [UIImage imageNamed:self.video.thumbnailFilename];
	
	float padding = 2;
	float contentHeight = padding;
	
	CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.frame.size.width, 1000)];
	self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, contentHeight, self.titleLabel.frame.size.width, size.height);
	contentHeight += (size.height + padding);
	
	size = [self.previewImage sizeThatFits:CGSizeMake(self.previewImage.frame.size.width, 1000)];
	self.previewImage.frame = CGRectMake(self.previewImage.frame.origin.x, contentHeight, self.previewImage.frame.size.width, size.height);
	contentHeight += (size.height + padding);
	
	size = CGSizeMake(self.descriptionLabel.frame.size.width, 1000);
	size = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
	self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, contentHeight, self.descriptionLabel.frame.size.width, size.height);
	contentHeight += (size.height + padding);
	
	size = CGSizeMake(self.warningLabel.frame.size.width, 1000);
	size = [self.warningLabel.text sizeWithFont:self.warningLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
	self.warningLabel.frame = CGRectMake(self.warningLabel.frame.origin.x, contentHeight, self.warningLabel.frame.size.width, size.height);
	contentHeight += (size.height + padding);
	
	size = [self.categoryLabel sizeThatFits:CGSizeMake(self.categoryLabel.frame.size.width, 1000)];
	self.categoryLabel.frame = CGRectMake(self.categoryLabel.frame.origin.x, contentHeight, self.categoryLabel.frame.size.width, size.height);
	contentHeight += (size.height + padding);
	
	size = [self.lengthLabel sizeThatFits:CGSizeMake(self.lengthLabel.frame.size.width, 1000)];
	self.lengthLabel.frame = CGRectMake(self.lengthLabel.frame.origin.x, contentHeight, self.lengthLabel.frame.size.width, size.height);
	contentHeight += (size.height + padding);
	
	NSLog(@"new_size: %f %f  contentHeight: %f", size.width, size.height, contentHeight);
	self.scrollView.contentSize = CGSizeMake(320,contentHeight);
	
	[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
*/

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadOrientationDependentElements];
}
*/
 
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.titleLabel release];
	[self.descriptionLabel release];
	[self.warningLabel release];
	[self.lengthLabel release];
	[self.categoryLabel release];
	[self.previewImage release];
	[self.video release];
	[self.scrollView release];
    [super dealloc];
}

-(IBAction) playButtonPressed:(id) sender
{
//	MyViewController *myViewController = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:[NSBundle mainBundle]];
//	self.mViewController = myViewController;
//	[myViewController release];
//	[self.mViewController initMoviePlayerWithFilePath:self.video.videoPath withExtension:@"m4v"];
//	[self.mViewController playMovie:self]; 
	
	moviePlayer = [[[CustomMoviePlayerViewController alloc] initWithFilename:self.video.videoPath extension:@"m4v"] autorelease];
	[self presentModalViewController:moviePlayer animated:YES];
	[moviePlayer readyPlayer]; 
}

-(IBAction) backButtonTouch:(id) sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
