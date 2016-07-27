//
//  AdManager.h
//  OfficeHarmony
//
//  Created by Richard McClellan on 1/23/11.
//  Copyright 2011 Hurricane Party. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdManager : NSObject {
	id adBannerView;
	id queuedAdBannerView;
}
@property (nonatomic, assign) id adBannerView;
@property (nonatomic, assign) id queuedAdBannerView;

+ (id) sharedManager;
- (id) currentAdBannerView;

@end
