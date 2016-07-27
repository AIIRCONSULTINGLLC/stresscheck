//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Utilities.h"

@interface MKStoreObserver : NSObject<SKPaymentTransactionObserver> {
    NSMutableData *_rawData;
    
    NSURLConnection* mConnectionForGetLink;
    NSURLConnection* mConnectionForDownloadZip;
    
    NSFileHandle *_contentFileHandle;
	NSNumber *_filesize;
	NSNumber *_partialFilesize;
}

@property (nonatomic, retain) NSMutableData *rawData;

@property (nonatomic, retain) NSFileHandle *contentFileHandle;
@property (nonatomic, retain) NSNumber *filesize;
@property (nonatomic, retain) NSNumber *partialFilesize;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

@end
