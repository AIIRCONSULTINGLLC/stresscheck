//
//  HomeViewController.h
//  Malibu
//
//  Created by Richard McClellan on 6/18/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "TwitterReader.h"
#import "Reachability.h"
#import "Constants.h"
#import "OfficeHarmonyAppDelegate.h"

@interface HomeViewController : UIViewController <TwitterReaderDelegate, UIWebViewDelegate> {
	NSArray *_twitterList;
	UIActivityIndicatorView *_activityIndicator;
	UIScrollView *_scrollView;
	UIImageView *_imageView;
	UIWebView *_twitterWebView;
	NSString *_twitterHtml;
}


@property(nonatomic, retain) NSArray *twitterList;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIWebView *twitterWebView;
@property(nonatomic, retain) NSString *twitterHtml;

- (void) displayTwitter;

@end
