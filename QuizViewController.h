//
//  SurveyProofViewController.h
//  SurveyProof
//
//  Created by Bret Cowie on 7/7/09.
//  Copyright AVAI 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Question.h"
#import "GeneralResponseViewController.h"
#import "SQLQuery.h"
#import "Constants.h"

@interface QuizViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate> {
	NSMutableArray *questions;
	Question *currentQuestion;
	UITableView *questionTable;
	int numQuestions;
	int questionIndex;
	BOOL wait;
	UIButton *backButton;
	UIImageView *navBar;
	UIView *iadView;
	UIButton *restartButton;
    ADBannerView* mBannerView;
}

@property(nonatomic, retain) NSMutableArray *questions;
@property(nonatomic, retain) Question *currentQuestion;
@property (nonatomic, retain) IBOutlet UITableView *questionTable;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property int numQuestions;
@property int questionIndex;
@property (nonatomic, retain) IBOutlet UIImageView *navBar;
@property (nonatomic, retain) IBOutlet UIView *iadView;
@property (nonatomic, retain) IBOutlet UIButton *restartButton;

-(void) loadQuestionWithAnimation:(UIViewAnimationTransition) animationTransition;
- (void) getCurrentQuizQuestion;
-(IBAction) restartButtonTouch:(id)sender;
-(IBAction) backButtonTouch:(id)sender;
-(void) nextQuestion:(NSTimer *)theTimer;

-(void) loadGeneralResponse;

@end

