//
//  MindCell.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 8/5/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import "MindCell.h"


@implementation MindCell

@synthesize videoCell = _videoCell;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize titleLabel = _titleLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize lengthLabel = _lengthLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
	[self.descriptionLabel release];
	[self.lengthLabel release];
    [super dealloc];
}


@end
