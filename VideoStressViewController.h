//
//  VideoStressViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright AVAI 2009. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "SQLQuery.h"
#import "Video.h"
#import "MindCell.h"
#import "MovementCell.h"
#import "MovementDetailViewController.h"
#import "MKStoreManager.h"
#import "Reachability.h"
#import "OfficeHarmonyAppDelegate.h"
#import "CustomMoviePlayerViewController.h"

@interface VideoStressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MKStoreKitDelegate>{
	NSMutableArray *listOfItems;
	NSMutableArray *_videos;
	IBOutlet UITableViewCell *videoCell;
	UITableView *videoTable;
	NSString *_currentMediaType;

	UILabel *_statusMessage;
	UIButton *_buyButton;
    UIButton *_restoreButton;
	UIProgressView *_progressView;
	UIActivityIndicatorView *_activityIndicator;
	UIView *_iapView;
	SKPaymentTransaction *_transaction;
	UIImageView *_backgroundImage;
	CustomMoviePlayerViewController *moviePlayer;
	UILabel *titleLabel;
}
@property (retain, nonatomic) IBOutlet UIImageView *metalBar;

@property (nonatomic, retain) NSMutableArray *videos;
@property (nonatomic, retain) UITableViewCell *videoCell;
@property (nonatomic, retain) IBOutlet UITableView *videoTable;
@property (nonatomic, retain) NSString *currentMediaType;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UILabel *statusMessage;
@property (nonatomic, retain) IBOutlet UIButton *buyButton;
@property (retain, nonatomic) IBOutlet UIButton *restoreButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIView *iapView;
@property (nonatomic, retain) SKPaymentTransaction *transaction;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

- (IBAction) buyButtonTouch:(id)sender;
- (IBAction)restoreButtonTouch:(id)sender;
- (void) revealContent;

@end
