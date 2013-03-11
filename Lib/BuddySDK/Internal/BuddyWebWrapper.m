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

#import "BuddyCallbackParams.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyWebWrapper.h"
#import "ClientServicePlainText.h"
#import "AFHTTPRequestOperation.h"

#import "BuddyUtility.h"

#define kHttpGetTimeout  60
#define kHttpPostTimeout 60

static NSString * const BuddySDKHeaderValue = @"Platform=iOS;Version=1.0.0-beta.2";

@implementation BuddyWebWrapper

@synthesize client;
@synthesize http_getTimeout;
@synthesize http_postTimeout;

- (id)  initWrapper:(BuddyClient *)localClient
	 httpGetTimeout:(int)getTimeout
	httpPostTimeout:(int)postTimeout
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	http_getTimeout = getTimeout;
	http_postTimeout = postTimeout;

    [self setBuddySDKHeader];
    
	return self;
}

- (id)initWrapper:(BuddyClient *)localClient
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	http_getTimeout = kHttpGetTimeout;
	http_postTimeout = kHttpPostTimeout;

    [self setBuddySDKHeader];
    
	return self;
}

- (void)setHttpGetTimeout:(int)timeout
{
	http_getTimeout = timeout;
}

- (void)setHttpPostTimeout:(int)timeout
{
	http_postTimeout = timeout;
}

- (void)setClient:(BuddyClient *)localClient
{
	client = localClient;
	http_getTimeout = kHttpGetTimeout;
	http_postTimeout = kHttpPostTimeout;
    
    [self setBuddySDKHeader];
}

- (void)setBuddySDKHeader
{
    [[ClientServicePlainText sharedClient] setDefaultHeader:@"BuddySDK" value:BuddySDKHeaderValue];
}

- (void)setSSLType:(BOOL)ssl
{
	[[ClientServicePlainText sharedClient] setSSLType:ssl];
}

- (void)enableNetworkActivityDisplay
{
	[[ClientServicePlainText sharedClient] enableNetworkActivityDisplay];
}

- (void)disableNetworkActivityDisplay
{
	[[ClientServicePlainText sharedClient] disableNetworkActivityDisplay];
}

- (id)getJson:(NSData *)data
{
	id jsonData = nil;

	NSError *error;
	id dataString = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&error];

	if (dataString != [NSNull null] && dataString != nil && error == nil)
	{
		jsonData = [dataString objectForKey:@"data"];
	}

	return jsonData;
}

- (void)processResponse:(AFHTTPRequestOperation *)operation apiCall:(NSString *)apiCall state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonData))callback
{
	if (operation)
	{
		id jsonData = nil;
		NSString *responseString = [[NSString alloc] initWithString:operation.responseString];

		if ([responseString length] > 8 && [responseString hasPrefix:@"{"])
		{
			@try
			{
				jsonData = [self getJson:operation.responseData];
				if (callback)
				{
					BuddyCallbackParams *callbackParams = [[BuddyCallbackParams alloc] initWithParam:TRUE apiCall:apiCall exception:nil state:state dataResult:responseString];

					callback(callbackParams, jsonData);
				}
			}
			@catch (NSException *ex)
			{
				if (callback)
				{
					callback([BuddyUtility buildBuddyServiceError:apiCall reason:ex.reason state:state], nil);
				}
			}
		}
		else
		{
			if (callback)
			{
				BuddyCallbackParams *callbackParams = [[BuddyCallbackParams alloc] initWithParam:TRUE apiCall:apiCall exception:nil state:state dataResult:responseString];

				callback(callbackParams, jsonData);
			}
		}
	}
	else
	{
		if (callback)
		{
			callback([BuddyUtility buildBuddyFailure:apiCall reason:@"Error in AFHTTPClient: No operation available" state:state], nil);
		}
	}
}

- (void)makeRequest:(NSString *)apiCall
			 params:(NSMutableString *)params
			  state:(NSObject *)state
		   callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonData))callback
{
	[[ClientServicePlainText sharedClient] getPath:params
										   timeout:http_getTimeout
										   success:[^(AFHTTPRequestOperation *operation, id JSON)
													{
														[self processResponse:operation apiCall:apiCall state:state callback:callback];
													} copy]
										   failure:[^(AFHTTPRequestOperation *operation, NSError *error)
													{
														if (callback)
														{
															callback([BuddyUtility buildBuddyFailure:apiCall reason:[error localizedDescription] state:state], nil);
														}
													} copy]];
}

- (void)makePostRequest:(NSString *)apiCall
				   path:(NSString *)path
				 params:(NSDictionary *)params
				  state:(NSObject *)state
			   callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonData))callback
{
	[[ClientServicePlainText sharedClient] postPath:path
											timeout:http_postTimeout
										 parameters:params
											success:[^(AFHTTPRequestOperation *operation, id JSON)
													 {
														 [self processResponse:operation apiCall:apiCall state:state callback:callback];
													 } copy]
											failure:[^(AFHTTPRequestOperation *operation, NSError *error)
													 {
														 if (callback)
														 {
															 callback([BuddyUtility buildBuddyFailure:apiCall reason:[error localizedDescription] state:state], nil);
														 }
													 } copy]];
}

- (void)directPost:(NSString *)api path:(NSString *)path params:(NSDictionary *)params state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	[self makePostRequest:api path:path params:params state:state callback:callback];
}

- (void)UserAccount_Defines_GetStatusValues:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Defines_GetStatusValues" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"UserAccount_Defines_GetStatusValues" params:params state:state callback:callback];
}

- (void)UserAccount_Identity_AddNewValue:(NSString *)UserToken IdentityValue:(NSString *)IdentityValue RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Identity_AddNewValue" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&IdentityValue=%@", [BuddyUtility encodeValue:IdentityValue]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Identity_AddNewValue" params:params state:state callback:callback];
}

- (void)UserAccount_Identity_CheckForValues:(NSString *)UserToken IdentityValue:(NSString *)IdentityValue RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Identity_CheckForValues" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&IdentityValue=%@", [BuddyUtility encodeValue:IdentityValue]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Identity_CheckForValues" params:params state:state callback:callback];
}

- (void)UserAccount_Identity_GetMyList:(NSString *)UserToken RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Identity_GetMyList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Identity_GetMyList" params:params state:state callback:callback];
}

- (void)UserAccount_Identity_RemoveValue:(NSString *)UserToken IdentityValue:(NSString *)IdentityValue RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Identity_RemoveValue" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&IdentityValue=%@", [BuddyUtility encodeValue:IdentityValue]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Identity_RemoveValue" params:params state:state callback:callback];
}

- (void)UserAccount_Location_Checkin:(NSString *)UserToken Latitude:(double)Latitude Longitude:(double)Longitude CheckInComment:(NSString *)CheckInComment ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Location_Checkin" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&CheckInComment=%@", [BuddyUtility encodeValue:CheckInComment]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Location_Checkin" params:params state:state callback:callback];
}

