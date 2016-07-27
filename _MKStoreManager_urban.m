//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 15-Nov-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"


@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
@synthesize rawData = _rawData;
@synthesize transaction = _transaction;
@synthesize contentFileHandle = _contentFileHandle;
@synthesize filesize = _filesize;
@synthesize partialFilesize = _partialFilesize;
@synthesize delegate;

static __weak id<MKStoreKitDelegate> _delegate;
static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[self.rawData release];
	[self.transaction release];
	[super dealloc];
}

//- (id) retain {
//    return [super retain];
//}
//
//- (void) release {
//    [super release];
//}

+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

+ (MKStoreManager *)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			//[_sharedStoreManager requestProductData];
			
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
    @synchronized(self) {
        if (_sharedStoreManager == nil) {
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain {	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

- (void) buyFeature:(NSString*) featureId
{
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MKStoreKit" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//Determine path to save content
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *fileName = @"content";
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	path = [path stringByAppendingPathExtension:@"zip"];
	
	//Delete the file if it already exists
	if([[NSFileManager defaultManager] fileExistsAtPath:path])
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	
	//Create the file and open the file handle.
	[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
	self.contentFileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	
	//Set up the filesize variables to calculate progress.
	self.partialFilesize = [NSNumber numberWithInt:0];
	self.filesize = [NSNumber numberWithLongLong:[response expectedContentLength]];
	
	//Update UI
	[self.delegate downloadStatus:@"Downloading content..." progress:0.0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	//Append data
    [self.contentFileHandle writeData:data];
	
	//Update progress view
	self.partialFilesize =[NSNumber numberWithInt:[self.partialFilesize intValue] + [data length]];
	float progress = [self.partialFilesize floatValue] / [self.filesize floatValue];
	if(progress < 0.99)
		[self.delegate downloadStatus:@"Downloading content..." progress:progress];
	else
		[self.delegate downloadStatus:@"Installing..." progress:-1.0];	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

	
	//Release the connection
	[connection release];
	
	//Tell the user what happened
	NSLog(@"Error with connection: %@", [error localizedDescription]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error localizedDescription] stringByAppendingString:@"  Please try again."]
																					delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	[self.delegate downloadStatus:@"Failed" progress:-1.0];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//Close the connection
	[connection release];
	
	//Close the file
	[self.contentFileHandle closeFile];
	
	//Get path of zip file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"content";
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	path = [path stringByAppendingPathExtension:@"zip"];
	
	//Unzip it!
	NSLog(@"unzipping %@ to %@", path, documentsDirectory);
	
	/* This command only works for jailbroken devices.
	NSString *cmd = [NSString stringWithFormat:@"unzip -o \"%@\" -d \"%@\"", path, documentsDirectory];
    system([cmd UTF8String]); 
	*/
	
	ZipArchive *za = [[ZipArchive alloc] init];
	if ([za UnzipOpenFile: path]) {
		if(![za UnzipFileTo: documentsDirectory overWrite: YES])
			NSLog(@"Failed to unzip %@ to %@", path, documentsDirectory);
		[za UnzipCloseFile];
	}
	[za release];
	NSLog(@"unzipped!");
	
	//Set iapDownloadInProgress flag to NO so that another IAP can happen now.
	OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
	mainDelegate.iapDownloadInProgress = NO;
	
	//Reveal the content!
	[self.delegate downloadStatus:@"Installation Complete." progress: -1.0];
}



@end
