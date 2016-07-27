//
//  Video.h
//  PVonneVideos
//
//  Created by Kris Pena on 5/14/09.
//  Copyright 2009 AVAI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Video : NSObject {
	NSString *_title;
	NSString *_description;
	NSString *_thumbnailFilename;
	NSString *_videoPath;
	NSString *_mediaType;
	NSString *_mediaLength;
	NSString *_mediaCategory;
	NSString *_warning;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *thumbnailFilename;
@property (nonatomic, retain) NSString *videoPath;
@property (nonatomic, retain) NSString *mediaType;
@property (nonatomic, retain) NSString *mediaLength;
@property (nonatomic, retain) NSString *mediaCategory;
@property (nonatomic, retain) NSString *warning;

@end