- (void)UserAccount_Location_GetHistory:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Location_GetHistory" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[self makeRequest:@"UserAccount_Location_GetHistory" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_CheckUserEmail:(NSString *)UserEmailToVerify RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_CheckUserEmail" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserEmailToVerify=%@", [BuddyUtility encodeValue:UserEmailToVerify]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_CheckUserEmail" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_CheckUserName:(NSString *)UserNameToVerify RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_CheckUserName" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserNameToVerify=%@", [BuddyUtility encodeValue:UserNameToVerify]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_CheckUserName" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_Create:(NSString *)NewUserName UserSuppliedPassword:(NSString *)UserSuppliedPassword NewUserGender:(NSString *)NewUserGender UserAge:(NSNumber *)UserAge NewUserEmail:(NSString *)NewUserEmail StatusID:(NSNumber *)StatusID FuzzLocationEnabled:(NSNumber *)FuzzLocationEnabled CelebModeEnabled:(NSNumber *)CelebModeEnabled ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_Create" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&NewUserName=%@", [BuddyUtility encodeValue:NewUserName]];
	[params appendFormat:@"&UserSuppliedPassword=%@", [BuddyUtility encodeValue:UserSuppliedPassword]];
	[params appendFormat:@"&NewUserGender=%@", [BuddyUtility encodeValue:NewUserGender]];
	[params appendFormat:@"&UserAge=%@", [BuddyUtility encodeValue:[UserAge stringValue]]];
	[params appendFormat:@"&NewUserEmail=%@", [BuddyUtility encodeValue:NewUserEmail]];
	[params appendFormat:@"&StatusID=%@", [BuddyUtility encodeValue:[StatusID stringValue]]];
	[params appendFormat:@"&FuzzLocationEnabled=%@", [BuddyUtility encodeValue:[FuzzLocationEnabled stringValue]]];
	[params appendFormat:@"&CelebModeEnabled=%@", [BuddyUtility encodeValue:[CelebModeEnabled stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_Create" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_DeleteAccount:(NSNumber *)UserProfileID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_DeleteAccount" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_DeleteAccount" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_GetFromUserID:(NSString *)UserToken UserIDToFetch:(NSNumber *)UserIDToFetch state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_GetFromUserID" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserIDToFetch=%@", [BuddyUtility encodeValue:[UserIDToFetch stringValue]]];
	[self makeRequest:@"UserAccount_Profile_GetFromUserID" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_GetFromUserName:(NSString *)UserToken UserNameToFetch:(NSString *)UserNameToFetch state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_GetFromUserName" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserNameToFetch=%@", [BuddyUtility encodeValue:UserNameToFetch]];
	[self makeRequest:@"UserAccount_Profile_GetFromUserName" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_GetFromUserToken:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_GetFromUserToken" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"UserAccount_Profile_GetFromUserToken" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_GetUserIDFromUserToken:(NSString *)UserToken RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_GetUserIDFromUserToken" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_GetUserIDFromUserToken" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_Recover:(NSString *)userName UserSuppliedPassword:(NSString *)UserSuppliedPassword state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_Recover" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&username=%@", [BuddyUtility encodeValue:userName]];
	[params appendFormat:@"&usersuppliedpassword=%@", [BuddyUtility encodeValue:UserSuppliedPassword]];
	[self makeRequest:@"UserAccount_Profile_Recover" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_Search:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit Gender:(NSString *)Gender AgeStart:(NSNumber *)AgeStart AgeStop:(NSNumber *)AgeStop StatusID:(NSNumber *)StatusID TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_Search" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&Gender=%@", [BuddyUtility encodeValue:Gender]];
	[params appendFormat:@"&AgeStart=%@", [BuddyUtility encodeValue:[AgeStart stringValue]]];
	[params appendFormat:@"&AgeStop=%@", [BuddyUtility encodeValue:[AgeStop stringValue]]];
	[params appendFormat:@"&StatusID=%@", [BuddyUtility encodeValue:[StatusID stringValue]]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_Search" params:params state:state callback:callback];
}

- (void)UserAccount_Profile_Update:(NSString *)UserToken UserName:(NSString *)UserName UserSuppliedPassword:(NSString *)UserSuppliedPassword UserGender:(NSString *)UserGender UserAge:(NSNumber *)UserAge UserEmail:(NSString *)UserEmail StatusID:(NSNumber *)StatusID FuzzLocationEnabled:(NSNumber *)FuzzLocationEnabled CelebModeEnabled:(NSNumber *)CelebModeEnabled ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"UserAccount_Profile_Update" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserName=%@", [BuddyUtility encodeValue:UserName]];
	[params appendFormat:@"&UserSuppliedPassword=%@", [BuddyUtility encodeValue:UserSuppliedPassword]];
	[params appendFormat:@"&UserGender=%@", [BuddyUtility encodeValue:UserGender]];
	[params appendFormat:@"&UserAge=%@", [BuddyUtility encodeValue:[UserAge stringValue]]];
	[params appendFormat:@"&UserEmail=%@", [BuddyUtility encodeValue:UserEmail]];
	[params appendFormat:@"&StatusID=%@", [BuddyUtility encodeValue:[StatusID stringValue]]];
	[params appendFormat:@"&FuzzLocationEnabled=%@", [BuddyUtility encodeValue:[FuzzLocationEnabled stringValue]]];
	[params appendFormat:@"&CelebModeEnabled=%@", [BuddyUtility encodeValue:[CelebModeEnabled stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"UserAccount_Profile_Update" params:params state:state callback:callback];
}

- (void)Pictures_Filters_ApplyFilter:(NSString *)UserToken ExistingPhotoID:(NSNumber *)ExistingPhotoID FilterName:(NSString *)FilterName FilterParameters:(NSString *)FilterParameters ReplacePhoto:(NSNumber *)ReplacePhoto state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_Filters_ApplyFilter" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ExistingPhotoID=%@", [BuddyUtility encodeValue:[ExistingPhotoID stringValue]]];
	[params appendFormat:@"&FilterName=%@", [BuddyUtility encodeValue:FilterName]];
	[params appendFormat:@"&FilterParameters=%@", [BuddyUtility encodeValue:FilterParameters]];
	[params appendFormat:@"&ReplacePhoto=%@", [BuddyUtility encodeValue:[ReplacePhoto stringValue]]];
	[self makeRequest:@"Pictures_Filters_ApplyFilter" params:params state:state callback:callback];
}

- (void)Pictures_Filters_GetList:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_Filters_GetList" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"Pictures_Filters_GetList" params:params state:state callback:callback];
}

- (void)Pictures_Photo_Delete:(NSString *)UserToken PhotoAlbumPhotoID:(NSNumber *)PhotoAlbumPhotoID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_Photo_Delete" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&PhotoAlbumPhotoID=%@", [BuddyUtility encodeValue:[PhotoAlbumPhotoID stringValue]]];
	[self makeRequest:@"Pictures_Photo_Delete" params:params state:state callback:callback];
}

- (void)Pictures_Photo_Get:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID PhotoID:(NSNumber *)PhotoID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_Photo_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[params appendFormat:@"&PhotoID=%@", [BuddyUtility encodeValue:[PhotoID stringValue]]];
	[self makeRequest:@"Pictures_Photo_Get" params:params state:state callback:callback];
}

