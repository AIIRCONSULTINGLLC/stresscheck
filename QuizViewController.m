//
//  QuizViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/24//09.
//  Copyright AVAI 2009. All rights reserved.
//

#import "QuizViewController.h"
#import "AdManager.h"

#define kQuestionWidth 320
#define kQuestionHeight 353

static NSUInteger const kProgressLabelTag = 2;
static NSUInteger const kTitleLabelTag = 3;
static NSUInteger const kTableViewTag = 4;	
static NSUInteger const kRestartButtonTag = 5;

@implementation QuizViewController

@synthesize questions;
@synthesize questionTable;
@synthesize currentQuestion;
@synthesize questionIndex;
@synthesize numQuestions;
@synthesize backButton;
@synthesize navBar;
@synthesize iadView;
@synthesize restartButton;

- (void)dealloc {
	[self.questions release];
	[self.questionTable release];
	[self.currentQuestion release];
	[self.backButton release];
	[self.navBar release];
	[self.iadView release];
	[self.restartButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (mBannerView == nil)
    {
        mBannerView = [[[ADBannerView alloc] init] autorelease];
        mBannerView.delegate = self;
    
        [self.view addSubview:mBannerView];
        //        mBannerView.hidden = TRUE;
    }
    UIImage *backButtonImage = [[UIImage imageNamed:@"button_gray_back.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:15];
	[self.backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];

	UIImage *buttonImage = [[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15];
	[self.restartButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
//#ifdef STRESS_CHECK
//	self.navBar.image = [UIImage imageNamed:@"OH_navbar_head_stress.png"];
//#endif
	
	// create the initial question view	
	self.questionTable.rowHeight = 46;
    self.questionTable.backgroundColor = [UIColor clearColor];
	self.questionTable.separatorColor = [UIColor whiteColor];
	UITableViewCell *tableHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 89)];
	tableHeader.backgroundColor = [UIColor clearColor];
	UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 15)];
	progressLabel.tag = kProgressLabelTag;
	progressLabel.font = [UIFont systemFontOfSize:13];
	progressLabel.textColor = [UIColor OHDarkPurple];
	progressLabel.backgroundColor = [UIColor clearColor];
	progressLabel.textAlignment = UITextAlignmentRight;
	progressLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[tableHeader addSubview:progressLabel];
	[progressLabel release];
	
	UILabel *questionPrompt = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 69)];
	questionPrompt.tag = kTitleLabelTag;
	questionPrompt.font = [UIFont boldSystemFontOfSize:18];
	questionPrompt.textColor = [UIColor OHDarkPurple];
	questionPrompt.backgroundColor = [UIColor clearColor];
	questionPrompt.textAlignment = UITextAlignmentLeft;
	questionPrompt.numberOfLines = 3;
	questionPrompt.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[tableHeader addSubview:questionPrompt];
	[questionPrompt release];
	
	self.questionTable.tableHeaderView = tableHeader;
	self.questionTable.scrollEnabled = NO;
	//Figure out how many questions there are
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:@"SELECT COUNT (*) FROM Questions"];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil) {
		self.numQuestions = sqlite3_column_int (sqlStatement, 0);
		NSLog(@"numQuestions: %d", self.numQuestions);
	}
	[query release];
#ifdef STRESS_CHECK
/*
    // cuiping cui marked the next line
	NSInteger bannerViewTag = 55;
	UIView *bannerView = (UIView *)[self.view viewWithTag:bannerViewTag];
	if(bannerView != nil) {
		[bannerView removeFromSuperview];
	}
	bannerView = (UIView *)[[AdManager sharedManager] currentAdBannerView];
	bannerView.tag = bannerViewTag;
	[self.view addSubview:bannerView];
*/
#endif
	//Display the first question
	self.currentQuestion = [[Question alloc] init];
	self.questionIndex = 0;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.questionTable reloadData];
	[self loadQuestionWithAnimation:UIViewAnimationTransitionNone];
}

- (void)viewDidLayoutSubviews{
            mBannerView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - mBannerView.frame.size.height/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

-(void) loadQuestionWithAnimation:(UIViewAnimationTransition) animationTransition {
	NSLog(@"loadQuestionWithAnimation");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:animationTransition forView:self.questionTable cache:YES];
	[self.questionTable removeFromSuperview];
	
	UILabel *progressLabel = (UILabel *)[self.questionTable.tableHeaderView viewWithTag:kProgressLabelTag];
	UILabel *titleLabel = (UILabel *)[self.questionTable.tableHeaderView viewWithTag:kTitleLabelTag];
	if(self.questionIndex == 0)
		self.backButton.hidden = YES;
	else
		self.backButton.hidden = NO;
	[self getCurrentQuizQuestion];
	progressLabel.text = [NSString stringWithFormat:@"Step %d of %d", self.questionIndex+1, self.numQuestions];
	titleLabel.text = self.currentQuestion.prompt;
	
	[self.questionTable reloadData];
	[self.view addSubview:self.questionTable];

	[UIView commitAnimations];
}

