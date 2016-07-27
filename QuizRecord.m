//
//  QuizRecord.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/12/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import "QuizRecord.h"
#import "SQLQuery.h"
#import "UIColor-HSVAdditions.h"

@interface QuizRecord (Private)

- (void) getGeneralResponse;
- (void) getDetailedResponse;

@end


@implementation QuizRecord

@synthesize quizId;
@synthesize generalScore;
@synthesize date;
@synthesize domainNames;
@synthesize domainScores;
@synthesize domainIds;
@synthesize generalResponseText;
@synthesize generalResponseColor;
@synthesize domainResponsePrefix;
@synthesize domainResponseText;


- (void) dealloc {
	[self.generalScore release];
	[self.date release];
	[self.domainNames release];
	[self.domainScores release];
	[self.domainIds release];
	[self.generalResponseText release];
	[self.domainResponsePrefix release];
	[self.domainResponseText release];
	[super dealloc];
}

- (id) init {
	if((self = [super init])) {
		self.quizId = -1;
		self.domainNames = [NSMutableArray array];
		self.domainScores = [NSMutableArray array]; 
		self.domainIds = [NSMutableArray array];
	}
	return self;
}

- (id) initWithCurrentQuiz {
	if((self = [self init])) {
		// Initialize variables
		NSString *sql;
		SQLQuery *query;
		sqlite3_stmt *sqlStatement;
		
		//Compute total stress score
		sql = @"SELECT SUM(Answers.pointValue) FROM Questions ";
		sql = [sql stringByAppendingString:@"JOIN QuestionAnswer ON QuestionAnswer.questionId = Questions.id "];
		sql = [sql stringByAppendingString:@"JOIN Answers ON QuestionAnswer.answerId = Answers.id "];
		sql = [sql stringByAppendingString:@"WHERE Questions.questionState = QuestionAnswer.displayOrder "];
		query = [[SQLQuery alloc] initWithQuery:sql];
		while((sqlStatement = [query nextRecord]) != nil) {
			self.generalScore = [NSNumber numberWithDouble: (double)sqlite3_column_int (sqlStatement, 0)];
		}
		
		// Get general response
		[self getGeneralResponse];
		
		// Get domain scores
		sql = @"SELECT  Domains.name, Questions.domainId, SUM(Answers.pointValue) FROM Questions ";
		sql = [sql stringByAppendingString:@"JOIN QuestionAnswer ON QuestionAnswer.questionId = Questions.id "];
		sql = [sql stringByAppendingString:@"JOIN Answers ON QuestionAnswer.answerId = Answers.id "];
		sql = [sql stringByAppendingString:@"JOIN Domains ON Domains.id = Questions.domainId "];
		sql = [sql stringByAppendingString:@"WHERE Questions.questionState = QuestionAnswer.displayOrder "];
		sql = [sql stringByAppendingString:@"GROUP BY Questions.domainId"];
		[query release];
        
        query = [[SQLQuery alloc] initWithQuery:sql];
		while((sqlStatement = [query nextRecord]) != nil) {
			[self.domainNames addObject:[[[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 0)] autorelease]];
			int domainId = sqlite3_column_int (sqlStatement, 1);
			int score = sqlite3_column_int (sqlStatement, 2);
			NSLog(@"score: %d  domainId: %d", score, domainId);
			[self.domainIds addObject:[NSNumber numberWithInt:domainId]];
			[self.domainScores addObject:[NSNumber numberWithInt:score]];
		}
		[query release];
		// Get detailed response
		[self getDetailedResponse];
				
		// Set date to current date
		self.date = [NSDate date];
	}
	return self;
}

- (void) getGeneralResponse {
	NSString *sql = @"SELECT responseText, detailPrefix, responseColor, maxThreshold FROM GeneralResponses WHERE ";
	sql = [sql stringByAppendingFormat:@"%d<=maxThreshold ORDER BY maxThreshold DESC",[self.generalScore intValue]];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil) {
		self.generalResponseText = [[[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 0)] autorelease];
		self.domainResponsePrefix = [[[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 1)] autorelease];
		NSString *colorString = [[[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 2)] autorelease];
		self.generalResponseColor = [UIColor colorWithHexString:colorString];
	}
	[query release];
}

