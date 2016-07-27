//
//  AdManager.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/23/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import "AdManager.h"
#import <iAd/iAD.h>

static AdManager *theManager = nil;

@interface AdManager (Private)

-(id) newAdBannerView;

@end

@implementation AdManager

@synthesize adBannerView;
@synthesize queuedAdBannerView;


+ (id) sharedManager {
	if(theManager == nil) {
		theManager = [[AdManager alloc] init];
	}
	return theManager;
}

- (id) init {
	if((self = [super init])) {
		if(kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iPhoneOS_3_2) {
			self.adBannerView = [self newAdBannerView];
		}
	}
	return self;
}

-(id) newAdBannerView { 
	// Add the AdBannerView
	id newBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 361, 320, 50)];
	NSString *adBannerContentSizeIdentifier;
	if (&ADBannerContentSizeIdentifierPortrait != nil) {
		adBannerContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	} else {
		adBannerContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
	}
	[newBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:adBannerContentSizeIdentifier, nil]];
	[newBannerView setCurrentContentSizeIdentifier:adBannerContentSizeIdentifier];
	[newBannerView setDelegate:self];
	return newBannerView;
}

- (id) currentAdBannerView { 
	if(((ADBannerView *)adBannerView).bannerLoaded && ((ADBannerView *)queuedAdBannerView).bannerLoaded) {
		self.adBannerView = self.queuedAdBannerView;
		self.queuedAdBannerView = [self newAdBannerView];
	}
	return self.adBannerView; 
}

#pragma mark -
#pragma mark ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if(banner == self.adBannerView) {
		self.queuedAdBannerView = [self newAdBannerView];
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if(banner == self.adBannerView) {
        self.adBannerView = [self newAdBannerView];
    } else if(banner == self.queuedAdBannerView) {
        self.queuedAdBannerView = [self newAdBannerView];
    }
}

@end
