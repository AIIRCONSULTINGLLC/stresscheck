//
//  DetailResponseViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailedResponseViewController.h"
#import "QuizRecord.h"
#import "AdManager.h"

@implementation DetailedResponseViewController

@synthesize scrollView;
@synthesize OHAdButton;
@synthesize bottomBannerView;
@synthesize bannerView;
@synthesize quizRecord;
@synthesize restartButton;
@synthesize backButton;

- (void)dealloc {
	[self.scrollView release];
	[self.OHAdButton release];
	[self.bottomBannerView release];
	[self.bannerView release];
	[self.quizRecord release];
	[self.restartButton release];
	[self.backButton release];
    [super dealloc];
}

- (id)initWithQuizRecord:(QuizRecord *)record {
    if ((self = [super initWithNibName:@"DetailedResponseViewController" bundle:[NSBundle mainBundle]])) {
        self.quizRecord = record;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	UIImage *backButtonImage = [[UIImage imageNamed:@"button_gray_back.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:15];
	[self.backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];

	UIImage *buttonImage = [[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15];
	[self.restartButton setBackgroundImage:buttonImage forState:UIControlStateNormal];	
	
#ifdef STRESS_CHECK
	//Add button that links to Office Harmony app.
//	[self.OHAdButton setHidden:NO];
//	[self.bannerView setImage:[UIImage imageNamed:@"OH_navbar_head_stress.png"]];

    
/*
    // cuiping cui marked the next line
    [self.bottomBannerView setHidden:NO];
	UIView *adBannerView = [[AdManager sharedManager] currentAdBannerView];
	[self.view addSubview:adBannerView];
*/
	
	//Shrink scroll view
	CGRect scrollFrame = self.scrollView.frame;
	scrollFrame.size.height -= 50.0;
	self.scrollView.frame = scrollFrame;
#endif
	
	
	// Add the graph
	CGRect detailFrame = CGRectMake(20, 20, 280, 230);
	DetailedResponseGraphView *detailView = [[DetailedResponseGraphView alloc] initWithFrame:detailFrame quizRecord:self.quizRecord];
	[self.scrollView addSubview:detailView];

	//Add response label
	UILabel *responseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	responseLabel.text = [self.quizRecord domainResponseText];
	responseLabel.numberOfLines = 0;
	responseLabel.font = [UIFont fontWithName:@"Arial" size:16];
	responseLabel.textAlignment = UITextAlignmentLeft;
	responseLabel.backgroundColor = [UIColor clearColor];
	responseLabel.textColor = [UIColor OHDarkPurple];
	CGFloat padding = 10.0;
	CGSize size = [responseLabel sizeThatFits:CGSizeMake(320 - 2 * padding, 10000)];
	CGRect responseFrame;
	responseFrame.size = size;
	responseFrame.origin.x = padding;
	responseFrame.origin.y = detailView.frame.origin.y + detailView.frame.size.height + padding;
	responseLabel.frame = responseFrame;
	[self.scrollView addSubview:responseLabel];
	self.scrollView.contentSize = CGSizeMake(320, responseLabel.frame.origin.y + responseLabel.frame.size.height + padding);
	[responseLabel release];
    [detailView release];
}

- (void)viewDidLayoutSubviews
{
    scrollView.frame = CGRectMake(0, bottomBannerView.bounds.size.height, scrollView.bounds.size.width, scrollView.bounds.size.height);
}

-(IBAction) bannerButtonTouch:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=329954203&mt=8"]];
}

-(IBAction) generalResponseButtonTouch:(id) sender {
	NSLog(@"generalResponseButtonTouch");
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) restartButtonTouch:(id)sender {
	//Reset all the previously selected choices
	NSString *sql = [NSString stringWithFormat:@"UPDATE Questions SET questionState=0"];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	while([query nextRecord] != nil);
	[query release];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end


