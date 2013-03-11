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

#import "BuddyRegisteredDeviceApple.h"
#import "BuddyClient.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents an object that can be used to register Apple devices for push notifications. The class can also be used to query for all registered devices and
/// to send them notifications.
/// </summary>

@implementation BuddyNotificationsApple

@synthesize client;
@synthesize authUser;

- (id)initWithClient:(BuddyClient *)localClient
			authUser:(BuddyAuthenticatedUser *)localAuthUser;
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyNotificationsApple"];

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

- (void)registerDevice:(NSData *)appleDeviceToken
			  callback:(BuddyNotificationsAppleRegisterDeviceCallback)callback
{
	[self registerDevice:appleDeviceToken groupName:nil state:nil callback:callback];
}

- (void)registerDevice:(NSData *)appleDeviceToken
			 groupName:(NSString *)groupName
				 state:(NSObject *)state
			  callback:(BuddyNotificationsAppleRegisterDeviceCallback)callback
{
	if (appleDeviceToken == nil)
	{
		[BuddyUtility throwNilArgException:@"RegisterDevice" reason:@"appleDeviceToken"];
	}

	NSString *hexadecimalString = [BuddyUtility hexadecimalString:appleDeviceToken];

	[[client webService] PushNotifications_Apple_RegisterDevice:authUser.token GroupName:groupName AppleDeviceToken:hexadecimalString state:state
													   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																 {
																	 if (callback)
																	 {
																		 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																	 }
																 } copy]];
}

- (void)unregisterDevice:(NSObject *)state
				callback:(BuddyNotificationsAppleUnregisterDeviceCallback)callback
{
	[[client webService] PushNotifications_Apple_RemoveDevice:authUser.token state:state
													 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															   {
																   if (callback)
																   {
																	   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																   }
															   } copy]];
}

- (NSArray *)makeDeviceList:(NSArray *)data authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	NSMutableArray *devices = [[NSMutableArray alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int count = (int)[data count];
		for (int i = 0; i < count; i++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)i];
			if (dict && [dict count] > 0)
			{
				BuddyRegisteredDeviceApple *device = [[BuddyRegisteredDeviceApple alloc]
													  initRegisteredDeviceApple:dict authUser:localAuthUser];
				if (device != nil)
				{
					[devices addObject:device];
				}
			}
		}
	}
	return devices;
}

- (void)getRegisteredDevices:(BuddyNotificationsAppleGetRegisteredDevicesCallback)callback
{
	NSNumber *currentPage = [NSNumber numberWithInt:1];
	NSNumber *pageSize = [NSNumber numberWithInt:10];

	[self getRegisteredDevices:nil pageSize:pageSize currentPage:currentPage state:nil callback:callback];
}

- (void)getRegisteredDevices:(NSString *)group
					pageSize:(NSNumber *)pageSize
				 currentPage:(NSNumber *)currentPage
					   state:(NSObject *)state
					callback:(BuddyNotificationsAppleGetRegisteredDevicesCallback)callback
{
	if (currentPage == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyNotificationsApple" reason:@"GetRegisteredDevices currentpage"];
	}

	if (pageSize == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyNotificationsApple" reason:@"GetRegisteredDevices pagesize"];
	}

	__block BuddyNotificationsApple *_self = self;

	[[client webService] PushNotifications_Apple_GetRegisteredDevices:group
															 PageSize:pageSize
													CurrentPageNumber:currentPage
																state:state
															 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																	   {
																		   if (callback)
																		   {
																			   NSArray *devices;
																			   NSException *exception;
																			   @try
																			   {
																				   if (callbackParams.isCompleted && jsonArray != nil)
																				   {
																					   devices = [_self makeDeviceList:jsonArray authUser:_self.authUser];
																				   }
																			   }
																			   @catch (NSException *ex)
																			   {
																				   exception = ex;
																			   }

																			   if (exception)
																			   {
																				   callback([[BuddyArrayResponse alloc] initWithError:exception
																																state:callbackParams.state
																															  apiCall:callbackParams.apiCall]);
																			   }
																			   else
																			   {
																				   callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams
																																  result:devices]);
																			   }
																		   }
																		   _self = nil;
																	   } copy]];
}

- (NSDictionary *)makeGroupList:(NSArray *)data
{
	NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict == nil || [dict count] == 0)
			{
				continue;
			}

			NSString *groupName = [BuddyUtility stringFromString:[dict objectForKey:@"groupName"]];
			if ([BuddyUtility isNilOrEmpty:groupName])
			{
				continue;
			}

			if ([dictOut objectForKey:groupName] == nil)
			{
				NSNumber *deviceCount = [BuddyUtility NSNumberFromStringInt:[dict objectForKey:@"deviceCount"]];
				[dictOut setValue:deviceCount forKey:groupName];
			}
		}
	}

	return dictOut;
}

- (void)getGroups:(NSObject *)state
		 callback:(BuddyNotificationsAppleGetGroupsCallback)callback
{
	__block BuddyNotificationsApple *_self = self;

	[[client webService] PushNotifications_Apple_GetGroupNames:state
													  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																{
																	if (callback)
																	{
																		NSDictionary *dict;
																		NSException *exception;
																		@try
																		{
																			if (callbackParams.isCompleted && jsonArray != nil)
																			{
																				dict = [_self makeGroupList:jsonArray];
																			}
																		}
																		@catch (NSException *ex)
																		{
																			exception = ex;
																		}

																		if (exception)
																		{
																			callback([[BuddyDictionaryResponse alloc] initWithError:exception
																															  state:callbackParams.state
																															apiCall:callbackParams.apiCall]);
																		}
																		else
																		{
																			callback([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams
																																result:dict]);
																		}
																	}
																	_self = nil;
																} copy]];
}

- (void)sendRawMessage:(NSString *)senderUserId
			   message:(NSString *)message
				 badge:(NSString *)badge
				 sound:(NSString *)sound
			  callback:(BuddyNotificationsAppleSendRawMessageCallback)callback
{
	[self sendRawMessage:senderUserId message:message badge:badge sound:sound customItems:nil deliverAfter:nil groupName:nil state:nil callback:callback];
}

- (void)sendRawMessage:(NSString *)senderUserId
			   message:(NSString *)message
				 badge:(NSString *)badge
				 sound:(NSString *)sound
		   customItems:(NSString *)customItems
		  deliverAfter:(NSDate *)deliverAfter
			 groupName:(NSString *)groupName
				 state:(NSObject *)state
			  callback:(BuddyNotificationsAppleSendRawMessageCallback)callback
{
	if (senderUserId == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyNotificationsApple" reason:@"SendRawMessage senderUserId"];
	}

	if ([BuddyUtility isNilOrEmpty:message])
	{
		[BuddyUtility throwNilArgException:@"BuddyNotificationsApple" reason:@"SendRawMessage message"];
	}

	if ([BuddyUtility isNilOrEmpty:sound])
	{
		sound = @"default";
	}

	if (deliverAfter == nil)
	{
		deliverAfter = [[NSDate alloc] init];
	}

	NSString *deliverAfterString = [BuddyUtility buddyDateToString:deliverAfter];

	[[client webService] PushNotifications_Apple_SendRawMessage:senderUserId DeliverAfter:deliverAfterString GroupName:groupName AppleMessage:message AppleBadge:badge AppleSound:sound CustomItems:customItems state:state
													   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																 {
																	 if (callback)
																	 {
																		 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																	 }
																 } copy]];
}

@end