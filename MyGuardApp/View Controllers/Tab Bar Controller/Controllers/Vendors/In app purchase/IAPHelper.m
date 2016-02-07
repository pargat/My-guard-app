//
//  IAPHelper.m
//  Gyde
//
//  Created by CB Macmini_3 on 02/07/15.
//  Copyright (c) 2015 CB Macmini_3. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
NSString *const IAPHelperProductPurchaseNotification = @"IAPHelperProductPurchaseNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    SKProductsRequest *productRequest;
    RequestProductCompletionHandler _completionHandler;
    NSSet *_productIdentifiers;
    NSMutableSet *_purchasedProductIdentifier;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers  {
    
    if (self == [super init]) {
        //storing product identifiers
        _productIdentifiers =  productIdentifiers;
        
        //check for previous purchased products
        _purchasedProductIdentifier = [NSMutableSet set];
        for (NSString *strPro_Identifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:strPro_Identifier];
            if (productPurchased) {
                [_purchasedProductIdentifier addObject:strPro_Identifier];
                NSLog(@"Previously Purchased:%@",strPro_Identifier);
            }
            else {
                NSLog(@"not puchased:%@",strPro_Identifier);
            }
        }
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return self;
}

- (void)requestProductWithCompletionHandler:(RequestProductCompletionHandler)completionHandler {
    _completionHandler = [completionHandler copy];
    productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    productRequest.delegate = self;
    [productRequest start];
}

#pragma mark - skproductRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"Loading list of products");
    productRequest = nil;
    
    NSArray *skProduct = response.products;
    for (SKProduct *sk_product in skProduct) {
        NSLog(@"found proditcs:%@ %@ %0.2f",sk_product.productIdentifier
              ,sk_product.localizedTitle,
              sk_product.price.floatValue);
    }
    if(_completionHandler!=nil)
    {
        _completionHandler (YES, skProduct);
        _completionHandler = nil;
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [Utility alert:@"" msg:@"Failed to load products"];
    NSLog(@"failed to load products");
    productRequest = nil;
    if(_completionHandler!=nil)
    _completionHandler (NO, nil);
    _completionHandler = nil;
}

- (BOOL)product_purchased:(NSString *)product_Identifiers {
    return [_purchasedProductIdentifier containsObject:product_Identifiers];
}

- (void)buy_Product:(SKProduct *)product {
    NSLog(@"buying:%@",product.productIdentifier);
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *payment_transation in transactions) {
        switch (payment_transation.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransection:payment_transation];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTrasaction:payment_transation];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:payment_transation];
                break;
                
            default:
                break;
        }
    }
    
}

- (void)completeTransection:(SKPaymentTransaction *)transaction {
    NSLog(@"complte Transaction");
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [self provideContentForProduct_Identifier:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"in_app" object:transaction.payment.productIdentifier];
    if([transaction.payment.productIdentifier isEqualToString:INAPP_FIRE_ID])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"fire_in"];
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KBuyFireApi,KbaseUrl,[Profile getCurrentProfileUserId]] success:^(NSDictionary *responseDict) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"fire_in"];
            Profile *prof = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
            prof.profileFireBuy = @"1";
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:prof forKey:@"profile"];        } failure:^(NSString *errorString) {
                
            }];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:INAPP_SEX_ID])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"sex_in"];
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KBuyFireApi,KbaseUrl,[Profile getCurrentProfileUserId]] success:^(NSDictionary *responseDict) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"sex_in"];
            Profile *prof = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
            prof.profileSexBuy = @"1";
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:prof forKey:@"profile"];
        } failure:^(NSString *errorString) {
            
        }];
        
    }
    else if ([transaction.payment.productIdentifier isEqualToString:INAPP_CO_ID])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"co_in"];
        [iOSRequest getJsonResponse:[NSString stringWithFormat:KBuyCOApi,KbaseUrl,[Profile getCurrentProfileUserId]] success:^(NSDictionary *responseDict) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"co_in"];
            Profile *prof = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"profile"];
            prof.profileCOBuy = @"1";
            [[NSUserDefaults standardUserDefaults] rm_setCustomObject:prof forKey:@"profile"];
        } failure:^(NSString *errorString) {
            
        }];

    }
    //[Utility alert:@"" msg:@"Trasaction is completed"];
}

- (void)restoreTrasaction:(SKPaymentTransaction *)transection {
    NSLog(@"restored Transaction");
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [self provideContentForProduct_Identifier:transection.originalTransaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transection];
    [self.delegate delhideLoader];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"in_app" object:nil];
    
    NSLog(@"Failed Trasaction");
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [Utility alert:@"Purchase Unsuccessful" msg:@"Your Purchase failed.Please try again"];
        NSLog(@"Trasaction error :%@",transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)provideContentForProduct_Identifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifier addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchaseNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
