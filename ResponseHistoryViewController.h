//
//  ResponseHistoryViewController.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/12/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResponseHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *responseTableView;
	NSMutableArray *quizRecords;
	UIButton *backButton;
	UIButton *editButton;
}

@property (nonatomic, retain) IBOutlet UITableView *responseTableView;
@property (nonatomic, retain) NSMutableArray *quizRecords;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *editButton;

- (IBAction) backButtonPressed;
- (IBAction) restartButtonPressed;
@property (retain, nonatomic) IBOutlet UIImageView *bottomBannerView;

@end
