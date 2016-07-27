//
//  Utilities.m
//  OfficeHarmony
//
//  Created by EricLouis on 12/15/14.
//
//

#import "Utilities.h"

@implementation Utilities

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    @try {
        //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
        {
            NSError *error = nil;
            BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                          forKey: NSURLIsExcludedFromBackupKey error: &error];
            if(!success){
                NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
            }
            return success;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
    }
    return false;
}
@end
