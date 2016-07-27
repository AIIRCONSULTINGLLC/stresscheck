//
//  QuizRecord.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/12/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuizRecord : NSObject {
	NSInteger quizId;
	NSNumber *generalScore;
	NSDate *date;
	NSMutableArray *domainNames;
 	NSMutableArray *domainScores;
	NSMutableArray *domainIds;
	NSString *generalResponseText;
	UIColor *generalResponseColor;
	NSString *domainResponsePrefix;
	NSString *domainResponseText;
}

@property (nonatomic, assign) NSInteger quizId;
@property (nonatomic, retain) NSNumber *generalScore;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSMutableArray *domainNames;
@property (nonatomic, retain) NSMutableArray *domainScores;
@property (nonatomic, retain) NSMutableArray *domainIds;
@property (nonatomic, retain) NSString *generalResponseText;
@property (nonatomic, retain) UIColor *generalResponseColor;
@property (nonatomic, retain) NSString *domainResponsePrefix;
@property (nonatomic, retain) NSString *domainResponseText;

- (id) initWithCurrentQuiz;
+ (void) resetCurrentQuiz;
- (void) deleteFromHistory;
- (void) saveToHistory;
+ (NSArray *) allQuizRecords;

@end