- (void) getCurrentQuizQuestion {
	//Initialize question
	self.currentQuestion = [[Question alloc] init];
	
	// Get prompt, question state, and questionDomain
	NSString *sql = [NSString stringWithFormat:@"SELECT prompt, questionState, domainId FROM Questions WHERE displayOrder=%d", self.questionIndex+1]; //displayOrder is indexed at 1
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil) {
		self.currentQuestion.prompt = [[NSString alloc] initWithCString:(char *)sqlite3_column_text (sqlStatement, 0)];
		self.currentQuestion.questionState = sqlite3_column_int (sqlStatement, 1);
		self.currentQuestion.questionDomain = [[NSNumber alloc] initWithInt:sqlite3_column_int (sqlStatement, 2)];
	}
	
	// Get answers
	sql = @"SELECT Answers.text, Answers.pointValue FROM Questions ";
	sql = [sql stringByAppendingString:@"JOIN QuestionAnswer on Questions.id = QuestionAnswer.questionId "];
	sql = [sql stringByAppendingString:@"JOIN Answers on Answers.id = QuestionAnswer.answerId "];
	sql = [sql stringByAppendingFormat:@"WHERE Questions.displayOrder=%d ", self.questionIndex+1]; //displayOrder is indexed at 1
	sql = [sql stringByAppendingString:@"ORDER BY QuestionAnswer.displayOrder"];
	[query release];
    
	query = [[SQLQuery alloc] initWithQuery:sql];
	while((sqlStatement = [query nextRecord]) != nil) {
        [self.currentQuestion.answers addObject:[[[NSString alloc] initWithCString:(char *)sqlite3_column_text (sqlStatement, 0)] autorelease]];
		[self.currentQuestion.pointValues addObject:[[[NSNumber alloc] initWithInt:sqlite3_column_int (sqlStatement, 1)] autorelease]];
	}
	[query release];
}

-(void) loadGeneralResponse {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.questionTable cache:YES];
	[self.questionTable removeFromSuperview];
	
	GeneralResponseViewController *generalResponseViewController = [[[GeneralResponseViewController alloc] init] autorelease];
	[self.view addSubview:generalResponseViewController.view];
	[UIView commitAnimations];
}

-(IBAction) restartButtonTouch:(id)sender {
	//Reset all the previously selected choices
	NSString *sql = [NSString stringWithFormat:@"UPDATE Questions SET questionState=0"];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil);
	[query release];
	
	//Load the first question
	self.questionIndex = 0;
	[self loadQuestionWithAnimation: UIViewAnimationTransitionFlipFromRight];
}

-(IBAction) backButtonTouch:(id)sender {
	if(self.questionIndex > 0) {
		self.questionIndex--;
		[self loadQuestionWithAnimation:UIViewAnimationTransitionFlipFromLeft];
	}
}

#pragma mark -
#pragma mark UITableViewDelegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.currentQuestion.answers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		//No reusable cell was available, so we create a new cell and configure its subviews.
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.textLabel.text = [self.currentQuestion.answers objectAtIndex:indexPath.row];
	cell.textLabel.textColor = [UIColor OHDarkPurple];
	cell.textLabel.font = [UIFont systemFontOfSize:18];
    //cell.textLabel.backgroundColor=[UIColor grayColor];
    cell.backgroundColor=[UIColor clearColor];
	if(indexPath.row == self.currentQuestion.questionState-1) {
		cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OH_butt_checkboxON.png" ofType:nil]];
	} else {
		cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OH_butt_checkboxOFF.png" ofType:nil]];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Update the question state
	self.currentQuestion.questionState = indexPath.row+1;
	NSString *sql = [NSString stringWithFormat:@"UPDATE Questions SET questionState=%d WHERE displayOrder=%d", indexPath.row+1, self.questionIndex+1]; //displayOrder is indexed at 1
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil);
	[query release];

	[tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	[NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(nextQuestion:) userInfo:nil repeats:NO];
}

-(void) nextQuestion:(NSTimer *)theTimer {
	self.questionIndex++;
	if(self.questionIndex < self.numQuestions)
	{
		[self loadQuestionWithAnimation:UIViewAnimationTransitionFlipFromRight];
	}
	else
	{
		self.questionIndex = 0;
		[self loadQuestionWithAnimation:UIViewAnimationTransitionNone];
		GeneralResponseViewController *generalResponse = [[GeneralResponseViewController alloc] init];
		[self.navigationController pushViewController:generalResponse animated:YES];
		[generalResponse release];
	}
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"bannerViewDidLoadAd");
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerViewActionDidFinish");
}

@end
