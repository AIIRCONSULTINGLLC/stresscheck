//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

/*
 Mind video:https://s3.amazonaws.com/com.urbanairship.content/content/YIAPWCJ8StqHH9L9szcU8g/com.kirschner.stresscheck.mind/1/content.zip?Signature=%2FQcKIhXytrepGSXLiEcCR8D6Iz0%3D&Expires=1363012580&AWSAccessKeyId=AKIAI2YI323R5IY4C2JA
 
            https://s3.amazonaws.com/com.urbanairship.content/content/YIAPWCJ8StqHH9L9szcU8g/com.kirschner.stresscheck.mind/1/content.zip?Signature=l8%2B2i9zh8KplEi4ozLqIG5iWExE%3D&Expires=1363460388&AWSAccessKeyId=AKIAI2YI323R5IY4C2JA
 
 
 Movement video:https://s3.amazonaws.com/com.urbanairship.content/content/YIAPWCJ8StqHH9L9szcU8g/com.kirschner.stresscheck.movement/1/content.zip?Signature=HlVrOK4MTp%2BlfGDr4Rv8bXZ2Sec%3D&Expires=1363012709&AWSAccessKeyId=AKIAI2YI323R5IY4C2JA
 */

#import "MKStoreObserver.h"
#import "MKStoreManager.h"

@implementation MKStoreObserver
@synthesize rawData = _rawData;
@synthesize contentFileHandle = _contentFileHandle;
@synthesize filesize = _filesize;
@synthesize partialFilesize = _partialFilesize;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",mainDelegate.restoreTarget);
	for (SKPaymentTransaction *transaction in transactions)
	{
        NSLog(@"%@, %ld", transaction, transaction.transactionState);
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
                NSLog(@"Purchased");
                if (transaction.downloads)
                {
                    [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    [[MKStoreManager sharedManager].delegate downloadStatus:@"Downloading content..." progress:0.0];
                    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                } else {
                    // Unlock feature or content here before
                    // finishing transaction
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }
                break;
				
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase Failed");
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored");
                /*if(mainDelegate.restoreTarget==nil)
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                else*/
                    [self restoreTransaction:transaction];
            default:
                break;
		}			
	}
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    for (SKDownload *download in downloads)
    {
        switch (download.downloadState) {
            case SKDownloadStateActive:
                NSLog(@"Download progress = %f",
                      download.progress);
                NSLog(@"Download time = %f",    
                      download.timeRemaining);
                [[MKStoreManager sharedManager].delegate downloadStatus:@"Downloading content..." progress:download.progress];
                break;
            case SKDownloadStateCancelled:
                NSLog(@"%@: download cancelled", download.contentIdentifier);
                [[SKPaymentQueue defaultQueue] finishTransaction:download.transaction];
                break;
            case SKDownloadStateFailed:

                NSLog(@"%@: download failed", download.contentIdentifier);
                NSLog(@"Error code: %@",[download.error localizedDescription]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[download.error localizedDescription] stringByAppendingString:@"  Please try again."]
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
                [[MKStoreManager sharedManager].delegate downloadStatus:@"Failed" progress:-1.0];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:download.transaction];
                break;
            case SKDownloadStatePaused:
                NSLog(@"%@: download paused", download.contentIdentifier);
                break;
            case SKDownloadStateFinished:
                // Download is complete. Content file URL is at
                // path referenced by download.contentURL. Move
                // it somewhere safe, unpack it and give the user
                // access to it
                NSLog(@"Temp file: %@",download.contentURL.path);
                [[MKStoreManager sharedManager].delegate downloadStatus:@"Installing..." progress:-1.0];
                [self downloadFinished:download];
                [[SKPaymentQueue defaultQueue] finishTransaction:download.transaction];
                break;
            default:
                break;
        }
    }
}

- (void)downloadFinished:(SKDownload *)download {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *contentPath = download.contentURL.path;
    contentPath = [contentPath stringByAppendingPathComponent:@"Contents"];
    NSError *error = nil;
    NSArray *files = [fm contentsOfDirectoryAtPath:contentPath error:&error];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //copy temporary download directory
    /*if (![fm copyItemAtPath:contentPath
                     toPath:documentsDirectory
                      error:&directoryError]) {
        NSLog(@"Error copying directory: %@, %d", download.contentURL.path, directoryError.code);
        //[self productInstallFailed:product];
        return;
    }*/
    
    for (NSString *file in files) {
        NSString *fullPathSrc = [contentPath stringByAppendingPathComponent:file];
        NSString *fullPathDst = [documentsDirectory stringByAppendingPathComponent:file];
        
        // not allowed to overwrite files - remove destination file
        [fm removeItemAtPath:fullPathDst error:NULL];
        
        if ([fm moveItemAtPath:fullPathSrc toPath:fullPathDst error:&error] == NO) {
            NSLog(@"Error: unable to move item: %@", error);
        }else{
            //[Utilities addSkipBackupAttributeToItemAtURL:movieURL];
            NSURL * fileURL = [ NSURL fileURLWithPath: fullPathDst ];
            [Utilities addSkipBackupAttributeToItemAtURL:fileURL];
        }
    }
    
    NSLog(@"Successfully installed %@", download.contentIdentifier);
    
    
    /* This command only works for jailbroken devices.
     NSString *cmd = [NSString stringWithFormat:@"unzip -o \"%@\" -d \"%@\"", path, documentsDirectory];
     system([cmd UTF8String]);
     */
    
    /*ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: destination]) {
        if(![za UnzipFileTo: documentsDirectory overWrite: YES])
            NSLog(@"Failed to unzip %@ to %@", destination, documentsDirectory);
        [za UnzipCloseFile];
    }
    [za release];
    NSLog(@"unzipped!");*/
    
    //Set iapDownloadInProgress flag to NO so that another IAP can happen now.
    OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
    mainDelegate.iapDownloadInProgress = NO;
    
    //Reveal the content!
    [[MKStoreManager sharedManager].delegate downloadStatus:@"Installation Complete." progress: -1.0];
    //[self productInstallSucceeded:product];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled){		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The upgrade procedure failed" message:@"Please check your Internet connection and your App Store account information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];	
    }	
	
	NSLog(@"Fallo - Observer");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[MKStoreManager sharedManager].delegate downloadStatus:@"Failed" progress:-1.0];
}

