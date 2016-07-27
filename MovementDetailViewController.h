//
//  MovementDetailViewController.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/6/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "CustomMoviePlayerViewController.h"

@interface MovementDetailViewController : UIViewController {
	UILabel *_titleLabel;
	UILabel *_descriptionLabel;
	UILabel *_warningLabel;
	UILabel *_lengthLabel;
	UILabel *_categoryLabel;
	UIImageView *_previewImage;
	Video *_video;
	UIScrollView *_scrollView;
	CustomMoviePlayerViewController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *warningLabel;
@property (nonatomic, retain) IBOutlet UILabel *lengthLabel;
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *previewImage;
@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

-(id) initWithVideo:(Video *) video;
-(IBAction) playButtonPressed:(id) sender;
-(IBAction) backButtonTouch:(id) sender;

@end