// apptag is a string not a number
- (void)Pictures_Photo_SetAppTag:(NSString *)UserToken PhotoAlbumPhotoID:(NSNumber *)PhotoAlbumPhotoID ApplicationTag:(NSString *)ApplicationTag state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_Photo_SetAppTag" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&PhotoAlbumPhotoID=%@", [BuddyUtility encodeValue:[PhotoAlbumPhotoID stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[self makeRequest:@"Pictures_Photo_SetAppTag" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_Create:(NSString *)UserToken AlbumName:(NSString *)AlbumName PublicAlbumBit:(NSNumber *)PublicAlbumBit ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_Create" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&AlbumName=%@", [BuddyUtility encodeValue:AlbumName]];
	[params appendFormat:@"&PublicAlbumBit=%@", [BuddyUtility encodeValue:[PublicAlbumBit stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_PhotoAlbum_Create" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_Delete:(NSString *)UserToken PhotoAlbumID:(NSNumber *)PhotoAlbumID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_Delete" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&PhotoAlbumID=%@", [BuddyUtility encodeValue:[PhotoAlbumID stringValue]]];
	[self makeRequest:@"Pictures_PhotoAlbum_Delete" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_Get:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID PhotoAlbumID:(NSNumber *)PhotoAlbumID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[params appendFormat:@"&PhotoAlbumID=%@", [BuddyUtility encodeValue:[PhotoAlbumID stringValue]]];
	[self makeRequest:@"Pictures_PhotoAlbum_Get" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_GetAllPictures:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID SearchFromDateTime:(NSString *)SearchFromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_GetAllPictures" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[params appendFormat:@"&SearchFromDateTime=%@", [BuddyUtility encodeValue:SearchFromDateTime]];
	[self makeRequest:@"Pictures_PhotoAlbum_GetAllPictures" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_GetFromAlbumName:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID PhotoAlbumName:(NSString *)PhotoAlbumName state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_GetFromAlbumName" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[params appendFormat:@"&PhotoAlbumName=%@", [BuddyUtility encodeValue:PhotoAlbumName]];
	[self makeRequest:@"Pictures_PhotoAlbum_GetFromAlbumName" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_GetByDateTime:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID StartDateTime:(NSString *)StartDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_GetByDateTime" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[params appendFormat:@"&StartDateTime=%@", [BuddyUtility encodeValue:StartDateTime]];
	[self makeRequest:@"Pictures_PhotoAlbum_GetByDateTime" params:params state:state callback:callback];
}

- (void)Pictures_PhotoAlbum_GetList:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_PhotoAlbum_GetList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[self makeRequest:@"Pictures_PhotoAlbum_GetList" params:params state:state callback:callback];
}

- (void)Pictures_ProfilePhoto_Add:(NSString *)UserToken bytesFullPhotoData:(NSString *)bytesFullPhotoData ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_ProfilePhoto_Add" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&bytesFullPhotoData=%@", [BuddyUtility encodeValue:bytesFullPhotoData]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_ProfilePhoto_Add" params:params state:state callback:callback];
}

- (void)Pictures_ProfilePhoto_Delete:(NSString *)UserToken ProfilePhotoID:(NSNumber *)ProfilePhotoID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_ProfilePhoto_Delete" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ProfilePhotoID=%@", [BuddyUtility encodeValue:[ProfilePhotoID stringValue]]];
	[self makeRequest:@"Pictures_ProfilePhoto_Delete" params:params state:state callback:callback];
}

- (void)Pictures_ProfilePhoto_GetAll:(NSNumber *)UserProfileID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_ProfilePhoto_GetAll" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserProfileID=%@", [BuddyUtility encodeValue:[UserProfileID stringValue]]];
	[self makeRequest:@"Pictures_ProfilePhoto_GetAll" params:params state:state callback:callback];
}

- (void)Pictures_ProfilePhoto_GetMyList:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_ProfilePhoto_GetMyList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"Pictures_ProfilePhoto_GetMyList" params:params state:state callback:callback];
}

- (void)Pictures_ProfilePhoto_Set:(NSString *)UserToken ProfilePhotoResource:(NSString *)ProfilePhotoResource state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_ProfilePhoto_Set" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ProfilePhotoResource=%@", [BuddyUtility encodeValue:ProfilePhotoResource]];
	[self makeRequest:@"Pictures_ProfilePhoto_Set" params:params state:state callback:callback];
}

- (void)Pictures_SearchPhotos_Data:(NSString *)UserToken Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_SearchPhotos_Data" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[self makeRequest:@"Pictures_SearchPhotos_Data" params:params state:state callback:callback];
}

