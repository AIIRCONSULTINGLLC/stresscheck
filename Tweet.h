//
//  Tweet.h
//  944Mag
//
//  Created by Bret Cowie on 4/27/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
	@private
	NSString *_title;
	NSString *_pubDate;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *pubDate;

@end
