//
//  DetailedResponseGraphView.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/22/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import "DetailedResponseGraphView.h"
#import "DetailedResponseView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DetailedResponseGraphView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame quizRecord:(QuizRecord *)quizRecord {
    if(self = [super initWithFrame:frame]) {		
		CGRect tmp1Rect;
		CGRect tmp2Rect;
		CGRectDivide (self.bounds, &tmp1Rect, &tmp2Rect, 30, CGRectMinXEdge);
		CGRect drRect;
		CGRect xAxisLabelRect;
		CGRectDivide (tmp2Rect, &xAxisLabelRect, &drRect, 100, CGRectMaxYEdge);
		CGRect yAxisLabelRect;
		CGRectDivide (tmp1Rect, &tmp2Rect, &yAxisLabelRect, 100, CGRectMaxYEdge);
		
		DetailedResponseView *drView = [[DetailedResponseView alloc] initWithFrame:drRect quizRecord:quizRecord];
		[self addSubview:drView];
		
		// Add Y Axis labels
		NSInteger yAxisMinimum = 0;
		NSInteger yAxisMaximum = 25;
		NSInteger yAxisStep = 5;

		UIView *yaView = [[UIView alloc] initWithFrame:yAxisLabelRect];
		[self addSubview:yaView];
		for(int i=yAxisMinimum;i<=yAxisMaximum;i+=yAxisStep) {
			UILabel *axisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, yAxisLabelRect.size.width - 10.0, 20)];
			axisLabel.text = [NSString stringWithFormat:@"%d", yAxisMaximum - i];
			[axisLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
			[axisLabel setBackgroundColor:[UIColor clearColor]];
			[axisLabel setTextColor:[UIColor blackColor]];
			[axisLabel setTextAlignment:UITextAlignmentRight];
			axisLabel.center = CGPointMake(yAxisLabelRect.size.width / 2, yAxisLabelRect.size.height * i / yAxisMaximum);
			[yaView addSubview:axisLabel];
			[axisLabel release];
		}
		[self addSubview:yaView];
		[yaView release];
		
//ADD DOMAIN NAMES AND SCORE VALUES AND IMAGES FOR BAR BOTTOMS
		UIView *domainNameView = [[UIView alloc] initWithFrame:xAxisLabelRect];
		int numDomains = [quizRecord.domainNames count];
		for(int i=0; i<numDomains; ++i)	{
			UILabel *domainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			domainLabel.text = [quizRecord.domainNames objectAtIndex:i];
			domainLabel.font = [UIFont boldSystemFontOfSize:14];
			domainLabel.textAlignment = UITextAlignmentRight;
			domainLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
			domainLabel.backgroundColor = [UIColor clearColor];
			domainLabel.textColor = [UIColor blackColor];

			CGRect domainFrame;
			domainFrame.origin.x = i * xAxisLabelRect.size.width / 4.0;
			domainFrame.origin.y = 5.0;
			domainFrame.size.width = xAxisLabelRect.size.width / 4.0;
			domainFrame.size.height = xAxisLabelRect.size.height;
			domainLabel.frame = domainFrame;
			[domainNameView addSubview:domainLabel];
			[domainLabel release];
		}
		[self addSubview:domainNameView];
		[domainNameView release];
    }
    return self;
}

@end