- (void)Pictures_SearchPhotos_Nearby:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_SearchPhotos_Nearby" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[self makeRequest:@"Pictures_SearchPhotos_Nearby" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_AddPhoto:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID ExistingPhotoID:(NSNumber *)ExistingPhotoID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_AddPhoto" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualAlbumID=%@", [BuddyUtility encodeValue:[VirtualAlbumID stringValue]]];
	[params appendFormat:@"&ExistingPhotoID=%@", [BuddyUtility encodeValue:[ExistingPhotoID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_AddPhoto" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_AddPhotoBatch:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID ExistingPhotoIDBatchString:(NSString *)ExistingPhotoIDBatchString RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_AddPhotoBatch" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualAlbumID=%@", [BuddyUtility encodeValue:[VirtualAlbumID stringValue]]];
	[params appendFormat:@"&ExistingPhotoIDBatchString=%@", [BuddyUtility encodeValue:ExistingPhotoIDBatchString]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_AddPhotoBatch" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_Create:(NSString *)UserToken AlbumName:(NSString *)AlbumName ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_Create" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&AlbumName=%@", [BuddyUtility encodeValue:AlbumName]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_Create" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_DeleteAlbum:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_DeleteAlbum" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualAlbumID=%@", [BuddyUtility encodeValue:[VirtualAlbumID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_DeleteAlbum" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_Get:(NSString *)UserToken VirtualPhotoAlbumID:(NSNumber *)VirtualPhotoAlbumID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualPhotoAlbumID=%@", [BuddyUtility encodeValue:[VirtualPhotoAlbumID stringValue]]];
	[self makeRequest:@"Pictures_VirtualAlbum_Get" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_GetAlbumInformation:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_GetAlbumInformation" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualAlbumID=%@", [BuddyUtility encodeValue:[VirtualAlbumID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_GetAlbumInformation" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_GetMyAlbums:(NSString *)UserToken RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_GetMyAlbums" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_GetMyAlbums" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_RemovePhoto:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID ExistingPhotoID:(NSNumber *)ExistingPhotoID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_RemovePhoto" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualAlbumID=%@", [BuddyUtility encodeValue:[VirtualAlbumID stringValue]]];
	[params appendFormat:@"&ExistingPhotoID=%@", [BuddyUtility encodeValue:[ExistingPhotoID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_RemovePhoto" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_Update:(NSString *)UserToken VirtualPhotoAlbumID:(NSNumber *)VirtualPhotoAlbumID NewAlbumName:(NSString *)NewAlbumName NewAppTag:(NSString *)NewAppTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_Update" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&VirtualPhotoAlbumID=%@", [BuddyUtility encodeValue:[VirtualPhotoAlbumID stringValue]]];
	[params appendFormat:@"&NewAlbumName=%@", [BuddyUtility encodeValue:NewAlbumName]];
	[params appendFormat:@"&NewAppTag=%@", [BuddyUtility encodeValue:NewAppTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_Update" params:params state:state callback:callback];
}

- (void)Pictures_VirtualAlbum_UpdatePhoto:(NSString *)UserToken ExistingPhotoID:(NSNumber *)ExistingPhotoID NewPhotoComment:(NSString *)NewPhotoComment NewAppTag:(NSString *)NewAppTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Pictures_VirtualAlbum_UpdatePhoto" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ExistingPhotoID=%@", [BuddyUtility encodeValue:[ExistingPhotoID stringValue]]];
	[params appendFormat:@"&NewPhotoComment=%@", [BuddyUtility encodeValue:NewPhotoComment]];
	[params appendFormat:@"&NewAppTag=%@", [BuddyUtility encodeValue:NewAppTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Pictures_VirtualAlbum_UpdatePhoto" params:params state:state callback:callback];
}

- (void)GeoLocation_Category_GetList:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Category_GetList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"GeoLocation_Category_GetList" params:params state:state callback:callback];
}

- (void)GeoLocation_Category_Submit:(NSString *)UserToken NewCategoryName:(NSString *)NewCategoryName Comment:(NSString *)Comment ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Category_Submit" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&NewCategoryName=%@", [BuddyUtility encodeValue:NewCategoryName]];
	[params appendFormat:@"&Comment=%@", [BuddyUtility encodeValue:Comment]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GeoLocation_Category_Submit" params:params state:state callback:callback];
}

- (void)GeoLocation_Location_Add:(NSString *)UserToken Latitude:(double)Latitude Longitude:(double)Longitude LocationName:(NSString *)LocationName Address1:(NSString *)Address1 Address2:(NSString *)Address2 LocationCity:(NSString *)LocationCity LocationState:(NSString *)LocationState LocationZipPostal:(NSString *)LocationZipPostal CategoryID:(NSNumber *)CategoryID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Location_Add" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&LocationName=%@", [BuddyUtility encodeValue:LocationName]];
	[params appendFormat:@"&Address1=%@", [BuddyUtility encodeValue:Address1]];
	[params appendFormat:@"&Address2=%@", [BuddyUtility encodeValue:Address2]];
	[params appendFormat:@"&LocationCity=%@", [BuddyUtility encodeValue:LocationCity]];
	[params appendFormat:@"&LocationState=%@", [BuddyUtility encodeValue:LocationState]];
	[params appendFormat:@"&LocationZipPostal=%@", [BuddyUtility encodeValue:LocationZipPostal]];
	[params appendFormat:@"&CategoryID=%@", [BuddyUtility encodeValue:[CategoryID stringValue]]];
	[self makeRequest:@"GeoLocation_Location_Add" params:params state:state callback:callback];
}

- (void)GeoLocation_Location_Edit:(NSString *)UserToken ExistingGeoRecordID:(NSNumber *)ExistingGeoRecordID NewLatitude:(double)NewLatitude NewLongitude:(double)NewLongitude NewLocationName:(NSString *)NewLocationName NewAddress:(NSString *)NewAddress NewLocationCity:(NSString *)NewLocationCity NewLocationState:(NSString *)NewLocationState NewLocationZipPostal:(NSString *)NewLocationZipPostal NewCategoryID:(NSString *)NewCategoryID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Location_Edit" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ExistingGeoRecordID=%@", [BuddyUtility encodeValue:[ExistingGeoRecordID stringValue]]];
	[params appendFormat:@"&NewLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", NewLatitude]]];
	[params appendFormat:@"&NewLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", NewLongitude]]];
	[params appendFormat:@"&NewLocationName=%@", [BuddyUtility encodeValue:NewLocationName]];
	[params appendFormat:@"&NewAddress=%@", [BuddyUtility encodeValue:NewAddress]];
	[params appendFormat:@"&NewLocationCity=%@", [BuddyUtility encodeValue:NewLocationCity]];
	[params appendFormat:@"&NewLocationState=%@", [BuddyUtility encodeValue:NewLocationState]];
	[params appendFormat:@"&NewLocationZipPostal=%@", [BuddyUtility encodeValue:NewLocationZipPostal]];
	[params appendFormat:@"&NewCategoryID=%@", [BuddyUtility encodeValue:NewCategoryID]];
	[self makeRequest:@"GeoLocation_Location_Edit" params:params state:state callback:callback];
}

- (void)GeoLocation_Location_Flag:(NSString *)UserToken ExistingGeoRecordID:(NSNumber *)ExistingGeoRecordID FlagReason:(NSString *)FlagReason state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Location_Flag" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ExistingGeoRecordID=%@", [BuddyUtility encodeValue:[ExistingGeoRecordID stringValue]]];
	[params appendFormat:@"&FlagReason=%@", [BuddyUtility encodeValue:FlagReason]];
	[self makeRequest:@"GeoLocation_Location_Flag" params:params state:state callback:callback];
}

- (void)GeoLocation_Location_GetFromID:(NSString *)UserToken ExistingGeoID:(NSNumber *)ExistingGeoID Latitude:(double)Latitude Longitude:(double)Longitude RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Location_GetFromID" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ExistingGeoID=%@", [BuddyUtility encodeValue:[ExistingGeoID stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GeoLocation_Location_GetFromID" params:params state:state callback:callback];
}

// changed catergoryId
- (void)GeoLocation_Location_Search:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit SearchName:(NSString *)SearchName SearchCategoryID:(NSString *)SearchCategoryID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Location_Search" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&SearchName=%@", [BuddyUtility encodeValue:SearchName]];
	[params appendFormat:@"&SearchCategoryID=%@", [BuddyUtility encodeValue:SearchCategoryID]];
	[self makeRequest:@"GeoLocation_Location_Search" params:params state:state callback:callback];
}

- (void)GeoLocation_Location_SetTag:(NSString *)UserToken ExistingGeoID:(NSNumber *)ExistingGeoID ApplicationTag:(NSString *)ApplicationTag UserTag:(NSString *)UserTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GeoLocation_Location_SetTag" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&ExistingGeoID=%@", [BuddyUtility encodeValue:[ExistingGeoID stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendFormat:@"&UserTag=%@", [BuddyUtility encodeValue:UserTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GeoLocation_Location_SetTag" params:params state:state callback:callback];
}

- (void)PushNotifications_Apple_RegisterDevice:(NSString *)UserToken GroupName:(NSString *)GroupName AppleDeviceToken:(NSString *)AppleDeviceToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"PushNotifications_Apple_RegisterDevice" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupName=%@", [BuddyUtility encodeValue:GroupName]];
	[params appendFormat:@"&AppleDeviceToken=%@", [BuddyUtility encodeValue:AppleDeviceToken]];
	[self makeRequest:@"PushNotifications_Apple_RegisterDevice" params:params state:state callback:callback];
}

- (void)PushNotifications_Apple_RemoveDevice:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"PushNotifications_Apple_RemoveDevice" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"PushNotifications_Apple_RemoveDevice" params:params state:state callback:callback];
}

- (void)PushNotifications_Apple_SendRawMessage:(NSString *)UserTokenOrID DeliverAfter:(NSString *)DeliverAfter GroupName:(NSString *)GroupName AppleMessage:(NSString *)AppleMessage AppleBadge:(NSString *)AppleBadge AppleSound:(NSString *)AppleSound CustomItems:(NSString *)CustomItems state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"PushNotifications_Apple_SendRawMessage" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&DeliverAfter=%@", [BuddyUtility encodeValue:DeliverAfter]];
	[params appendFormat:@"&GroupName=%@", [BuddyUtility encodeValue:GroupName]];
	[params appendFormat:@"&AppleMessage=%@", [BuddyUtility encodeValue:AppleMessage]];
	[params appendFormat:@"&AppleBadge=%@", [BuddyUtility encodeValue:AppleBadge]];
	[params appendFormat:@"&AppleSound=%@", [BuddyUtility encodeValue:AppleSound]];
	[params appendFormat:@"&CustomItems=%@", [BuddyUtility encodeValue:CustomItems]];
	[self makeRequest:@"PushNotifications_Apple_SendRawMessage" params:params state:state callback:callback];
}

