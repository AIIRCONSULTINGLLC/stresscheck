//
//  ResponseHistoryView.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/17/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import "ResponseHistoryView.h"


@implementation ResponseHistoryView

@synthesize responseView;
@synthesize dateLabel;

- (void)dealloc {
	[self.responseView release];
	[self.dateLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
//		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth	| UIViewAutoresizingFlexibleHeight;
//		self.backgroundColor = [UIColor blackColor];
		CGRect dateRect;
		CGRect responseRect;
		CGRectDivide (frame, &dateRect, &responseRect, 60.0, CGRectMinXEdge);
		self.dateLabel = [[UILabel alloc] initWithFrame:dateRect];
		[self.dateLabel setBackgroundColor:[UIColor clearColor]];
		[self.dateLabel setTextColor:[UIColor whiteColor]];
		[self.dateLabel setTextAlignment:UITextAlignmentCenter];
		[self.dateLabel setFont:[UIFont boldSystemFontOfSize:12]];
		self.dateLabel.numberOfLines = 0;
		[self addSubview:self.dateLabel];
		self.responseView = [[ResponseView alloc] initWithFrame:responseRect]; 
		self.responseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self.responseView];
	}
    return self;
}

- (void) configureWithScore:(NSInteger)score maxScore:(NSInteger)maxScore color:(UIColor *)color date:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[self.dateLabel setText:[dateFormatter stringFromDate:date]];
	[dateFormatter release];
    
	[self.responseView configureWithScore:score maxScore:maxScore color:color backgroundColor:[UIColor clearColor]];
}

@end
