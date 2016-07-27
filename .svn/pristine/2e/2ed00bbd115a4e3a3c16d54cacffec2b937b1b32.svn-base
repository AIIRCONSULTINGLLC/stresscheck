//
//  Question.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Question.h"


@implementation Question

@synthesize prompt = _prompt;
@synthesize answers = _answers;
@synthesize pointValues = _pointValues;
@synthesize questionState = _questionState;
@synthesize questionDomain = _questionDomain;

-(id) init
{
	if(self = [super init]) {
		self.answers = [[NSMutableArray alloc] init];
		self.pointValues = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
	[self.prompt release];
	[self.answers release];
	[self.pointValues release];
	[self.questionDomain release];
	[super dealloc];
	
}

@end
