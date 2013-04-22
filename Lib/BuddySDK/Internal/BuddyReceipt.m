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
#import "BuddyUtility.h"


@implementation BuddyReceipt

@synthesize client;
@synthesize authUser;
@synthesize receiptHistoryId;
@synthesize storeName;
@synthesize userId;
@synthesize historyDateTime;
@synthesize receiptData;
@synthesize totalCost;
@synthesize itemQuantity;
@synthesize appData;
@synthesize historyCustomTransactionId;
@synthesize verificationResultData;
@synthesize storeItemId;


- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
		receiptDetails:(NSDictionary *)data
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyReceipt"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	receiptHistoryId = [BuddyUtility NSNumberFromStringLong:[data objectForKey:@"receiptHistoryID"]];
	storeName = [BuddyUtility stringFromString:[data objectForKey:@"receiptEntityName"]];
	userId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"userID"]];
	historyDateTime = [BuddyUtility dateFromString:[data objectForKey:@"historyDateTime"]];
	receiptData = [BuddyUtility stringFromString:[data objectForKey:@"receiptData"]];
	totalCost = [BuddyUtility stringFromString:[data objectForKey:@"totalCost"]];
	itemQuantity = [BuddyUtility intFromString:[data objectForKey:@"itemQuantity"]];
	appData = [BuddyUtility stringFromString:[data objectForKey:@"appData"]];
	historyCustomTransactionId = [BuddyUtility stringFromString:[data objectForKey:@"historyCustomTransactionID"]];

	storeItemId = [BuddyUtility NSNumberFromStringLong:[data objectForKey:@"storeItemID"]];

	verificationResultData = @"";

	NSString *verificationResult = [BuddyUtility stringFromString:[data objectForKey:@"verificationResult"]];
	if (![BuddyUtility isNilOrEmpty:verificationResult])
	{
		if ([BuddyUtility boolFromString:verificationResult] == TRUE)
		{
			verificationResultData = [BuddyUtility stringFromString:[data objectForKey:@"verificationResultData"]];
		}
	}

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

-(NSNumber *)receiptHistoryID
{
    return self->receiptHistoryId;
}

-(NSNumber *)storeItemID
{
    return self->storeItemId;
}

-(NSString *)historyCustomTransactionID
{
    return self->historyCustomTransactionId;
}

-(NSNumber *)userID
{
    return self->userId;
}

@end
