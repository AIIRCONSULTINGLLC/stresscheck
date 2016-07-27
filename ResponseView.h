//
//  ResponseView.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/17/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "QuizRecord.h"
#import "GradientView.h"

@interface ResponseView : UIView {
	GradientView *barBackgroundView;
	GradientView *barView;
	UILabel *scoreLabel;
	BOOL vertical;
}

@property (nonatomic, retain) UIView *barBackgroundView;
@property (nonatomic, retain) UIView *barView;
@property (nonatomic, retain) UILabel *scoreLabel;

- (void) configureWithScore:(NSInteger)score maxScore:(NSInteger)maxScore color:(UIColor *)color backgroundColor:(UIColor *)bgColor;

@end
