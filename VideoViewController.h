//
//  VideoViewController.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright AVAI 2009. All rights reserved.
//

#import "MyViewController.h"
#import "SQLQuery.h"
#import "Video.h"
#import "MindCell.h"
#import "MovementCell.h"
#import "MovementDetailViewController.h"

@interface VideoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>{
	NSMutableArray *listOfItems;
	NSMutableArray *_videos;
	MyViewController *mViewController;
	IBOutlet UITableViewCell *videoCell;
	UITableView *videoTable;
	NSString *_currentMediaType;
}

@property (nonatomic, retain) NSMutableArray *videos;
@property (nonatomic, retain) MyViewController *mViewController;
@property (nonatomic, retain) UITableViewCell *videoCell;
@property (nonatomic, retain) IBOutlet UITableView *videoTable;
@property (nonatomic, retain) NSString *currentMediaType;

@end
