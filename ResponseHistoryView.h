//
//  ResponseHistoryView.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/17/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseView.h"
#import <QuartzCore/QuartzCore.h>

@interface ResponseHistoryView : UIView {
	ResponseView *responseView;
	UILabel *dateLabel;
}

@property (nonatomic, retain) ResponseView *responseView;
@property (nonatomic, retain) UILabel *dateLabel;

- (void) configureWithScore:(NSInteger)score maxScore:(NSInteger)maxScore color:(UIColor *)color date:(NSDate *)date;

@end
