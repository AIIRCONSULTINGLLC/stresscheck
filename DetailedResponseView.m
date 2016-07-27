//
//  DetailedResponseView.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/20/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import "DetailedResponseView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor-HSVAdditions.h"

@implementation DetailedResponseView

- (void)dealloc {
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame quizRecord:(QuizRecord *)quizRecord {
    if(self = [super initWithFrame:frame]) {
		self.clipsToBounds = YES;
		self.layer.cornerRadius = 10.0;
		self.layer.borderColor = [[UIColor darkGrayColor] CGColor]; 
		self.layer.borderWidth = 2.0;
		NSInteger numDomains = [quizRecord.domainScores count];
		CGFloat domainBarWidth = self.frame.size.width / numDomains;
		NSArray *colors = [NSArray arrayWithObjects:
						   [UIColor colorWithHexString:@"4900FF"],
						   [UIColor colorWithHexString:@"009EFC"],
						   [UIColor colorWithHexString:@"9BC3F9"],
						   [UIColor colorWithHexString:@"A5F7FF"],
//						   [UIColor colorWithHexString:@"00A626"],
//						   [UIColor colorWithHexString:@"E2DB24"],
//						   [UIColor colorWithHexString:@"FFA631"],
//						   [UIColor colorWithHexString:@"EE0036"],
//													   RGB(0.0, 121.0, 165.0),
//													   RGB(255.0, 83.0, 165.0),
//													   RGB(252.0, 189.0, 8.0),
//													   RGB(102.0, 177.0, 50.0),
							nil];
		for(int i=0;i<numDomains;i++) {
			CGRect responseFrame = CGRectMake(i * domainBarWidth, 0, domainBarWidth, self.frame.size.height);
			ResponseView *responseView = [[ResponseView alloc] initWithFrame:responseFrame];
			NSInteger score = [[quizRecord.domainScores objectAtIndex:i] intValue];
			[responseView configureWithScore:score maxScore:25 color:[colors objectAtIndex:i] backgroundColor:[UIColor blackColor]];			
			[self addSubview:responseView];
		}
    }
    return self;
}

@end
