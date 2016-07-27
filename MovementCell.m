//
//  MovementCell.m
//  OfficeHarmony
//
//  Created by Kris Pena on 5/18/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import "MovementCell.h"

@implementation MovementCell

@synthesize videoCell = _videoCell;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize titleLabel = _titleLabel;
@synthesize targetsLabel = _targetsLabel;
@synthesize lengthLabel = _lengthLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize descriptionLabel = _descriptionLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
	[self.videoCell release];
	[self.thumbnailImageView release];
	[self.titleLabel release];
	[self.targetsLabel release];
	[self.lengthLabel release];
	[self.categoryLabel release];
	[self.descriptionLabel release];
    [super dealloc];
}

@end
