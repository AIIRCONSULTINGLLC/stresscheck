//
//  GeneralResponseViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GeneralResponseViewController.h"
#import "ResponseHistoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AdManager.h"
@implementation GeneralResponseViewController

@synthesize navBar;
@synthesize responseView;
@synthesize yourScoreIsLabel;
@synthesize responseLabel;
@synthesize quizRecord; 
@synthesize restartButton;

- (void)dealloc {
	[self.navBar release];
	[self.responseView release];
	[self.yourScoreIsLabel release];
	[self.responseLabel release];
	[self.quizRecord release];
	[self.restartButton release];
    [super dealloc];
}

- (id)init {
    if ((self = [super initWithNibName:@"GeneralResponseViewController" bundle:[NSBundle mainBundle]])) {		

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.quizRecord = [[QuizRecord alloc] initWithCurrentQuiz];		
	[self.quizRecord saveToHistory];
	
	if(kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iPhoneOS_3_2) {
		// Setup local notification
		[[UIApplication sharedApplication] cancelAllLocalNotifications];	
		
		double lapseTimeForNotification = 60 * 60 * 24 * 60;
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		[localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:lapseTimeForNotification]];
		[localNotification setAlertBody:@"It has been 2 months since you last measured your stress levels. Please take the Stress Check assessment to monitor your stress over time."];
		[localNotification setAlertAction:@"Take Now"];
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
		[localNotification release];
	}
	
	UIImage *stretchableButtonImageNormal = [[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15];
	[self.restartButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];		

#ifdef STRESS_CHECK	
	self.navBar.image = [UIImage imageNamed:@"OH_navbar_head_stress.png"];

/*
    // cuiping cui marked the next line
	UIView *bannerView = [[AdManager sharedManager] currentAdBannerView];
	[self.view addSubview:bannerView];
*/
#endif
	NSInteger score = [[self.quizRecord generalScore] intValue];
	self.responseView.layer.cornerRadius = 10.0;
	[self.responseView configureWithScore:score maxScore:100 color:[self.quizRecord generalResponseColor] backgroundColor:[UIColor blackColor]];
	
	self.yourScoreIsLabel.text = [NSString stringWithFormat:@"Your score is %d.", [[self.quizRecord generalScore] intValue]];
	self.yourScoreIsLabel.textColor = [UIColor OHDarkPurple];
	self.yourScoreIsLabel.font = [UIFont fontWithName:@"Arial" size:24];
	
	self.responseLabel.text = [self.quizRecord generalResponseText];
	self.responseLabel.textColor = [UIColor OHDarkPurple];

}

-(IBAction) detailedResponseButtonTouch:(id) sender {
	DetailedResponseViewController *detailedResponse = [[DetailedResponseViewController alloc] initWithQuizRecord:self.quizRecord];
	[self.navigationController pushViewController:detailedResponse animated:YES];
	[detailedResponse release];
}

-(IBAction) compareButtonTouch:(id)sender {
	ResponseHistoryViewController *responseHistoryViewController = [[ResponseHistoryViewController alloc] init];
	[self.navigationController pushViewController:responseHistoryViewController animated:YES];
	[responseHistoryViewController release];
}

-(IBAction) restartButtonTouch:(id)sender {
	//Reset all the previously selected choices
	NSString *sql = [NSString stringWithFormat:@"UPDATE Questions SET questionState=0"];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	while([query nextRecord] != nil);
	[query release];	
	
	[self.navigationController popViewControllerAnimated:YES];
}


#define ORIGINAL_BAR_COLOR RGB(133.0, 103.0, 164.0)
#define ORIGINAL_BAR_BG_COLOR RGB(211.0, 139.0, 103.0)

#pragma mark -
#pragma mark AdMobDelegate methods
- (NSString *)publisherId
{
	return @"a14b3057586646e";  //kirschnerj@gmail.com
	//return @"a14b325cdfa80d2";  //richard@avai.com
}
/*
- (BOOL)useTestAd {
	return YES;
}
*/

@end
