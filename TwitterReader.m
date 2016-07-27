//
//  TwitterReader.m
//  944Mag
//
//  Created by Bret Cowie on 4/27/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import "TwitterReader.h"

static NSUInteger tweetCounter;

@implementation TwitterReader

@synthesize tweetObject = _tweetObject;
@synthesize contentOfTweetProperty = _contentOfTweetProperty;
@synthesize twitter = _twitter;
@synthesize delegate;
@synthesize rawData = _rawData;

#define MAX_STORIES 10

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
	tweetCounter = 0;
	self.twitter = [[NSMutableArray alloc] init];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
	if(tweetCounter == 0)
	{
		self.tweetObject.title = @"Could not get twitter.";
		self.tweetObject.pubDate = @"";
		
		NSLog(@"Could not get twitter.");
	}
	NSLog(@"%@", self.twitter);
	[self.delegate twitterReaderDidFinishReadingTwitter:self.twitter];
}

-(void)parseTwitterAtURL:(NSURL *)URL
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
	
	[parser release];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if(qName)
	{
		elementName = qName;
	}
	
	if(tweetCounter >= MAX_STORIES)
	{
		//done parsing method here
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[self.delegate twitterReaderDidFinishReadingTwitter:self.twitter];
		NSLog(@"%@", self.twitter);
		[parser abortParsing];
		return;
	}
	
	if([elementName isEqualToString:@"item"])
	{
		self.tweetObject = [[[Tweet alloc] init] autorelease];
		return;
	}
	
	if([elementName isEqualToString:@"title"])
	{
		self.contentOfTweetProperty = [NSMutableString string];
	}
	else if([elementName isEqualToString:@"pubDate"])
	{
		self.contentOfTweetProperty = [NSMutableString string];
	}
	else
	{
		self.contentOfTweetProperty = nil;
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if(qName)
	{
		elementName = qName;
	}
	
	if([elementName isEqualToString:@"item"])
	{
		tweetCounter++;
		[self.twitter addObject:self.tweetObject];
	}
	
	if([elementName isEqualToString:@"title"])
	{
		self.tweetObject.title = self.contentOfTweetProperty;
	}
	else if([elementName isEqualToString:@"pubDate"])
	{
		self.tweetObject.pubDate = self.contentOfTweetProperty;
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//NSLog(@"Found chars: %@", string);
	if(self.contentOfTweetProperty)
	{
		[self.contentOfTweetProperty appendString:string];
	}
}

-(void)dealloc
{
	self.twitter = nil;
	self.tweetObject = nil;
	self.contentOfTweetProperty = nil;
	self.rawData = nil;
	[super dealloc];
}

/*
#pragma mark -
#pragma mark NSURLConnection delegate methods

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Done, Received Bytes: %d", [self.rawData length]);
	NSLog(@"Raw data %@", self.rawData);

	[connection release];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.rawData setLength:0];
	NSLog(@"Connection did receive response");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.rawData appendData:data];
	NSLog(@"Connection did receive data");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Connection Error: %@", [error localizedDescription]);
	[self.rawData release];
}*/

@end
