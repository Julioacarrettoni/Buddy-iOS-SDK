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
/// Represents an object that can be used to record device analytics, like device types and app crashes.
/// </summary>

@implementation BuddyDevice

@synthesize client = _client;

- (id)initWithClient:(BuddyClient *)client
{
	[BuddyUtility checkForNilClient:client name:@"BuddyDevice"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	_client = client;

	return self;
}

- (void)dealloc
{
	_client = nil;
}

- (void)recordInformation:(NSString *)osVersion
               deviceType:(NSString *)deviceType
                 authUser:(BuddyAuthenticatedUser *)authUser
                 callback:(BuddyDeviceRecordInformationCallback)callback;
{
    [self recordInformation:osVersion deviceType:deviceType authUser:authUser appVersion:@"1.0" latitude:0.0 longitude:0.0 metadata:nil  callback:callback];
}

- (void)recordInformation:(NSString *)osVersion
               deviceType:(NSString *)deviceType
                 authUser:(BuddyAuthenticatedUser *)authUser
               appVersion:(NSString *)appVersion
                 latitude:(double)latitude
                longitude:(double)longitude
                 metadata:(NSString *)metadata
                    
                 callback:(BuddyDeviceRecordInformationCallback)callback
{
	[self CheckOS:osVersion];

	[self CheckDevice:deviceType];

	if ([BuddyUtility isNilOrEmpty:appVersion])
	{
		appVersion = @"";
	}

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyDevice"];

	NSString *token = authUser.token;

	[[_client webService] Analytics_DeviceInformation_Add:token DeviceOSVersion:osVersion DeviceType:deviceType Latitude:latitude Longitude:latitude AppName:_client.appName AppVersion:appVersion Metadata:metadata 
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															   }
														   } copy]];
}

- (void)CheckDevice:(NSString *)deviceType
{
	if ([BuddyUtility isNilOrEmpty:deviceType])
	{
		[BuddyUtility throwNilArgException:@"BuddyDevice" reason:@"deviceType"];
	}
}

- (void)CheckOS:(NSString *)osVersion
{
	if ([BuddyUtility isNilOrEmpty:osVersion])
	{
		[BuddyUtility throwNilArgException:@"BuddyDevice" reason:@"osVersion"];
	}
}

- (void)recordCrash:(NSString *)methodName
          osVersion:(NSString *)osVersion
         deviceType:(NSString *)deviceType
           authUser:(BuddyAuthenticatedUser *)authUser
           callback:(BuddyDeviceRecordCrashCallback)callback;
{
    [self recordCrash:methodName osVersion:osVersion deviceType:deviceType authUser:authUser stackTrace:nil appVersion:nil latitude:0.0 longitude:0.0 metadata:nil  callback:callback];
}


- (void)recordCrash:(NSString *)methodName
          osVersion:(NSString *)osVersion
         deviceType:(NSString *)deviceType
           authUser:(BuddyAuthenticatedUser *)authUser
         stackTrace:(NSString *)stackTrace
         appVersion:(NSString *)appVersion
           latitude:(double)latitude
          longitude:(double)longitude
           metadata:(NSString *)metadata
              
           callback:(BuddyDeviceRecordCrashCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:methodName])
	{
		[BuddyUtility throwNilArgException:@"BuddyDevice" reason:@"methodName"];
	}

	[self CheckOS:osVersion];

	[self CheckDevice:deviceType];

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyDevice"];

	NSString *token = authUser.token;

	[[_client webService] Analytics_CrashRecords_Add:token AppVersion:appVersion DeviceOSVersion:osVersion DeviceType:deviceType MethodName:methodName StackTrace:stackTrace Metadata:metadata Latitude:latitude Longitude:longitude 
											callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													  {
														  if (callback)
														  {
															  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														  }
													  } copy]];
}

@end