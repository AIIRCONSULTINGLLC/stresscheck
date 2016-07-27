//
//  ContactUsController.m
//
//  Created by Richard McClellan on 6/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ContactUsController.h"

@implementation ContactUsController

@synthesize contactLinks = _contactLinks;
@synthesize websiteButton = _websiteButton;

//- (void) allocMoreMemory {
//	NSLog(@"Alloc");
//	NSData *memory1 = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Default.png"]];
//	[memory1 retain];
//	NSData *memory2 = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Default.png"]];
//	[memory2 retain];
//    [self allocMoreMemory];
//}

-(IBAction)linkClick:(id)sender {
//  CFRelease(NULL);
//  [self allocMoreMemory];
    if([[Reachability reachabilityForInternetConnection] isReachable]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.contactLinks objectAtIndex:[sender tag]]]];
	} else {	
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kNoConnectivityErrorTitle message:kNoConnectivityErrorDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
}

-(IBAction)officeHarmonyClick:(id)sender {
    NSString *link = @"";
	#ifdef OH_FULL
		link = [self.contactLinks objectAtIndex:0];
	#endif
		
	#ifdef OH_LITE
		link = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=329954203&mt=8";
	#endif

	#ifdef STRESS_CHECK
		link = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=329954203&mt=8";
	#endif
	NSLog(@"About to open external app with url: %@", link);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

- (void)viewDidLoad {
		self.contactLinks = [NSArray arrayWithObjects:
						@"mailto:contact@aiirconsulting.com",
 						@"tel://8002655041",
						@"http://www.aiirconsulting.com",
						nil];
	[self.contactLinks retain];
	self.view.backgroundColor = [UIColor clearColor];
    [super viewDidLoad];
}

- (void)dealloc {
	[self.contactLinks release];
    [super dealloc];
}

@end
