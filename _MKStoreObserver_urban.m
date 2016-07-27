//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import "MKStoreObserver.h"
#import "MKStoreManager.h"

@implementation MKStoreObserver

@synthesize rawData = _rawData;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchasing:
				NSLog(@"App Store replied with state SKPaymentTransactionStatePurchasing");
				break;
			case SKPaymentTransactionStatePurchased:
				NSLog(@"App Store replied with state SKPaymentTransactionStatePurchased");
                [self provideContent: transaction.payment.productIdentifier withTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
				NSLog(@"App Store replied with state SKPaymentTransactionStateRestored");
				[self provideContent: transaction.originalTransaction.payment.productIdentifier withTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				NSLog(@"App Store replied with state SKPaymentTransactionStateFailed");
				[self failedTransaction:transaction];
                break;
            default:
                break;
		}
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	// Update the iapDownloadInProgress flag to indicate that the download was cancelled.
	OfficeHarmonyAppDelegate *mainDelegate = (OfficeHarmonyAppDelegate *)[[UIApplication sharedApplication] delegate];
	mainDelegate.iapDownloadInProgress = NO;
	
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
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://go.urbanairship.com/api/app/content/%@/download", productIdentifier]];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	[theRequest setValue:[NSString stringWithFormat:@"%d", [JSONdata length]] forHTTPHeaderField:@"Content-Length"];
	[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:JSONdata];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if(theConnection) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		self.rawData = [[NSMutableData data] retain];
	} else {
		NSLog(@"theConnection is NULL");
    }
    
	//Close the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
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
	[self.rawData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.rawData appendData:data];
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
	
	NSURLConnection *connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:[MKStoreManager sharedManager]];
	if(connection2)
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	else
		NSLog(@"Failed to start download");

}

-(void) dealloc
{
	[self.rawData release];
	[super dealloc];
}

@end
