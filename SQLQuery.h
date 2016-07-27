//
//  SQLQuery.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Constants.h"

@interface SQLQuery : NSObject {
	sqlite3 *database;
	sqlite3_stmt *sqlStatement;
}

@property sqlite3 *database;
@property sqlite3_stmt *sqlStatement;

-(id) initWithQuery:(NSString *)sql;
-(sqlite3_stmt *) nextRecord;
-(void) finalizeAndClose;
@end