- (void)PushNotifications_Apple_GetRegisteredDevices:(NSString *)GroupName PageSize:(NSNumber *)PageSize CurrentPageNumber:(NSNumber *)CurrentPageNumber state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"PushNotifications_Apple_GetRegisteredDevices" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&GroupName=%@", [BuddyUtility encodeValue:GroupName]];
	[params appendFormat:@"&PageSize=%@", [BuddyUtility encodeValue:[PageSize stringValue]]];
	[params appendFormat:@"&CurrentPageNumber=%@", [BuddyUtility encodeValue:[CurrentPageNumber stringValue]]];
	[self makeRequest:@"PushNotifications_Apple_GetRegisteredDevices" params:params state:state callback:callback];
}

- (void)PushNotifications_Apple_GetGroupNames:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"PushNotifications_Apple_GetGroupNames" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"PushNotifications_Apple_GetGroupNames" params:params state:state callback:callback];
}

- (void)Messages_SentMessages_Get:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Messages_SentMessages_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[self makeRequest:@"Messages_SentMessages_Get" params:params state:state callback:callback];
}

- (void)Messages_Messages_Get:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Messages_Messages_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[self makeRequest:@"Messages_Messages_Get" params:params state:state callback:callback];
}

- (void)Messages_Message_Send:(NSString *)UserToken MessageString:(NSString *)MessageString ToUserID:(NSNumber *)ToUserID ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Messages_Message_Send" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&MessageString=%@", [BuddyUtility encodeValue:MessageString]];
	[params appendFormat:@"&ToUserID=%@", [BuddyUtility encodeValue:[ToUserID stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Messages_Message_Send" params:params state:state callback:callback];
}

- (void)GroupMessages_Message_Send:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID MessageContent:(NSString *)MessageContent Latitude:(double)Latitude Longitude:(double)Longitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Message_Send" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendFormat:@"&MessageContent=%@", [BuddyUtility encodeValue:MessageContent]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Message_Send" params:params state:state callback:callback];
}

- (void)GroupMessages_Message_Get:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID FromDateTime:(NSString *)FromDateTime RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Message_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Message_Get" params:params state:state callback:callback];
}

- (void)GroupMessages_Membership_RemoveUser:(NSString *)UserToken UserProfileIDToRemove:(NSNumber *)UserProfileIDToRemove GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Membership_RemoveUser" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileIDToRemove=%@", [BuddyUtility encodeValue:[UserProfileIDToRemove stringValue]]];
	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Membership_RemoveUser" params:params state:state callback:callback];
}

- (void)GroupMessages_Membership_JoinGroup:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Membership_JoinGroup" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Membership_JoinGroup" params:params state:state callback:callback];
}

- (void)GroupMessages_Membership_GetMyList:(NSString *)UserToken RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Membership_GetMyList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Membership_GetMyList" params:params state:state callback:callback];
}

- (void)GroupMessages_Membership_GetAllGroups:(NSString *)UserToken RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Membership_GetAllGroups" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Membership_GetAllGroups" params:params state:state callback:callback];
}

- (void)GroupMessages_Membership_DepartGroup:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Membership_DepartGroup" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Membership_DepartGroup" params:params state:state callback:callback];
}

- (void)GroupMessages_Membership_AddNewMember:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID UserProfileIDToAdd:(NSNumber *)UserProfileIDToAdd RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Membership_AddNewMember" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendFormat:@"&UserProfileIDToAdd=%@", [BuddyUtility encodeValue:[UserProfileIDToAdd stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Membership_AddNewMember" params:params state:state callback:callback];
}

- (void)GroupMessages_Manage_DeleteGroup:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Manage_DeleteGroup" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupChatID=%@", [BuddyUtility encodeValue:[GroupChatID stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Manage_DeleteGroup" params:params state:state callback:callback];
}

- (void)GroupMessages_Manage_CreateGroup:(NSString *)UserToken GroupName:(NSString *)GroupName GroupSecurity:(NSString *)GroupSecurity ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Manage_CreateGroup" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupName=%@", [BuddyUtility encodeValue:GroupName]];
	[params appendFormat:@"&GroupSecurity=%@", [BuddyUtility encodeValue:GroupSecurity]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Manage_CreateGroup" params:params state:state callback:callback];
}

- (void)GroupMessages_Manage_CheckForGroup:(NSString *)UserToken GroupName:(NSString *)GroupName RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"GroupMessages_Manage_CheckForGroup" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&GroupName=%@", [BuddyUtility encodeValue:GroupName]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"GroupMessages_Manage_CheckForGroup" params:params state:state callback:callback];
}

- (void)Friends_Block_Add:(NSString *)UserToken UserProfileToBlock:(NSNumber *)UserProfileToBlock ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_Block_Add" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserProfileToBlock=%@", [BuddyUtility encodeValue:[UserProfileToBlock stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Friends_Block_Add" params:params state:state callback:callback];
}

- (void)Friends_Block_GetList:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_Block_GetList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"Friends_Block_GetList" params:params state:state callback:callback];
}

- (void)Friends_Block_Remove:(NSString *)UserToken BlockedProfileID:(NSNumber *)BlockedProfileID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_Block_Remove" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&BlockedProfileID=%@", [BuddyUtility encodeValue:[BlockedProfileID stringValue]]];
	[self makeRequest:@"Friends_Block_Remove" params:params state:state callback:callback];
}

- (void)Friends_FriendRequest_Accept:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_FriendRequest_Accept" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FriendProfileID=%@", [BuddyUtility encodeValue:[FriendProfileID stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Friends_FriendRequest_Accept" params:params state:state callback:callback];
}

- (void)Friends_FriendRequest_Add:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_FriendRequest_Add" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FriendProfileID=%@", [BuddyUtility encodeValue:[FriendProfileID stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Friends_FriendRequest_Add" params:params state:state callback:callback];
}

- (void)Friends_FriendRequest_Deny:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_FriendRequest_Deny" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FriendProfileID=%@", [BuddyUtility encodeValue:[FriendProfileID stringValue]]];
	[self makeRequest:@"Friends_FriendRequest_Deny" params:params state:state callback:callback];
}

- (void)Friends_FriendRequest_Get:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_FriendRequest_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[self makeRequest:@"Friends_FriendRequest_Get" params:params state:state callback:callback];
}

- (void)Friends_FriendRequest_GetSentRequests:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_FriendRequest_GetSentRequests" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[self makeRequest:@"Friends_FriendRequest_GetSentRequests" params:params state:state callback:callback];
}

- (void)Friends_Friends_GetList:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_Friends_GetList" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FromDateTime=%@", [BuddyUtility encodeValue:FromDateTime]];
	[self makeRequest:@"Friends_Friends_GetList" params:params state:state callback:callback];
}

- (void)Friends_Friends_Remove:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_Friends_Remove" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&FriendProfileID=%@", [BuddyUtility encodeValue:[FriendProfileID stringValue]]];
	[self makeRequest:@"Friends_Friends_Remove" params:params state:state callback:callback];
}

