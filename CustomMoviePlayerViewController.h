//
//  CustomMoviePlayerViewController.h
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Utilities.h"

@interface CustomMoviePlayerViewController : UIViewController 
{
  MPMoviePlayerController *mp;
  NSURL 									*movieURL;
}

- (id)initWithFilename:(NSString *)filename extension:(NSString *)extension;
- (void)readyPlayer;

@end
