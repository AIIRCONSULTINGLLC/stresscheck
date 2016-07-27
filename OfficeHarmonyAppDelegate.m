//
//  OfficeHarmonyAppDelegate.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OfficeHarmonyAppDelegate.h"
//#import "FlurryAPI.h"
#import "ASIHTTPRequest.h"

int gMovementUnocked;
int gMeditationUnocked;

static NSString *hasRatedKey = @"hasRated";
static NSString *launchNumberKey = @"launchNumber";
static NSString *agreementAcceptedKey = @"notFirstLaunch";

@implementation OfficeHarmonyAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize backgroundColor;
@synthesize iapDownloadInProgress = _iapDownloadInProgress;
@synthesize restoreTarget = _restoreTarget;
@synthesize disclaimerAlert;
@synthesize ratingAlert;

- (void)dealloc {
    [tabBarController release];
    [window release];
	[self.disclaimerAlert release];
	[self.ratingAlert release];
    [super dealloc];
}

// look for the database in the user's ~/Document directory;  if not found, copy
// it there from the app bundle (this is necessary because apps (except for Apple's)
// can't write to files in their bundles
- (BOOL) initializeDatabase {
	NSString *documentFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];	
	NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:kDatabaseName];
	if (![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]) {
		NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"OfficeHarmony115" ofType:@"rdb"];
		if (backupDbPath == nil) {
			return NO;
		} else {
			BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
			if(!copiedBackupDb) {
				return NO;
			}
		}
	}
	return YES;	
}
- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	
	// Initialize iapDownloadInProgress
    
    
	self.iapDownloadInProgress = NO;
	
	//Pinch Media Analytics
	NSString *apiKey = @"";
    
    // Quincy Manager
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAutomaticallySendCrashReports];
    [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://stresscheck.netne.net/crash_v200.php"];
    [[BWQuincyManager sharedQuincyManager] setDelegate:self];

	#ifdef OH_FULL
		apiKey = @"f9a78bdf09660a105a2934257e079dd4";
	#endif
	
	#ifdef OH_LITE
		apiKey = @"a1f14280729b059e6d81c6017cb5f95d";
	#endif
		
	#ifdef STRESS_CHECK
		apiKey = @"dc9bc8fc648061e7fd8e768e1221feae";
	#endif
	
	NSLog(@"final application code: %@", apiKey);
	//[FlurryAPI startSession:apiKey];
	if (![self initializeDatabase]) {
		NSLog(@"Couldn't initialize database;  major fail");
		return NO;
	}
	
    // Add the tab bar controller's current view as a subview of the window
    
    window.rootViewController = tabBarController;
    //tabBarController.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
	for(UIViewController *controller in tabBarController.viewControllers) {
        NSLog(@"controller title %@", controller.title);
    }

//  cuiping marked following paragraph under Jonathan's request
//	if([[NSUserDefaults standardUserDefaults] objectForKey:agreementAcceptedKey] == nil) {
//		self.disclaimerAlert = [[UIAlertView alloc] initWithTitle:kDisclaimerTitle 
//																  message:kDisclaimerDescription 
//																 delegate:self 
//														cancelButtonTitle:nil 
//														otherButtonTitles:nil];
//		[self.disclaimerAlert addButtonWithTitle:@"Exit App"];
//		[self.disclaimerAlert addButtonWithTitle:@"I Agree"];
//		[self.disclaimerAlert show];
//		[self.disclaimerAlert release];
//	}
	
	NSInteger launchNumber = [[NSUserDefaults standardUserDefaults] integerForKey:launchNumberKey];
	launchNumber++;
	[[NSUserDefaults standardUserDefaults] setInteger:launchNumber forKey:launchNumberKey];
	
	BOOL hasRated = [[NSUserDefaults standardUserDefaults] boolForKey:hasRatedKey];
	if(launchNumber % 3 == 0 && !hasRated) {
		self.ratingAlert = [[UIAlertView alloc] initWithTitle:@"We love feedback!" 
														message:@"As part of our ongoing efforts to make Stress Check the best free stress assessment around, we'd very much appreciate your feedback. Please let us know why you value Stress Check as well as any ways that we can make it better for you. Thank you!" 
													   delegate:self 
											  cancelButtonTitle:@"Later" 
											  otherButtonTitles:@"Review Stress Check", nil];
		[self.ratingAlert show];
		[self.ratingAlert release];
	}
#ifdef STRESS_CHECK
	//Register for notifications from app store
	//StoreObserver *observer = [[StoreObserver alloc] init];
	//[[SKPaymentQueue defaultQueue] addTaransactionObserver:observer];
	[MKStoreManager sharedManager];
#endif

	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
		(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
    }

    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]} forState:UIControlStateSelected];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:0.29 green:0.73 blue:0.95 alpha:1]];
	return YES;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSString *token = [[[[deviceToken description]
				 stringByReplacingOccurrencesOfString: @"<" withString: @""]
				stringByReplacingOccurrencesOfString: @">" withString: @""]
			   stringByReplacingOccurrencesOfString: @" " withString: @""];
	NSLog(@"deviceToken %@", token);

	// We like to use ASIHttpRequest classes, but you can make this register call how ever you like
	// just notice that it's an http PUT
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	NSString *UAServer = @"https://go.urbanairship.com";
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@/", UAServer, @"/api/device_tokens/", token];
	NSURL *url = [NSURL URLWithString:  urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = @"PUT";
	
	// Authenticate to the server
#ifdef DEBUG
	request.username = @"s-33bRXaQ3STznRy05pW1g";
	request.password = @"7_163BIRTDKpmk9OslMPSA";
#else
	request.username = @"YIAPWCJ8StqHH9L9szcU8g";
	request.password = @"OPCVPdFcRi6z4mdxKqOi0w";
#endif	
	[request setDelegate:self];
	[request setDidFinishSelector: @selector(successMethod:)];
	[request setDidFailSelector: @selector(requestWentWrong:)];
	[queue addOperation:request];
}

- (void)successMethod:(ASIHTTPRequest *) request {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"Device Token ");
}

- (void)requestWentWrong:(ASIHTTPRequest *)request {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSError *error = [request error];
#ifdef DEBUG
	UIAlertView *someError = [[UIAlertView alloc] initWithTitle:@"Network error" 
														message:@"Error registering with server"
													   delegate:self
											  cancelButtonTitle: @"Ok"
											  otherButtonTitles: nil];
	 [someError show];
	 [someError release];
#endif
	NSLog(@"ERROR: NSError query result: %@", error);
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
	//Zero out the application badge
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"OfficeHarmonyAppDelegate applicationDidReceiveMemoryWarning");
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView == self.disclaimerAlert) {
		if(buttonIndex == 0) {
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:launchNumberKey];
			exit(0);
		} else	{
			[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:agreementAcceptedKey];
		}
	} else if(alertView == self.ratingAlert) {
		if(buttonIndex == 1) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:hasRatedKey];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/stress-check/id330049595?mt=8"]];
		}
	}
}


#pragma mark CrashReportSenderDelegate

-(void)connectionOpened {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connectionClosed {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end

