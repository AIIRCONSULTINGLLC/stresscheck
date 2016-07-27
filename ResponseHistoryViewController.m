    //
//  ResponseHistoryViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/12/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import "ResponseHistoryViewController.h"
#import "QuizRecord.h"
#import "Constants.h"
#import "UIColor-HSVAdditions.h"
#import "ResponseHistoryView.h"
#import "DetailedResponseViewController.h"
#import "AdManager.h"

@implementation ResponseHistoryViewController

@synthesize responseTableView;
@synthesize quizRecords;
@synthesize backButton;
@synthesize editButton;

- (void)dealloc {
	[self.responseTableView release];
	[self.quizRecords release];
	[self.backButton release];
	[self.editButton release];
    [_bottomBannerView release];
    [super dealloc];
}

- (id)init {
    if((self = [super initWithNibName:@"ResponseHistoryViewController" bundle:[NSBundle mainBundle]])) {
		self.quizRecords = (NSMutableArray *)[QuizRecord allQuizRecords];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UIImage *backButtonImage = [[UIImage imageNamed:@"button_gray_back.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:15];
	[self.backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
	UIImage *buttonImage = [[UIImage imageNamed:@"button_gray.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15];
	[self.editButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
		
	[self.responseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.responseTableView setBackgroundColor:[UIColor clearColor]];
    
#ifdef STRESS_CHECK
/*
    // cuiping cui marked the next line
	// Add the AdBannerView
	UIView *bannerView = [[AdManager sharedManager] currentAdBannerView];
	[self.view addSubview:bannerView];
*/
#endif
}
- (void)viewDidLayoutSubviews
{
    responseTableView.frame = CGRectMake(0, self.bottomBannerView.bounds.size.height, responseTableView.bounds.size.width, responseTableView.bounds.size.height-self.bottomBannerView.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setBottomBannerView:nil];
    [super viewDidUnload];
}

- (IBAction) backButtonPressed {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) restartButtonPressed {
	[self.responseTableView setEditing:!self.responseTableView.editing animated:YES];
	// TODO: Toggle name of button from Edit to Done
	if(self.responseTableView.editing) {
		[self.editButton setTitle:@"Done" forState:UIControlStateNormal];
	} else {
		[self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
	}
}

#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.quizRecords count];
}

static NSInteger kResponseHistoryViewTag = 5;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	QuizRecord *record = [self.quizRecords objectAtIndex:indexPath.row];
	NSString *identifier = @"HistoryCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier]; 
	ResponseHistoryView *historyView;
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		cell.opaque = NO;
		cell.backgroundColor = [UIColor blackColor];
		historyView = [[ResponseHistoryView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		historyView.tag = kResponseHistoryViewTag;
		[cell.contentView addSubview:historyView];
        [historyView release];
		cell.contentView.clipsToBounds = YES;
	}
	historyView = (ResponseHistoryView *)[cell.contentView viewWithTag:kResponseHistoryViewTag];
	[historyView configureWithScore:[record.generalScore intValue] maxScore:100 color:record.generalResponseColor date:record.date];
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DetailedResponseViewController *drVC = [[DetailedResponseViewController alloc] initWithQuizRecord:[self.quizRecords objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:drVC animated:YES];
	[drVC release];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView beginUpdates];    
	QuizRecord *record = [self.quizRecords objectAtIndex:indexPath.row];
	[record deleteFromHistory];
	[self.quizRecords removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
	[tableView endUpdates];
}




@end
