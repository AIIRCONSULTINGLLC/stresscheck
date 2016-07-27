//
//  ResponseView.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/17/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ResponseView.h"
#import "UIColor-HSVAdditions.h"

static CGFloat barWidth = 30.0;

@interface ResponseView (Private) 

- (void) setup;
- (void) setupWithFrame:(CGRect)newFrame;

@end

@implementation ResponseView

@synthesize barBackgroundView;
@synthesize barView;
@synthesize scoreLabel;

- (void)dealloc {
	[self.barBackgroundView release];
	[self.barView release];
	[self.scoreLabel release];
    [super dealloc];
}

- (void) awakeFromNib {
	[self setup];
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
		[self setupWithFrame:frame];
    }
    return self;
}

- (void) setupWithFrame:(CGRect)newFrame {
	self.frame = newFrame;
	[self setup];
}

- (void) setup {
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	// If the frame height is greater than the width, we will do a vertical bar.
	vertical = (self.bounds.size.height > self.bounds.size.width);
	
	// BAR BACKGROUND VIEW
	self.barBackgroundView = [[GradientView alloc] initWithFrame:CGRectZero];
	self.barBackgroundView.backgroundColor = [UIColor blueColor];
	self.barBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	NSArray *colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
	[(CAGradientLayer*)self.barBackgroundView.layer setColors:colors];
	[(CAGradientLayer*)self.barBackgroundView.layer setStartPoint:vertical ? CGPointMake(0, 0.5) : CGPointMake(0.5, 0)];
	[(CAGradientLayer*)self.barBackgroundView.layer setEndPoint:vertical ? CGPointMake(1, 0.5) : CGPointMake(0.5, 1)];
	[self addSubview:self.barBackgroundView];
	
	// BAR VIEW
	self.barView = [[GradientView alloc] initWithFrame:CGRectZero];
	self.barView.backgroundColor = [UIColor greenColor];
	self.barView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[(CAGradientLayer *)self.barView.layer setStartPoint:vertical ? CGPointMake(0, 0.5) : CGPointMake(0.5, 0)];
	[(CAGradientLayer *)self.barView.layer setEndPoint:vertical ? CGPointMake(1, 0.5) : CGPointMake(0.5, 1)];
	[self addSubview:self.barView];
	
	// FRACTION LABEL
	self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5.0, 0.0)];
	self.scoreLabel.font = [UIFont boldSystemFontOfSize:16];
	self.scoreLabel.textColor = [UIColor whiteColor];
	self.scoreLabel.backgroundColor = [UIColor clearColor];
	self.scoreLabel.textAlignment = UITextAlignmentRight;
	self.scoreLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[self addSubview:self.scoreLabel];
}

- (void) configureWithScore:(NSInteger)score maxScore:(NSInteger)maxScore color:(UIColor *)color backgroundColor:(UIColor *)bgColor {
	self.backgroundColor = bgColor;
	
	CGRect barBackgroundFrame;
	if(vertical) {
		barBackgroundFrame = CGRectInset(self.bounds, (self.bounds.size.width - barWidth) / 2.0, 0);
	} else {
		barBackgroundFrame = CGRectInset(self.bounds, 0, (self.bounds.size.height - barWidth) / 2.0);
	}
	self.barBackgroundView.frame = barBackgroundFrame;

	CGRect barFrame = barBackgroundFrame;
	if(vertical) {
		barFrame.origin.y = self.bounds.size.height * (maxScore - score) / maxScore;
		barFrame.size.height = self.bounds.size.height * score / maxScore;	
	} else {
		barFrame.size.width = self.bounds.size.width * score / maxScore;
		self.scoreLabel.text = [NSString stringWithFormat:@"%d/%d", score, maxScore];
		[self bringSubviewToFront:self.scoreLabel];
	}
	self.barView.frame = barFrame;
	NSArray *colors =  [NSArray arrayWithObjects: (id)[color CGColor], (id)[[color shadow] CGColor], nil];
	[(CAGradientLayer *)self.barView.layer setColors:colors];
}

@end
