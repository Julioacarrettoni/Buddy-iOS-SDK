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
/// Represents an object that can be used to send message from one user to another.
/// </summary>

@implementation BuddyMessages

@synthesize authUser;
@synthesize client;
@synthesize groups;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyMessages"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	groups = [[BuddyMessageGroups alloc] initWithUser:localClient authUser:localAuthUser];

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (void)send:(BuddyUser *)toUser
	 message:(NSString *)message
	callback:(BuddyMessagesSendCallback)callback
{
	[self send:toUser message:message appTag:nil  callback:callback];
}

- (void)send:(BuddyUser *)toUser
	 message:(NSString *)message
	  appTag:(NSString *)appTag
	   
	callback:(BuddyMessagesSendCallback)callback
{
	[BuddyUtility checkForNilUser:toUser name:@"BuddyMessages"];

	if ([BuddyUtility isNilOrEmpty:message] || [message length] > 200)
	{
		[BuddyUtility throwInvalidArgException:@"BuddyMessages" reason:@"message can't be nil or large than 200 characters"];
	}

	[[client webService] Messages_Message_Send:authUser.token MessageString:message ToUserID:toUser.userId ApplicationTag:appTag RESERVED:@"" 
									  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
												{
													if (callback)
													{
														callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
													}
												} copy]];
}

- (NSArray *)makeMessageList:(NSArray *)data
{
	NSMutableArray *messageList = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyMessage *message = [[BuddyMessage alloc] initTo:dict fromUserId:authUser.userId];
				if (message)
				{
					[messageList addObject:message];
				}
			}
		}
	}

	return messageList;
}

- (void)getReceived:(BuddyMessagesGetReceivedCallback)callback
{
	[self getReceived:nil  callback:callback];
}

- (void)getReceived:(NSDate *)afterDate
			  
		   callback:(BuddyMessagesGetReceivedCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *afterDateString = [BuddyUtility buddyDateToString:afterDate];

	__block BuddyMessages *_self = self;

	[[client webService] Messages_Messages_Get:authUser.token FromDateTime:afterDateString 
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
																data = [_self makeMessageList:jsonArray];
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

- (void)getSent:(BuddyMessagesGetSentCallback)callback
{
	[self getSent:nil  callback:callback];
}

- (void)getSent:(NSDate *)afterDate
		  
	   callback:(BuddyMessagesGetSentCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *afterDateString = [BuddyUtility buddyDateToString:afterDate];

	__block BuddyMessages *_self = self;

	[[client webService] Messages_SentMessages_Get:authUser.token FromDateTime:afterDateString 
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
																	data = [_self makeMessageList:jsonArray];
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

@end