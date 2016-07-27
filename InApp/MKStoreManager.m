//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"

extern NSString* meditationId;
extern NSString* movementId;

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
@synthesize rawData = _rawData;
@synthesize transaction = _transaction;
@synthesize delegate;

static __weak id<MKStoreKitDelegate> _delegate;
//static MKStoreManager* _sharedStoreManager; // self


- (void)dealloc {
//	[_sharedStoreManager release];
	[storeObserver release];
    [self.rawData release];
	[self.transaction release];
	[super dealloc];
}


+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;
}

+ (MKStoreManager *)sharedManager
{
//	@synchronized(self) {
//		
//        if (_sharedStoreManager == nil) {
//
//            [[self alloc] init]; // assignment not done here
//			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];
//			[_sharedStoreManager requestProductData];
//			
//			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
//			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
//        }
//    }
//    return _sharedStoreManager;
    __strong static MKStoreManager* _sharedStoreManager = nil ;
	static dispatch_once_t onceToken ;
    
	dispatch_once( &onceToken, ^{
        _sharedStoreManager = [ [ MKStoreManager alloc ] init ] ;
        _sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];
        [_sharedStoreManager requestProductData];

        _sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
	} ) ;
    
    return _sharedStoreManager ;
}

#pragma mark Singleton Methods

//+ (id)allocWithZone:(NSZone *)zone
//
//{	
//    @synchronized(self) {
//		
//        if (_sharedStoreManager == nil) {
//			
//            _sharedStoreManager = [super allocWithZone:zone];			
//            return _sharedStoreManager;  // assignment and return on first allocation
//        }
//    }
//	
//    return nil; //on subsequent allocation attempts return nil	
//}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: meditationId , movementId, nil]]; // add any other product here
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
        
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);  
	}
	
	[request autorelease];
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (void) buyMeditation
{
	[self buyFeature:meditationId];
}

- (void) buyMovement
{
	[self buyFeature:movementId];
}

- (void)restoreAllPurchases
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
