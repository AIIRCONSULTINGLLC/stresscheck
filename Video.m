//
//  Video.m
//  PVonneVideos
//
//  Created by Kris Pena on 5/14/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import "Video.h"


@implementation Video
@synthesize title = _title;
@synthesize description = _description;
@synthesize thumbnailFilename = _thumbnailFilename;
@synthesize videoPath = _videoPath;
@synthesize mediaType = _mediaType;
@synthesize mediaLength = _mediaLength;
@synthesize mediaCategory = _mediaCategory;
@synthesize warning = _warning;

-(void)dealloc
{
	[self.title release];
	[self.description release];
	[self.thumbnailFilename release];
	[self.videoPath release];
	[self.mediaType release];
	[self.mediaLength release];
	[self.mediaCategory release];
	[self.warning release];
	[super dealloc];
}

@end