-(void) provideContent: (NSString*) productIdentifier withTransaction:(SKPaymentTransaction *)transaction
{
	//Format the receipt for sending to Urban Airship
	NSString* receipt = [[NSString alloc] initWithData: transaction.transactionReceipt encoding: NSUTF8StringEncoding];
	NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys: receipt, @"transaction_receipt", nil];
	SBJsonWriter *writer = [SBJsonWriter new];
	NSData *JSONdata = [[writer stringWithObject:data] dataUsingEncoding: NSUTF8StringEncoding];
	[writer release];
	
	//Form and send the request to Urban Airship
    NSString *url_Str= [NSString stringWithFormat:@"https://go.urbanairship.com/api/app/content/%@/download", productIdentifier];
    NSLog(@"Receipt: %@",receipt);
    NSLog(@"Receipt Json: %@",data);
    NSLog(@"Donwload Link: %@",url_Str);
	NSURL *url = [NSURL URLWithString:url_Str];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	[theRequest setValue:[NSString stringWithFormat:@"%d", [JSONdata length]] forHTTPHeaderField:@"Content-Length"];
	[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:JSONdata];
    NSLog(@"Request: %@",theRequest);
	mConnectionForGetLink = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if(mConnectionForGetLink) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		self.rawData = [[NSMutableData data] retain];
	} else {
		NSLog(@"theConnection is NULL");
    }

	//Close the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{		
	NSLog(@"Completo - Observer");
    //[self provideContent: transaction.payment.productIdentifier withTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
	NSLog(@"Restaurando - Observer");
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier withTransaction:transaction];
    if (transaction.downloads)
    {
        [[SKPaymentQueue defaultQueue] startDownloads:transaction.downloads];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[MKStoreManager sharedManager].delegate downloadStatus:@"Downloading content..." progress:0.0];
        //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    } else {
        // Unlock feature or content here before
        // finishing transaction
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"%d",queue.transactions.count);
    UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:@"Restore successful!"
												message:@""
												delegate:nil
												cancelButtonTitle:@"Ok"
												otherButtonTitles:nil]
                                                autorelease];
	[alertView show];    
}

- (void)paymentQueue:(SKPaymentQueue *)queue 
restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:@"Restore unsuccessful!"
														  message:@""
														 delegate:nil
												cancelButtonTitle:@"Ok"
												otherButtonTitles:nil]
							   autorelease];
	[alertView show];  
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSURLCredential *credential = [NSURLCredential credentialWithUser:@"YIAPWCJ8StqHH9L9szcU8g" password:@"OPCVPdFcRi6z4mdxKqOi0w" persistence:NSURLCredentialPersistenceNone];
	if([challenge previousFailureCount] == 0)
	{
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	}
	else
	{
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		NSLog(@"Could not authenticate because username and/or password were incorrect.");
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == mConnectionForGetLink) {
        [self.rawData setLength: 0];
    }
    else
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
        [[MKStoreManager sharedManager].delegate downloadStatus:@"Downloading content..." progress:0.0];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == mConnectionForGetLink) {
        [self.rawData appendData:data];
    }
    else
    {
        //Append data
        [self.contentFileHandle writeData:data];
        
        //Update progress view
        self.partialFilesize =[NSNumber numberWithInt:[self.partialFilesize intValue] + [data length]];
        float progress = [self.partialFilesize floatValue] / [self.filesize floatValue];
        if(progress < 0.99)
            [[MKStoreManager sharedManager].delegate downloadStatus:@"Downloading content..." progress:progress];
        else
            [[MKStoreManager sharedManager].delegate downloadStatus:@"Installing..." progress:-1.0];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//Release the connection.
	[connection release];
    
	//Tell the user what happened
	NSLog(@"Error with connection: %@", [error localizedDescription]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error localizedDescription] stringByAppendingString:@"  Please try again."]
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	[[MKStoreManager sharedManager].delegate downloadStatus:@"Failed" progress:-1.0];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == mConnectionForGetLink) {
        //Stop the network activity indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //Release the connection
        [connection release];
        
        //Parse the response to get the download link
        NSString *jsonString = [[NSString alloc] initWithData:self.rawData encoding:NSUTF8StringEncoding];
        SBJSON *jsonParser = [SBJSON new];
        id response = [jsonParser objectWithString:jsonString error:nil];
        NSDictionary *dictionary = (NSDictionary *)response;
        NSString *link = [dictionary objectForKey:@"content_url"];
        [jsonParser release];
        [jsonString release];
        
        //Pass the download link to MKStoreManager
        NSLog(@"Got the download link: %@  Now time to download it!", link);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
        
        mConnectionForDownloadZip = [[NSURLConnection alloc] initWithRequest:request delegate:self/*[MKStoreManager sharedManager]*/];
        if(mConnectionForDownloadZip)
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        else
            NSLog(@"Failed to start download");
    }
    else
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
        [[MKStoreManager sharedManager].delegate downloadStatus:@"Installation Complete." progress: -1.0];
    }
}

-(void) dealloc
{
	[self.rawData release];
	[super dealloc];
}

@end
