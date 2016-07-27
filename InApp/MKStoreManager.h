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

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;
    
    NSMutableData *_rawData;
	SKPaymentTransaction *_transaction;
	id delegate;
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;
@property (nonatomic, retain) NSMutableData *rawData;
@property (nonatomic, retain) SKPaymentTransaction *transaction;
@property (nonatomic, assign) id<MKStoreKitDelegate> delegate;

//- (void) requestProductData;
- (void) buyFeature:(NSString*) featureId;
- (void)restoreAllPurchases;
+ (MKStoreManager*)sharedManager;

//DELEGATES
+(id)delegate;
+(void)setDelegate:(id)newDelegate;

@end
