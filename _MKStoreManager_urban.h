//
//  StoreManager.h
//  MKSync
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 MK Inc. All rights reserved.
//  mugunthkumar.com

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"
#import "JSON.h"
#import "Constants.h"
#import "ZipArchive.h"
#import "OfficeHarmonyAppDelegate.h"

@protocol MKStoreKitDelegate <NSObject>
@optional
- (void)downloadStatus:(NSString *)status progress:(float)progress;
@end

@interface MKStoreManager : NSObject 
{
	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;
	NSMutableData *_rawData;
	SKPaymentTransaction *_transaction;
	NSFileHandle *_contentFileHandle;
	NSNumber *_filesize;
	NSNumber *_partialFilesize;
	id delegate;
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;
@property (nonatomic, retain) NSMutableData *rawData;
@property (nonatomic, retain) SKPaymentTransaction *transaction;
@property (nonatomic, retain) NSFileHandle *contentFileHandle;
@property (nonatomic, retain) NSNumber *filesize;
@property (nonatomic, retain) NSNumber *partialFilesize;
@property (nonatomic, retain) id<MKStoreKitDelegate> delegate;

//- (void) requestProductData;
- (void) buyFeature:(NSString*) featureId;
+ (MKStoreManager*)sharedManager;

//DELEGATES
+(id)delegate;	
+(void)setDelegate:(id)newDelegate;

@end
