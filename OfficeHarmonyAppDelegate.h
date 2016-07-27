//
//  OfficeHarmonyAppDelegate.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SQLQuery.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreManager.h"
#import "BWQuincyManager.h"


@interface OfficeHarmonyAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, BWQuincyManagerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	NSInteger backgroundColor;
	BOOL _iapDownloadInProgress;
    NSString* _restoreTarget;
	UIAlertView *disclaimerAlert;
	UIAlertView *ratingAlert;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) NSInteger backgroundColor;
@property BOOL iapDownloadInProgress;
@property (nonatomic,assign) NSString* restoreTarget;
@property (nonatomic, retain) UIAlertView *disclaimerAlert;
@property (nonatomic, retain) UIAlertView *ratingAlert;


@end