- (void)Friends_Friends_Search:(NSString *)UserToken TimeFilter:(NSNumber *)TimeFilter SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude PageSize:(NSNumber *)PageSize PageNumber:(NSNumber *)PageNumber state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Friends_Friends_Search" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:[TimeFilter stringValue]]];
	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&PageSize=%@", [BuddyUtility encodeValue:[PageSize stringValue]]];
	[params appendFormat:@"&PageNumber=%@", [BuddyUtility encodeValue:[PageNumber stringValue]]];
	[self makeRequest:@"Friends_Friends_Search" params:params state:state callback:callback];
}

- (void)Game_Score_Add:(NSString *)UserTokenOrID ScoreLatitude:(double)ScoreLatitude ScoreLongitude:(double)ScoreLongitude ScoreRank:(NSString *)ScoreRank ScoreValue:(double)ScoreValue ScoreBoardName:(NSString *)ScoreBoardName ApplicationTag:(NSString *)ApplicationTag OneScorePerPlayerBit:(NSNumber *)OneScorePerPlayerBit RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Score_Add" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&ScoreLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", ScoreLatitude]]];
	[params appendFormat:@"&ScoreLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", ScoreLongitude]]];
	[params appendFormat:@"&ScoreRank=%@", [BuddyUtility encodeValue:ScoreRank]];
	[params appendFormat:@"&ScoreValue=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", ScoreValue]]];
	[params appendFormat:@"&ScoreBoardName=%@", [BuddyUtility encodeValue:ScoreBoardName]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendFormat:@"&OneScorePerPlayerBit=%@", [BuddyUtility encodeValue:[OneScorePerPlayerBit stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Score_Add" params:params state:state callback:callback];
}

- (void)Game_Score_DeleteAllScoresForUser:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Score_DeleteAllScoresForUser" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Score_DeleteAllScoresForUser" params:params state:state callback:callback];
}

- (void)Game_Score_GetBoardHighScores:(NSString *)ScoreBoardName RecordLimit:(NSNumber *)RecordLimit RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Score_GetBoardHighScores" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&ScoreBoardName=%@", [BuddyUtility encodeValue:ScoreBoardName]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Score_GetBoardHighScores" params:params state:state callback:callback];
}

- (void)Game_Score_GetScoresForUser:(NSString *)UserTokenOrID RecordLimit:(NSNumber *)RecordLimit RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Score_GetScoresForUser" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Score_GetScoresForUser" params:params state:state callback:callback];
}

- (void)Game_Score_SearchScores:(NSString *)UserTokenOrID SearchDistance:(NSNumber *)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude RecordLimit:(NSNumber *)RecordLimit SearchBoard:(NSString *)SearchBoard TimeFilter:(NSNumber *)TimeFilter MinimumScore:(NSNumber *)MinimumScore AppTag:(NSString *)AppTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Score_SearchScores" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&SearchLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", SearchLatitude]]];
	[params appendFormat:@"&SearchLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", SearchLongitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&SearchBoard=%@", [BuddyUtility encodeValue:SearchBoard]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:[TimeFilter stringValue]]];
	[params appendFormat:@"&MinimumScore=%@", [BuddyUtility encodeValue:[MinimumScore stringValue]]];
	[params appendFormat:@"&AppTag=%@", [BuddyUtility encodeValue:AppTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Score_SearchScores" params:params state:state callback:callback];
}

- (void)Game_Player_Add:(NSString *)UserTokenOrID PlayerName:(NSString *)PlayerName PlayerLatitude:(double)PlayerLatitude PlayerLongitude:(double)PlayerLongitude PlayerRank:(NSString *)PlayerRank PlayerBoardName:(NSString *)PlayerBoardName ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Player_Add" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&PlayerName=%@", [BuddyUtility encodeValue:PlayerName]];
	[params appendFormat:@"&PlayerLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", PlayerLatitude]]];
	[params appendFormat:@"&PlayerLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", PlayerLongitude]]];
	[params appendFormat:@"&PlayerRank=%@", [BuddyUtility encodeValue:PlayerRank]];
	[params appendFormat:@"&PlayerBoardName=%@", [BuddyUtility encodeValue:PlayerBoardName]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Player_Add" params:params state:state callback:callback];
}

- (void)Game_Player_Update:(NSString *)UserTokenOrID PlayerName:(NSString *)PlayerName PlayerLatitude:(double)PlayerLatitude PlayerLongitude:(double)PlayerLongitude PlayerRank:(NSString *)PlayerRank PlayerBoardName:(NSString *)PlayerBoardName ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Player_Update" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&PlayerName=%@", [BuddyUtility encodeValue:PlayerName]];
	[params appendFormat:@"&PlayerLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", PlayerLatitude]]];
	[params appendFormat:@"&PlayerLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", PlayerLongitude]]];
	[params appendFormat:@"&PlayerRank=%@", [BuddyUtility encodeValue:PlayerRank]];
	[params appendFormat:@"&PlayerBoardName=%@", [BuddyUtility encodeValue:PlayerBoardName]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Player_Update" params:params state:state callback:callback];
}

- (void)Game_Player_Delete:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Player_Delete" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Player_Delete" params:params state:state callback:callback];
}

- (void)Game_Player_GetPlayerInfo:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Player_GetPlayerInfo" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Player_GetPlayerInfo" params:params state:state callback:callback];
}

- (void)Game_Player_SearchPlayers:(NSString *)UserTokenOrID SearchDistance:(NSNumber *)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude RecordLimit:(NSNumber *)RecordLimit SearchBoard:(NSString *)SearchBoard TimeFilter:(NSNumber *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_Player_SearchPlayers" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&SearchLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", SearchLatitude]]];
	[params appendFormat:@"&SearchLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", SearchLongitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&SearchBoard=%@", [BuddyUtility encodeValue:SearchBoard]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:[TimeFilter stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_Player_SearchPlayers" params:params state:state callback:callback];
}

- (void)Game_State_GetAll:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_State_GetAll" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_State_GetAll" params:params state:state callback:callback];
}

- (void)Game_State_Get:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_State_Get" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&GameStateKey=%@", [BuddyUtility encodeValue:GameStateKey]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_State_Get" params:params state:state callback:callback];
}

- (void)Game_State_Remove:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_State_Remove" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&GameStateKey=%@", [BuddyUtility encodeValue:GameStateKey]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_State_Remove" params:params state:state callback:callback];
}

- (void)Game_State_Update:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey GameStateValue:(NSString *)GameStateValue ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_State_Update" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&GameStateKey=%@", [BuddyUtility encodeValue:GameStateKey]];
	[params appendFormat:@"&GameStateValue=%@", [BuddyUtility encodeValue:GameStateValue]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_State_Update" params:params state:state callback:callback];
}

- (void)Game_State_Add:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey GameStateValue:(NSString *)GameStateValue ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Game_State_Add" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&UserTokenOrID=%@", [BuddyUtility encodeValue:UserTokenOrID]];
	[params appendFormat:@"&GameStateKey=%@", [BuddyUtility encodeValue:GameStateKey]];
	[params appendFormat:@"&GameStateValue=%@", [BuddyUtility encodeValue:GameStateValue]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Game_State_Add" params:params state:state callback:callback];
}

