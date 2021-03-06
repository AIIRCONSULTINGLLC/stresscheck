//
//  ContactUsController.h
//  Malibu
//
//  Created by Richard McClellan on 6/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SQLQuery.h"
@interface ContactUsController : UIViewController {
	NSArray *_contactLinks;
	UIButton *_websiteButton;
}

@property(nonatomic, retain) NSArray *contactLinks;
@property(nonatomic, retain) IBOutlet UIButton *websiteButton;

-(IBAction)linkClick:(id)sender;
-(IBAction)officeHarmonyClick:(id)sender;
@end
