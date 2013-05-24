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


/// <summary>
/// Represents a collection of friend requests. Use the Add method to request a friend connection from another user.
/// </summary>

@implementation BuddyFriendRequests

@synthesize client;
@synthesize authUser;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyFriendRequests"];

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

- (void) add:(BuddyUser *)user
	callback:(BuddyFriendRequestsAddCallback)callback
{
	[self add:user appTag:nil  callback:callback];
}

- (void) add:(BuddyUser *)user
	  appTag:(NSString *)appTag
	   
	callback:(BuddyFriendRequestsAddCallback)callback
{
	[BuddyUtility checkForNilUser:user name:@"BuddyFriendRequests"];

	[[client webService] Friends_FriendRequest_Add:authUser.token FriendProfileID:user.userId ApplicationTag:appTag RESERVED:@"" 
										  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													{
														if (callback)
														{
															callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														}
													} copy]];
}

- (NSArray *)makeFriendsList:(NSArray *)data
{
	NSMutableArray *friends = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyUser *user = [[BuddyUser alloc] initWithClientFriendRequests:self.client userProfile:dict userId:self.authUser.userId];
				if (user)
				{
					[friends addObject:user];
				}
			}
		}
	}

	return friends;
}

- (void)getAll:(BuddyFriendRequestsGetAllCallback)callback
{
	[self getAll:nil  callback:callback];
}

- (void)getAll:(NSDate *)afterDate
		 
	  callback:(BuddyFriendRequestsGetAllCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *afterDateString = [BuddyUtility buddyDateToString:afterDate];

	__block BuddyFriendRequests *_self = self;

	[[client webService] Friends_FriendRequest_Get:authUser.token FromDateTime:afterDateString 
										  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													{
														if (callback)
														{
															NSArray *data;
															NSException *exception;
															@try
															{
																if (callbackParams.isCompleted && jsonArray != nil)
																{
																	data = [_self makeFriendsList:jsonArray];
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
																											   result:data]);
															}
														}
														_self = nil;
													} copy]];
}

- (void)accept:(BuddyUser *)user
	  callback:(BuddyFriendRequestsAcceptCallback)callback
{
	[self add:user appTag:nil  callback:callback];
}

- (void)accept:(BuddyUser *)user
		appTag:(NSString *)appTag
		 
	  callback:(BuddyFriendRequestsAcceptCallback)callback
{
	[BuddyUtility checkForNilUser:user name:@"BuddyFriendRequests"];

	[[client webService] Friends_FriendRequest_Accept:authUser.token FriendProfileID:user.userId ApplicationTag:appTag RESERVED:@"" 
											 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													   {
														   if (callback)
														   {
															   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														   }
													   } copy]];
}

- (void)deny:(BuddyUser *)user
	   
	callback:(BuddyFriendRequestsDenyCallback)callback
{
	[BuddyUtility checkForNilUser:user name:@"BuddyFriendRequests"];

	[[client webService] Friends_FriendRequest_Deny:authUser.token FriendProfileID:user.userId 
										   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													 {
														 if (callback)
														 {
															 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														 }
													 } copy]];
}

@end