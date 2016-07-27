//
//  TwitterReader.h
//  944Mag
//
//  Created by Bret Cowie on 4/27/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@protocol TwitterReaderDelegate <NSObject>

@required

-(void)twitterReaderDidFinishReadingTwitter:(NSArray *)twitter;

@end

@interface TwitterReader : NSObject <NSXMLParserDelegate> {
	@private
	Tweet *_tweetObject;
	NSMutableString *_contentOfTweetProperty;
	NSMutableArray *_twitter;
	NSMutableData *_rawData;
	id delegate;
}

@property (nonatomic, assign) id<TwitterReaderDelegate> delegate;
@property (nonatomic, retain) Tweet *tweetObject;
@property (nonatomic, retain) NSMutableString *contentOfTweetProperty;
@property (nonatomic, retain) NSMutableArray *twitter;
@property (nonatomic, retain) NSMutableData	 *rawData;

-(void)parseTwitterAtURL:(NSURL *)URL;

@end
