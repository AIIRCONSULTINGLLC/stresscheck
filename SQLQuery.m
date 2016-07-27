//
//  SQLQuery.m
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLQuery.h"


@implementation SQLQuery

@synthesize database;
@synthesize sqlStatement;

-(id) initWithQuery:(NSString *) sql
{
	// make sure we have a database
	// note this code is duplicated from app delegate, and should not be
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	NSString *dbPath = [documentFolderPath stringByAppendingPathComponent:kDatabaseName];
	if (dbPath == NULL)
		return nil;
	
	// open the database
	int dbrc;
	sqlite3 *db = self.database;
	if((dbrc = sqlite3_open([dbPath UTF8String], &db)) != 0)
	{	
		NSLog(@"failed to open database with error: %d", dbrc);
		return nil;
	}
	else
	{
		//NSLog(@"successfully opened database: %s", dbPath);
	}
	self.database = db;
	
	// prepare the select statement
	sqlite3_stmt *stmt = self.sqlStatement;
	if((dbrc = sqlite3_prepare_v2 (self.database, [sql UTF8String], -1, &stmt, NULL)) != 0)
	{
		NSLog(@"failed to prepare sqlStatement with error: %d", dbrc);
		NSLog(@"%@", sql);
		return nil;
	}
	else
	{
		//NSLog(@"successfully prepared sql statement:");
		//NSLog(sql);
	}
	self.sqlStatement = stmt;
	return self;
}

-(sqlite3_stmt *) nextRecord
{
	int dbrc;
	dbrc = sqlite3_step(self.sqlStatement);
	if(dbrc == SQLITE_ROW)
		return self.sqlStatement;
	else if(dbrc == SQLITE_DONE)
	{
		[self finalizeAndClose];
		return nil;
	}
	else
	{
		NSLog(@"failed to get next record with error: %d", dbrc);
		return nil;
	}
}

-(void) finalizeAndClose
{
	// done reading, close up
	sqlite3_finalize(self.sqlStatement);
	sqlite3_close(self.database);
}

-(void) dealloc
{
	self.database = nil;
	self.sqlStatement = nil;
	[super dealloc];
}

@end



