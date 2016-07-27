//
//  DetailResponseViewController.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLQuery.h"
#import "QuizViewController.h"
//#import "CorePlot-CocoaTouch.h"
#import "UILabel2.h"
#include "Constants.h"
#import "QuizRecord.h"
#import "DetailedResponseGraphView.h"

@interface DetailedResponseViewController : UIViewController {
	UIScrollView *scrollView;
	UIButton *OHAdButton;
	UIImageView *bottomBannerView;
	UIImageView *bannerView;
	QuizRecord *quizRecord; 
	UIButton *restartButton;
	UIButton *backButton;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *OHAdButton;
@property (nonatomic, retain) IBOutlet UIImageView *bottomBannerView;
@property (nonatomic, retain) IBOutlet UIImageView *bannerView;
@property (nonatomic, retain) QuizRecord *quizRecord;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;


- (id)initWithQuizRecord:(QuizRecord *)record;
-(IBAction) generalResponseButtonTouch:(id) sender;
-(IBAction) restartButtonTouch:(id)sender;
-(IBAction) bannerButtonTouch:(id)sender;

@end
