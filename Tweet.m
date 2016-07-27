//
//  Tweet.m
//  944Mag
//
//  Created by Bret Cowie on 4/27/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

@synthesize title = _title;
@synthesize pubDate = _pubDate;

-(void)setTitle:(NSString *)newTitle
{
	[newTitle retain];
	[_title release];
	_title = newTitle;
}

-(void)setPubDate:(NSString *)newPubDate
{
	[newPubDate retain];
	[_pubDate release];
	_pubDate = newPubDate;
}

-(void)dealloc
{
	self.title = nil;
	self.pubDate = nil;
	[super dealloc];
}

@end