- (void)Analytics_CrashRecords_Add:(NSString *)UserToken AppVersion:(NSString *)AppVersion DeviceOSVersion:(NSString *)DeviceOSVersion DeviceType:(NSString *)DeviceType MethodName:(NSString *)MethodName StackTrace:(NSString *)StackTrace Metadata:(NSString *)Metadata Latitude:(double)Latitude Longitude:(double)Longitude state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Analytics_CrashRecords_Add" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&AppVersion=%@", [BuddyUtility encodeValue:AppVersion]];
	[params appendFormat:@"&DeviceOSVersion=%@", [BuddyUtility encodeValue:DeviceOSVersion]];
	[params appendFormat:@"&DeviceType=%@", [BuddyUtility encodeValue:DeviceType]];
	[params appendFormat:@"&MethodName=%@", [BuddyUtility encodeValue:MethodName]];
	[params appendFormat:@"&StackTrace=%@", [BuddyUtility encodeValue:StackTrace]];
	[params appendFormat:@"&Metadata=%@", [BuddyUtility encodeValue:Metadata]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[self makeRequest:@"Analytics_CrashRecords_Add" params:params state:state callback:callback];
}

- (void)Analytics_DeviceInformation_Add:(NSString *)UserToken DeviceOSVersion:(NSString *)DeviceOSVersion DeviceType:(NSString *)DeviceType Latitude:(double)Latitude Longitude:(double)Longitude AppName:(NSString *)AppName AppVersion:(NSString *)AppVersion Metadata:(NSString *)Metadata state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Analytics_DeviceInformation_Add" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&DeviceOSVersion=%@", [BuddyUtility encodeValue:DeviceOSVersion]];
	[params appendFormat:@"&DeviceType=%@", [BuddyUtility encodeValue:DeviceType]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&AppName=%@", [BuddyUtility encodeValue:AppName]];
	[params appendFormat:@"&AppVersion=%@", [BuddyUtility encodeValue:AppVersion]];
	[params appendFormat:@"&Metadata=%@", [BuddyUtility encodeValue:Metadata]];
	[self makeRequest:@"Analytics_DeviceInformation_Add" params:params state:state callback:callback];
}

- (void)Analytics_Session_Start:(NSString *)UserToken SessionName:(NSString *)SessionName StartAppTag:(NSString *)StartAppTag state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Analytics_Session_Start" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SessionName=%@", [BuddyUtility encodeValue:SessionName]];
	[params appendFormat:@"&StartAppTag=%@", [BuddyUtility encodeValue:StartAppTag]];
	[self makeRequest:@"Analytics_Session_Start" params:params state:state callback:callback];
}

- (void)Analytics_Session_End:(NSString *)UserToken SessionID:(NSString *)SessionID EndAppTag:(NSString *)EndAppTag state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Analytics_Session_End" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SessionID=%@", [BuddyUtility encodeValue:SessionID]];
	[params appendFormat:@"&EndAppTag=%@", [BuddyUtility encodeValue:EndAppTag]];
	[self makeRequest:@"Analytics_Session_End" params:params state:state callback:callback];
}

