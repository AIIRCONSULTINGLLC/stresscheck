//
//  DetailResponseViewController.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLQuery.h"
#import "QuizRecord.h"
#import "ResponseView.h"
#import "DetailedResponseViewController.h"

@interface GeneralResponseViewController : UIViewController {
	UIImageView *navBar;
	ResponseView *responseView;
	UILabel *yourScoreIsLabel;
	UILabel *responseLabel;
	QuizRecord *quizRecord;
	UIButton *restartButton;
}

@property (nonatomic, retain) IBOutlet UIImageView *navBar;
@property (nonatomic, retain) IBOutlet ResponseView *responseView;
@property (nonatomic, retain) IBOutlet UILabel *yourScoreIsLabel;
@property (nonatomic, retain) IBOutlet UILabel *responseLabel;
@property (nonatomic, retain) QuizRecord *quizRecord;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;
-(IBAction) detailedResponseButtonTouch:(id) sender;
-(IBAction) restartButtonTouch:(id)sender;
-(IBAction) compareButtonTouch:(id)sender;

@end
