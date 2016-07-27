//
//  Question.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject {
	NSString *_prompt;
	NSMutableArray *_answers;
	NSMutableArray *_pointValues;
	NSUInteger _questionState;
	NSNumber *_questionDomain;
}

@property (nonatomic, retain) NSString *prompt;
@property (nonatomic, retain) NSMutableArray *answers;
@property (nonatomic, retain) NSMutableArray *pointValues;
@property (nonatomic, retain) NSNumber *questionDomain;
@property NSUInteger questionState;

@end
