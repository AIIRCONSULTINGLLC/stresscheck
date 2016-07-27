//
//  MindCell.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MindCell : UITableViewCell {
	UITableViewCell *_videoCell;
	UIImageView *_thumbnailImageView;
	UILabel *_titleLabel;
	UILabel *_descriptionLabel;
	UILabel *_lengthLabel;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *videoCell;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *lengthLabel;

@end