- (void) getDetailedResponse {
	// The responses in the DetailedResponses table are arranged so that the binary representation of the id indicates which domains are included.
	// To figure out the id of the detailed response to be displayed, we will pack together as many bits as there are domains, such that
	// bit 0 is on if the domain 1 point value sum is the highest or tied with the highest,
	// bit 1 is on if the domain 2 point value sum is the highest or tied with the highest,
	// etc.  The resulting integer, or the specificResponseId can be used to directly look up the appropriate response.	
	unsigned int specificResponseId = 0;
	for(int i=0;i<[self.domainScores count];i++) {
		int domainId = [[self.domainIds objectAtIndex:i] intValue];
		int score = [[self.domainScores objectAtIndex:i] intValue];
		if(score >= ([self.generalScore floatValue] / 4.0)) {
			specificResponseId |= (1 << (domainId - 1));
		}
	}
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:[NSString stringWithFormat:@"SELECT responseText FROM SpecificResponses WHERE id=%d", specificResponseId]];
	sqlite3_stmt *sqlStatement;
	while((sqlStatement = [query nextRecord]) != nil) {
		self.domainResponseText = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 0)];
	}
    [query release];
	self.domainResponseText = [self.domainResponsePrefix stringByAppendingString:self.domainResponseText];	
}

+ (void) resetCurrentQuiz {
	//Reset all the previously selected choices
	NSString *sql = [NSString stringWithFormat:@"UPDATE Questions SET questionState=0"];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	while([query nextRecord] != nil);
	[query release];
}

- (void) saveToHistory {
	// Initialize constants
	SQLQuery *query;
	NSString *sql;
	sqlite3_stmt *sqlStatement;
	
	// Insert the general score
	sql = [NSString stringWithFormat:@"INSERT INTO UserRecords (date,generalScore) VALUES (%d,%d)", 
					 (int)[self.date timeIntervalSince1970], [self.generalScore intValue]];
	query = [[SQLQuery alloc] initWithQuery:sql];
	while(([query nextRecord]) != nil);
	[query release];
		
	// Get the record id
	NSInteger recordId = 0;
	sql = [NSString stringWithFormat:@"SELECT id FROM UserRecords WHERE date=%d",  (int)[self.date timeIntervalSince1970]];
	query = [[SQLQuery alloc] initWithQuery:sql];
	while ((sqlStatement = [query nextRecord])) {
		recordId = sqlite3_column_int(sqlStatement, 0);
	}
	[query release];
	
	// Insert the domain scores
	for(int i=0;i<[self.domainScores count];i++) {
		sql = [NSString stringWithFormat:@"INSERT INTO UserDomainScores (recordId,domainId,domainScore) VALUES (%d,%d,%d)", 
					 recordId, [[self.domainIds objectAtIndex:i] intValue], [[self.domainScores objectAtIndex:i] intValue]];
		query = [[SQLQuery alloc] initWithQuery:sql];
		while(([query nextRecord]));
		[query release];
	}
}

- (void) deleteFromHistory {
	SQLQuery *query;	
	query = [[SQLQuery alloc] initWithQuery:[NSString stringWithFormat:@"DELETE FROM UserRecords WHERE id=%d", self.quizId]];
	while([query nextRecord]);
	[query release];
	
	query = [[SQLQuery alloc] initWithQuery:[NSString stringWithFormat:@"DELETE FROM UserDomainScores WHERE recordId=%d", self.quizId]];
	while([query nextRecord]);
	[query release];
}

+ (NSArray *) allQuizRecords {
	NSMutableArray *records = [NSMutableArray array];
	NSString *sql = @"SELECT UserRecords.id, UserRecords.date, UserRecords.generalScore, UserDomainScores.domainId, UserDomainScores.domainScore, Domains.name";
	sql = [sql stringByAppendingString:@" FROM UserRecords JOIN UserDomainScores ON UserDomainScores.recordId=UserRecords.id"];
	sql = [sql stringByAppendingString:@" JOIN Domains on UserDomainScores.domainId=Domains.id"];
	sql = [sql stringByAppendingString:@" ORDER BY UserRecords.id DESC"];
	SQLQuery *query = [[SQLQuery alloc] initWithQuery:sql];
	sqlite3_stmt *sqlStatement;
	QuizRecord *record = [[QuizRecord alloc] init];
	while((sqlStatement = [query nextRecord])) {
		NSInteger recordId = sqlite3_column_int(sqlStatement, 0);
		if(record.quizId != recordId) {
			if(record.quizId != -1) {
				[record getDetailedResponse];
				[records addObject:record];
			}
			[record release];
			record = [[QuizRecord alloc] init];
			record.quizId = recordId;
			record.date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(sqlStatement, 1)];
			record.generalScore = [NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 2)];
			[record getGeneralResponse];
		}
		[record.domainIds addObject:[NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 3)]];
		[record.domainScores addObject:[NSNumber numberWithInt:sqlite3_column_int(sqlStatement, 4)]];
		[record.domainNames addObject:[[[NSString alloc] initWithCString:(char *)sqlite3_column_text(sqlStatement, 5)] autorelease]];
	}
	[record getDetailedResponse];
	[records addObject:record];
	[record release];
	[query release];
	
	return (NSArray *)records;
}

@end
