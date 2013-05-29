/*
 * Copyright (C) 2012 Buddy Platform, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"

@implementation BuddyCommerce

@synthesize client;
@synthesize authUser;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyCommerce"];
    
	self = [super init];
	if (!self)
	{
		return nil;
	}
    
	client = localClient;
	authUser = localAuthUser;
    
	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (NSArray *)makeReceiptList:(NSArray *)data
{
	NSMutableArray *receiptItemList = [[NSMutableArray alloc] init];
    
	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
                BuddyReceipt *receipt = [[BuddyReceipt alloc] initWithAuthUser:self.client authUser:self.authUser receiptDetails:dict];
				if (receipt)
				{
					[receiptItemList addObject:receipt];
				}
			}
		}
	}
	return receiptItemList;
}

- (void)processReceiptCallBack:(BuddyCallbackParams *)callbackParams data:(id)jsonArray callback:(BuddyCommerceGetReceiptsCallback)callback
{
    if (callback == nil)
    {
        return;
    }
    
    NSArray *receiptList;
    NSException *exception;
    @try
    {
        if (callbackParams.isCompleted && jsonArray != nil)
        {
            receiptList = [self makeReceiptList:jsonArray];
        }
    }
    @catch (NSException *ex)
    {
        exception = ex;
    }
    
    if (exception)
    {
        callback([[BuddyArrayResponse alloc] initWithError:exception
                                                   apiCall:callbackParams.apiCall]);
    }
    else
    {
        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams
                                                       result:receiptList]);
    }   
}

- (void)getReceiptsForUser:(NSDate *)fromDateTime
                  callback:(BuddyCommerceGetReceiptsCallback)callback
{
 	__block BuddyCommerce *_self = self;
    
    NSString *dateString = @"";
    if (fromDateTime)
    {
        dateString = [BuddyUtility buddyDateToString:fromDateTime];
    }
    
    [[client webService] Commerce_Receipt_GetForUser:authUser.token FromDateTime:dateString callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
                                                    {
                                                       [_self processReceiptCallBack:callbackParams data:jsonArray callback:callback];
                                                        _self = nil; 
                                                    } copy]];
}
                                                      
- (void)getReceiptForUserAndTransactionID:(NSString *)customTransactionID
                                 callback:(BuddyCommerceGetReceiptsCallback)callback
{
    if ([BuddyUtility isNilOrEmpty:customTransactionID])
    {
        [BuddyUtility throwNilArgException:@"BuddyCommerce" reason:@"customTransactionID"];
    }
    
	__block BuddyCommerce *_self = self;
    [[client webService] Commerce_Receipt_GetForUserAndTransactionID:authUser.token CustomTransactionID:customTransactionID callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
        {
           [_self processReceiptCallBack:callbackParams data:jsonArray callback:callback];
            _self = nil; 
        } copy]];
    
}

- (void)saveReceipt:(NSString *)totalCost
      totalQuantity:(int)totalQuantity
        storeItemID:(NSNumber *)storeItemID
          storeName:(NSString *)storeName 
        receiptData:(NSString *)receiptData
customTransactionID:(NSString *)customTransactionID
            appData:(NSString *)appData
           callback:(BuddyCommerceSaveReceiptCallback)callback
{
    if ([BuddyUtility isNilOrEmpty:totalCost])
    {
        [BuddyUtility throwNilArgException:@"BuddyCommerce" reason:@"totalCost"];
    }
    
    if ([BuddyUtility isNilOrEmpty:storeName])
    {
        [BuddyUtility throwNilArgException:@"BuddyCommerce" reason:@"storeName"];
    } 
    
    NSString *storeItemIDstring = [NSString stringWithFormat:@"%@", storeItemID];
    
    [[client webService] Commerce_Receipt_Save:authUser.token ReceiptData:receiptData CustomTransactionID:customTransactionID AppData:appData TotalCost:totalCost TotalQuantity:totalQuantity StoreItemID:storeItemIDstring StoreName:storeName callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
    {
        if (callback)
        {
            callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
        }
    } copy]];
}

- (void)saveReceipt:(NSString *)totalCost
      totalQuantity:(int)totalQuantity
        storeItemID:(NSNumber *)storeItemID
          storeName:(NSString *)storeName 
           callback:(BuddyCommerceSaveReceiptCallback)callback
{
    [self saveReceipt:totalCost totalQuantity:totalQuantity storeItemID:storeItemID storeName:storeName receiptData:nil customTransactionID:nil appData:nil callback:callback]; 
}

- (void)verifyiOSReceipt:(NSString *)totalCost
           totalQuantity:(int)totalQuantity
             receiptData:(NSString *)receiptData
              useSandbox:(BOOL)useSandbox
             appleItemID:(NSString *)appleItemID 
     customTransactionID:(NSString *)customTransactionID
                 appData:(NSString *)appData
                callback:(BuddyCommerceSaveReceiptCallback)callback
{
    [self internalVerifySaveiOSReceipt:kCommerce_Receipt_VerifyiOSReceipt
                             totalCost:totalCost totalQuantity:totalQuantity receiptData:receiptData useSandbox:useSandbox appleItemID:appleItemID customTransactionID:customTransactionID appData:appData callback:callback]; 
}

- (void)verifyiOSReceipt:(NSString *)totalCost
           totalQuantity:(int)totalQuantity
             receiptData:(NSString *)receiptData
              useSandbox:(BOOL)useSandbox
             appleItemID:(NSString *)appleItemID
                callback:(BuddyCommerceSaveReceiptCallback)callback
{
    [self verifyiOSReceipt:totalCost totalQuantity:totalQuantity receiptData:receiptData useSandbox:useSandbox appleItemID:appleItemID customTransactionID:nil appData:nil callback:callback];
}

- (void)verifyAndSaveiOSReceipt:(NSString *)totalCost
                  totalQuantity:(int)totalQuantity
                    receiptData:(NSString *)receiptData
                     useSandbox:(BOOL)useSandbox
                    appleItemID:(NSString *)appleItemID 
            customTransactionID:(NSString *)customTransactionID
                        appData:(NSString *)appData
                       callback:(BuddyCommerceSaveReceiptCallback)callback
{
    [self internalVerifySaveiOSReceipt:kCommerce_Receipt_VerifyAndSaveiOSReceipt
                             totalCost:totalCost totalQuantity:totalQuantity receiptData:receiptData useSandbox:useSandbox appleItemID:appleItemID customTransactionID:customTransactionID appData:appData callback:callback];
}

- (void)verifyAndSaveiOSReceipt:(NSString *)totalCost
                  totalQuantity:(int)totalQuantity
                    receiptData:(NSString *)receiptData
                     useSandbox:(BOOL)useSandbox
                    appleItemID:(NSString *)appleItemID
                       callback:(BuddyCommerceSaveReceiptCallback)callback
{
    [self verifyAndSaveiOSReceipt:totalCost totalQuantity:totalQuantity receiptData:receiptData useSandbox:useSandbox appleItemID:appleItemID customTransactionID:nil appData:nil callback:callback];
}

- (void)internalVerifySaveiOSReceipt:(NSString *)webServiceApi
                           totalCost:(NSString *)totalCost
                       totalQuantity:(int)totalQuantity
                         receiptData:(NSString *)receiptData
                          useSandbox:(BOOL)useSandbox
                         appleItemID:(NSString *)appleItemID
                 customTransactionID:(NSString *)customTransactionID
                             appData:(NSString *)appData
                            callback:(BuddyCommerceSaveReceiptCallback)callback
{
    if ([BuddyUtility isNilOrEmpty:totalCost])
    {
        [BuddyUtility throwNilArgException:@"BuddyCommerce" reason:@"totalCost"];
    }
    
    if ([BuddyUtility isNilOrEmpty:receiptData])
    {
        [BuddyUtility throwNilArgException:@"BuddyCommerce" reason:@"receiptData"];
    }
    
    NSString *isSandbox = useSandbox ? @"1" : @"0";
    
    NSMutableString *path = [[NSMutableString alloc] init];
	[path appendFormat:@"?%@", webServiceApi];
    
    NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                [BuddyUtility encodeValue:self.client.appName], @"BuddyApplicationName",
                                [BuddyUtility encodeValue:self.client.appPassword], @"BuddyApplicationPassword",
                                [BuddyUtility encodeValue:self.authUser.token], @"UserToken",
                                [BuddyUtility encodeValue:appleItemID], @"AppleItemID",
                                receiptData, @"ReceiptData",
                                [BuddyUtility encodeValue:customTransactionID], @"CustomTransactionID",
                                [BuddyUtility encodeValue:appData], @"AppData",
                                [BuddyUtility encodeValue:totalCost], @"TotalCost",
                                [BuddyUtility encodeValue:[NSString stringWithFormat:@"%d", totalQuantity]], @"TotalQuantity",
                                [BuddyUtility encodeValue:isSandbox], @"UseSandbox",
                                @"", @"RESERVED",
                                nil];
    
	[[self.client webService] directPost:webServiceApi
                                    path:path
                                  params:dictParams
                                callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
                                          {
                                              if (callback)
                                              {
                                                  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
                                              }
                                          } copy]];  
}

- (NSArray *)makeStoreItemList:(NSArray *)data
{
	NSMutableArray *storeItemList = [[NSMutableArray alloc] init];
    
	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
                BuddyStoreItem *storeItem = [[BuddyStoreItem alloc] initWithAuthUser:self.client authUser:self.authUser storeItemDetails:dict];
				if (storeItem)
				{
					[storeItemList addObject:storeItem];
				}
			}
		}
	}
	return storeItemList;
}

- (void)processCallBack:(BuddyCallbackParams *)callbackParams data:(id)jsonArray callback:(BuddyCommerceStoreItemsCallback)callback
{
    if (callback == nil)
    {
        return;
    }
    
    NSArray *storeItemList;
    NSException *exception;
    @try
    {
        if (callbackParams.isCompleted && jsonArray != nil)
        {
            storeItemList = [self makeStoreItemList:jsonArray];
        }
    }
    @catch (NSException *ex)
    {
        exception = ex;
    }

    if (exception)
    {
        callback([[BuddyArrayResponse alloc] initWithError:exception
                                                   apiCall:callbackParams.apiCall]);
    }
    else
    {
        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams
                                                       result:storeItemList]);
    }   
}

- (void)getAllStoreItems:(BuddyCommerceStoreItemsCallback)callback
{
  	__block BuddyCommerce *_self = self;
    
	[[client webService] Commerce_Store_GetAllItems:authUser.token
                                            callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
                                                    {
                                                       [_self processCallBack:callbackParams data:jsonArray callback:callback];
                                                        _self = nil;
                                                    } copy]];     
   
}

- (void)getActiveStoreItems:(BuddyCommerceStoreItemsCallback)callback
{
  	__block BuddyCommerce *_self = self;
    
	[[client webService] Commerce_Store_GetActiveItems:authUser.token
                                            callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
                                                      {
                                                        [_self processCallBack:callbackParams data:jsonArray callback:callback];
                                                         _self = nil;
                                                      } copy]];     
}

- (void)getFreeStoreItems:(BuddyCommerceStoreItemsCallback)callback
{
 	__block BuddyCommerce *_self = self;
    
	[[client webService] Commerce_Store_GetFreeItems:authUser.token callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													{
											           [_self processCallBack:callbackParams data:jsonArray callback:callback];
                                            			_self = nil;
													} copy]];   
}

@end