#import <UIKit/UIKit.h>

typedef enum
	{
		VerticalAlignmentTop = 0, // default
		VerticalAlignmentMiddle,
		VerticalAlignmentBottom,
	} VerticalAlignment;

@interface UILabel2 : UILabel
{
@private
	VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