- (void)Analytics_Session_RecordMetric:(NSString *)UserToken SessionID:(NSString *)SessionID MetricKey:(NSString *)MetricKey MetricValue:(NSString *)MetricValue AppTag:(NSString *)AppTag state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Analytics_Session_RecordMetric" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SessionID=%@", [BuddyUtility encodeValue:SessionID]];
	[params appendFormat:@"&MetricKey=%@", [BuddyUtility encodeValue:MetricKey]];
	[params appendFormat:@"&MetricValue=%@", [BuddyUtility encodeValue:MetricValue]];
	[params appendFormat:@"&AppTag=%@", [BuddyUtility encodeValue:AppTag]];
	[self makeRequest:@"Analytics_Session_RecordMetric" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_BatchSum:(NSString *)UserToken UserMetaKeyCollection:(NSString *)UserMetaKeyCollection SearchDistanceCollection:(NSString *)SearchDistanceCollection Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_BatchSum" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&UserMetaKeyCollection=%@", [BuddyUtility encodeValue:UserMetaKeyCollection]];
	[params appendFormat:@"&SearchDistanceCollection=%@", [BuddyUtility encodeValue:SearchDistanceCollection]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_UserMetaDataValue_BatchSum" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_Delete:(NSString *)UserToken MetaKey:(NSString *)MetaKey state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_Delete" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&MetaKey=%@", [BuddyUtility encodeValue:MetaKey]];
	[self makeRequest:@"MetaData_UserMetaDataValue_Delete" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_DeleteAll:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_DeleteAll" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"MetaData_UserMetaDataValue_DeleteAll" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_Get:(NSString *)UserToken MetaKey:(NSString *)MetaKey state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_Get" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&MetaKey=%@", [BuddyUtility encodeValue:MetaKey]];
	[self makeRequest:@"MetaData_UserMetaDataValue_Get" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_GetAll:(NSString *)UserToken state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_GetAll" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[self makeRequest:@"MetaData_UserMetaDataValue_GetAll" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_Search:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit MetaKeySearch:(NSString *)MetaKeySearch MetaValueSearch:(NSString *)MetaValueSearch TimeFilter:(NSString *)TimeFilter SortValueAsFloat:(NSNumber *)SortValueAsFloat SortDirection:(NSNumber *)SortDirection DisableCache:(NSString *)DisableCache state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_Search" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&MetaKeySearch=%@", [BuddyUtility encodeValue:MetaKeySearch]];
	[params appendFormat:@"&MetaValueSearch=%@", [BuddyUtility encodeValue:MetaValueSearch]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&SortValueAsFloat=%@", [BuddyUtility encodeValue:[SortValueAsFloat stringValue]]];
	[params appendFormat:@"&SortDirection=%@", [BuddyUtility encodeValue:[SortDirection stringValue]]];
	[params appendFormat:@"&DisableCache=%@", [BuddyUtility encodeValue:DisableCache]];
	[self makeRequest:@"MetaData_UserMetaDataValue_Search" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_Set:(NSString *)UserToken MetaKey:(NSString *)MetaKey MetaValue:(NSString *)MetaValue MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_Set" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&MetaKey=%@", [BuddyUtility encodeValue:MetaKey]];
	[params appendFormat:@"&MetaValue=%@", [BuddyUtility encodeValue:MetaValue]];
	[params appendFormat:@"&MetaLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLatitude]]];
	[params appendFormat:@"&MetaLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLongitude]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_UserMetaDataValue_Set" params:params state:state callback:callback];
}

- (void)MetaData_UserMetaDataValue_Sum:(NSString *)UserToken MetaKey:(NSString *)MetaKey SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_UserMetaDataValue_Sum" appName:client.appName appPassword:client.appPassword userToken:(NSString *)UserToken];

	[params appendFormat:@"&MetaKey=%@", [BuddyUtility encodeValue:MetaKey]];
	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:[SearchDistance stringValue]]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_UserMetaDataValue_Sum" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataCounter_Decrement:(NSString *)SocketMetaKey DecrementValueAmount:(NSString *)DecrementValueAmount MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataCounter_Decrement" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SocketMetaKey=%@", [BuddyUtility encodeValue:SocketMetaKey]];
	[params appendFormat:@"&DecrementValueAmount=%@", [BuddyUtility encodeValue:DecrementValueAmount]];
	[params appendFormat:@"&MetaLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLatitude]]];
	[params appendFormat:@"&MetaLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLongitude]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_ApplicationMetaDataCounter_Decrement" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataCounter_Increment:(NSString *)SocketMetaKey IncrementValueAmount:(NSString *)IncrementValueAmount MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataCounter_Increment" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SocketMetaKey=%@", [BuddyUtility encodeValue:SocketMetaKey]];
	[params appendFormat:@"&IncrementValueAmount=%@", [BuddyUtility encodeValue:IncrementValueAmount]];
	[params appendFormat:@"&MetaLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLatitude]]];
	[params appendFormat:@"&MetaLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLongitude]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_ApplicationMetaDataCounter_Increment" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_BatchSum:(NSString *)ApplicationMetaKeyCollection SearchDistanceCollection:(NSString *)SearchDistanceCollection Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSNumber *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_BatchSum" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&ApplicationMetaKeyCollection=%@", [BuddyUtility encodeValue:ApplicationMetaKeyCollection]];
	[params appendFormat:@"&SearchDistanceCollection=%@", [BuddyUtility encodeValue:SearchDistanceCollection]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:[TimeFilter stringValue]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_BatchSum" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_Delete:(NSString *)SocketMetaKey state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_Delete" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SocketMetaKey=%@", [BuddyUtility encodeValue:SocketMetaKey]];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_Delete" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_DeleteAll:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_DeleteAll" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"MetaData_ApplicationMetaDataValue_DeleteAll" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_Get:(NSString *)SocketMetaKey state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_Get" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SocketMetaKey=%@", [BuddyUtility encodeValue:SocketMetaKey]];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_Get" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_GetAll:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_GetAll" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"MetaData_ApplicationMetaDataValue_GetAll" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_SearchData:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit MetaKeySearch:(NSString *)MetaKeySearch MetaValueSearch:(NSString *)MetaValueSearch TimeFilter:(NSString *)TimeFilter MetaValueMin:(NSNumber *)MetaValueMin MetaValueMax:(NSNumber *)MetaValueMax SearchAsFloat:(NSNumber *)SearchAsFloat SortResultsDirection:(NSString *)SortResultsDirection DisableCache:(NSString *)DisableCache state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_SearchData" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:SearchDistance]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&MetaKeySearch=%@", [BuddyUtility encodeValue:MetaKeySearch]];
	[params appendFormat:@"&MetaValueSearch=%@", [BuddyUtility encodeValue:MetaValueSearch]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&MetaValueMin=%@", [BuddyUtility encodeValue:[MetaValueMin stringValue]]];
	[params appendFormat:@"&MetaValueMax=%@", [BuddyUtility encodeValue:[MetaValueMax stringValue]]];
	[params appendFormat:@"&SearchAsFloat=%@", [BuddyUtility encodeValue:[SearchAsFloat stringValue]]];
	[params appendFormat:@"&SortResultsDirection=%@", [BuddyUtility encodeValue:SortResultsDirection]];
	[params appendFormat:@"&DisableCache=%@", [BuddyUtility encodeValue:DisableCache]];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_SearchData" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_SearchNearby:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit MetaKeySearch:(NSString *)MetaKeySearch MetaValueSearch:(NSString *)MetaValueSearch TimeFilter:(NSString *)TimeFilter MetaValueMin:(NSNumber *)MetaValueMin MetaValueMax:(NSNumber *)MetaValueMax SortResultsDirection:(NSString *)SortResultsDirection DisableCache:(NSString *)DisableCache state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_SearchNearby" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:SearchDistance]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&RecordLimit=%@", [BuddyUtility encodeValue:[RecordLimit stringValue]]];
	[params appendFormat:@"&MetaKeySearch=%@", [BuddyUtility encodeValue:MetaKeySearch]];
	[params appendFormat:@"&MetaValueSearch=%@", [BuddyUtility encodeValue:MetaValueSearch]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&MetaValueMin=%@", [BuddyUtility encodeValue:[MetaValueMin stringValue]]];
	[params appendFormat:@"&MetaValueMax=%@", [BuddyUtility encodeValue:[MetaValueMax stringValue]]];
	[params appendFormat:@"&SortResultsDirection=%@", [BuddyUtility encodeValue:SortResultsDirection]];
	[params appendFormat:@"&DisableCache=%@", [BuddyUtility encodeValue:DisableCache]];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_SearchNearby" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_Set:(NSString *)SocketMetaKey SocketMetaValue:(NSString *)SocketMetaValue MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_Set" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SocketMetaKey=%@", [BuddyUtility encodeValue:SocketMetaKey]];
	[params appendFormat:@"&SocketMetaValue=%@", [BuddyUtility encodeValue:SocketMetaValue]];
	[params appendFormat:@"&MetaLatitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLatitude]]];
	[params appendFormat:@"&MetaLongitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", MetaLongitude]]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_Set" params:params state:state callback:callback];
}

- (void)MetaData_ApplicationMetaDataValue_Sum:(NSString *)SocketMetaKey SearchDistance:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"MetaData_ApplicationMetaDataValue_Sum" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&SocketMetaKey=%@", [BuddyUtility encodeValue:SocketMetaKey]];
	[params appendFormat:@"&SearchDistance=%@", [BuddyUtility encodeValue:SearchDistance]];
	[params appendFormat:@"&Latitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Latitude]]];
	[params appendFormat:@"&Longitude=%@", [BuddyUtility encodeValue:[NSString stringWithFormat:@"%f", Longitude]]];
	[params appendFormat:@"&TimeFilter=%@", [BuddyUtility encodeValue:TimeFilter]];
	[params appendFormat:@"&ApplicationTag=%@", [BuddyUtility encodeValue:ApplicationTag]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"MetaData_ApplicationMetaDataValue_Sum" params:params state:state callback:callback];
}

- (void)Service_DateTime_Get:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Service_DateTime_Get" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"Service_DateTime_Get" params:params state:state callback:callback];
}

- (void)Service_Ping_Get:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Service_Ping_Get" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"Service_Ping_Get" params:params state:state callback:callback];
}

- (void)Service_SocketErrorRecords_Get:(NSNumber *)RecordLimitCount state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Service_SocketErrorRecords_Get" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&RecordLimitCount=%@", [BuddyUtility encodeValue:[RecordLimitCount stringValue]]];
	[self makeRequest:@"Service_SocketErrorRecords_Get" params:params state:state callback:callback];
}

- (void)Service_Version_Get:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Service_Version_Get" appName:client.appName appPassword:client.appPassword];

	[self makeRequest:@"Service_Version_Get" params:params state:state callback:callback];
}

- (void)Application_Users_GetEmailList:(NSNumber *)FirstRow LastRow:(NSNumber *)LastRow RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Application_Users_GetEmailList" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&FirstRow=%@", [BuddyUtility encodeValue:[FirstRow stringValue]]];
	[params appendFormat:@"&LastRow=%@", [BuddyUtility encodeValue:[LastRow stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Application_Users_GetEmailList" params:params state:state callback:callback];
}

- (void)Application_Users_GetProfileList:(NSNumber *)FirstRow LastRow:(NSNumber *)LastRow RESERVED:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Application_Users_GetProfileList" appName:client.appName appPassword:client.appPassword];

	[params appendFormat:@"&FirstRow=%@", [BuddyUtility encodeValue:[FirstRow stringValue]]];
	[params appendFormat:@"&LastRow=%@", [BuddyUtility encodeValue:[LastRow stringValue]]];
	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Application_Users_GetProfileList" params:params state:state callback:callback];
}

- (void)Application_Metrics_GetStats:(NSString *)RESERVED state:(NSObject *)state callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback
{
	NSMutableString *params = [BuddyUtility setParams:@"Application_Metrics_GetStats" appName:client.appName appPassword:client.appPassword];

	[params appendString:@"&RESERVED="];
	[self makeRequest:@"Application_Metrics_GetStats" params:params state:state callback:callback];
}

@end