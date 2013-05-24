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
/// Represents the main class and entry point to the Buddy platform. Use this class to interact with the platform, create and login users and modify general
/// application level properties like Devices and Metadata.
/// </summary>

@implementation BuddyClient

@synthesize appName = _appName;
@synthesize appPassword = _appPassword;
@synthesize appVersion = _appVersion;
@synthesize device = _device;
@synthesize gameBoards = _gameBoards;
@synthesize metadata = _metadata;
@synthesize webWrapper = _webWrapper;

@synthesize recordDeviceInfo;
@synthesize hasRecordedDeviceInfo;

- (BuddyWebWrapper *)webService
{
	if (_webWrapper == nil)
	{
		_webWrapper = [[BuddyWebWrapper alloc] initWrapper:self];
	}

	return _webWrapper;
}

- (id)initClient:(NSString *)appName
	 appPassword:(NSString *)appPassword
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	[self doInit:appName password:appPassword version:nil];

	recordDeviceInfo = true;

	return self;
}

- (void)recordDeviceInfo:(BuddyAuthenticatedUser *)authUser
{
	NSString *osVersion  = [BuddyUtility osVersion];
	NSString *device     = [BuddyUtility deviceName];
	NSString *appVersion = [BuddyUtility appVersion];

	NSString *bundleIdentifier = (__bridge NSString *)(CFBundleGetIdentifier(CFBundleGetMainBundle()));

	[self.device recordInformation:osVersion
						deviceType:device
						  authUser:authUser
						appVersion:appVersion
						  latitude:0.0
						 longitude:0.0
						  metadata:bundleIdentifier
							 state:nil
						  callback:[^(BuddyBoolResponse *response)
									{
										if (response.isCompleted && response.result == FALSE)
										{
	                                        // ignore errors
										}
									} copy]];
}

- (id)        initClient:(NSString *)appName
			 appPassword:(NSString *)appPassword
			  appVersion:(NSString *)appVersion
	autoRecordDeviceInfo:(BOOL)autoRecordDeviceInfo
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	[self doInit:appName password:appPassword version:appVersion];

	recordDeviceInfo = autoRecordDeviceInfo;

	return self;
}

- (void)doInit:(NSString *)appName
	  password:(NSString *)appPassword
	   version:(NSString *)appVersion
{
	if (appName == nil || appName.length == 0)
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"appName"];
	}

	if (appPassword == nil || appPassword.length == 0)
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"appPassword"];
	}

	if (appVersion == nil || appVersion.length == 0)
	{
		_appVersion = @"1.0";
	}
	else
	{
		_appVersion = appVersion;
	}

	_appName = appName;
	_appPassword = appPassword;

	_device = [[BuddyDevice alloc] initWithClient:self];
	_gameBoards = [[BuddyGameBoards alloc] initWithClient:self];
	_metadata = [[BuddyAppMetadata alloc] initWithClient:self];
}

- (id)init
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	[[self webService] setClient:self];

	return self;
}

- (void)dealloc
{
	_webWrapper = nil;
	_device = nil;
	_gameBoards = nil;
	_metadata = nil;
	_appVersion = nil;
	_appName = nil;
	_appPassword = nil;
}

- (void)ping:(NSObject *)state
	callback:(BuddyClientPingCallback)callback
{
	[[self webService] Service_Ping_Get:state
							   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
										 {
											 if (callback)
											 {
												 callback([[BuddyStringResponse alloc] initWithResponse:callbackParams result:callbackParams.stringResult]);
											 }
										 } copy]];
}

- (void)getServiceTime:(NSObject *)state
			  callback:(BuddyClientGetServiceTimeCallback)callback
{
	[[self webService] Service_DateTime_Get:state
								   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
											 {
												 if (callback)
												 {
													 NSDate *date;
													 if (callbackParams.isCompleted)
													 {
														 date = [BuddyUtility buddyDate:callbackParams.stringResult];
													 }

													 if (date)
													 {
														 callback([[BuddyDateResponse alloc] initWithResponse:callbackParams result:date]);
													 }
													 else
													 {
														 NSException *exception = [BuddyUtility buildBuddyServiceException:@"Invalid date." ];
														 callback([[BuddyDateResponse alloc] initWithParam:FALSE exception:exception state:state]);
													 }
												 }
											 } copy]];
}

- (void)getServiceVersion:(NSObject *)state
				 callback:(BuddyClientGetServiceVersionCallback)callback
{
	[[self webService] Service_Version_Get:state
								  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
											{
												if (callback)
												{
													callback([[BuddyStringResponse alloc] initWithResponse:callbackParams
																									result:(NSString *)callbackParams.stringResult]);
												}
											} copy]];
}

- (NSArray *)makeEmailList:(NSArray *)data
{
	NSMutableArray *emails = [[NSMutableArray alloc] init];

	if (data && [data count] > 0)
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict == nil || [dict count] == 0)
			{
				continue;
			}

			NSString *emailAddress = [BuddyUtility stringFromString:[dict objectForKey:@"userEmail"]];
			if (emailAddress != nil && [emailAddress length] > 0)
			{
				[emails addObject:emailAddress];
			}
		}
	}

	return emails;
}

- (void)getUserEmails:(NSNumber *)fromRow
			 callback:(BuddyClientGetUserEmailsCallback)callback
{
	[self getUserEmails:fromRow pageSize:nil state:nil callback:callback];
}

- (void)getUserEmails:(NSNumber *)fromRow
			 pageSize:(NSNumber *)pageSize
				state:(NSObject *)state
			 callback:(BuddyClientGetUserEmailsCallback)callback
{
	if (fromRow == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"GetUserEmails fromRow"];
	}

	if (pageSize == nil)
	{
		pageSize = [NSNumber numberWithInt:10];
	}

	NSNumber *lastRow = [NSNumber numberWithInt:[fromRow intValue] + [pageSize intValue]];

	__block BuddyClient *_self = self;

	[[self webService] Application_Users_GetEmailList:fromRow LastRow:lastRow RESERVED:@"" state:state
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
																	   data = [_self makeEmailList:jsonArray];
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
																												  result:data]);
															   }
														   }
														   _self = nil;
													   } copy]];
}

- (void)getUserProfiles:(NSNumber *)fromRow
			   callback:(BuddyClientGetUserProfilesCallback)callback
{
	[self getUserProfiles:fromRow pageSize:nil state:nil callback:callback];
}

- (void)getUserProfiles:(NSNumber *)fromRow
			   pageSize:(NSNumber *)pageSize
				  state:(NSObject *)state
			   callback:(BuddyClientGetUserProfilesCallback)callback
{
	if (fromRow == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"GetUserProfiles fromRow"];
	}

	if (pageSize == nil)
	{
		pageSize = [NSNumber numberWithInt:10];
	}

	NSNumber *lastRow = [NSNumber numberWithInt:[fromRow intValue] + [pageSize intValue]];

	__block BuddyClient *_self = self;

	[[self webService] Application_Users_GetProfileList:fromRow LastRow:lastRow RESERVED:@"" state:state
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
																		 data = [_self makeBuddyUserList:jsonArray];
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
																	 callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams result:data]);
																 }
															 }
															 _self = nil;
														 } copy]];
}

- (NSArray *)makeBuddyUserList:(NSArray *)data
{
	NSMutableArray *users = [[NSMutableArray alloc] init];

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
			BuddyUser *buddyUser = [[BuddyUser alloc] initWithClientBlockedFriend:self userProfile:dict];
			if (buddyUser)
			{
				[users addObject:buddyUser];
			}
		}
	}

	return users;
}

- (NSArray *)makeApplicationStatistics:(NSArray *)data
{
	NSMutableArray *applicationStatistics = [[NSMutableArray alloc] init];

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
			BuddyApplicationStatistics *applicationStatistic = [[BuddyApplicationStatistics alloc] initAppData:self statsData:dict];
			if (applicationStatistic)
			{
				[applicationStatistics addObject:applicationStatistic];
			}
		}
	}

	return applicationStatistics;
}

- (void)getApplicationStatistics:(NSObject *)state
						callback:(BuddyClientGetApplicationStatisticsCallback)callback

{
	__block BuddyClient *_self = self;

	[[self webService] Application_Metrics_GetStats:@"" state:state
										   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													 {
														 if (callback)
														 {
															 NSArray *applicationStatistics;
															 NSException *exception;
															 @try
															 {
																 if (callbackParams.isCompleted && jsonArray != nil)
																 {
																	 applicationStatistics = [_self makeApplicationStatistics:jsonArray];
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
																												result:applicationStatistics]);
															 }
														 }
														 _self = nil;
													 } copy]];
}

- (void)login:(NSString *)userName
	 password:(NSString *)password
		state:(NSObject *)state
	 callback:(BuddyClientLoginCallback)callback
{
	[self checkUserName:userName functionName:@"Login"];

	if ([BuddyUtility isNilOrEmpty:password])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"Login password"];
	}

	__block BuddyClient *_self = self;

	[[self webService] UserAccount_Profile_Recover:userName UserSuppliedPassword:password state:state
										  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													{
														if (callback)
														{
															if (callbackParams.isCompleted)
															{
																NSString *dataResult = (NSString *)callbackParams.stringResult;
																if ([dataResult hasPrefix:@"UT-"])
																{
																	[_self login:dataResult state:state callback:^(BuddyAuthenticatedUserResponse *result) {
										callback(result);
									}];
																}
																else
																{
																	callback([[BuddyAuthenticatedUserResponse alloc] initWithError:callbackParams
																															reason:callbackParams.stringResult]);
																}
															}
															else
															{
																callback([[BuddyAuthenticatedUserResponse alloc] initWithError:
																		  callbackParams                                reason:(NSString *)callbackParams.exception.reason]);
															}
														}
														_self = nil;
													} copy]];
}

- (void)login:(NSString *)token
		state:(NSObject *)state
	 callback:(BuddyClientLoginCallback)callback
{
	[BuddyUtility checkForToken:token functionName:@"Login"];

	__block BuddyClient *_self = self;
	__block NSString *_token = token;

	[[self webService] UserAccount_Profile_GetFromUserToken:token state:state
												   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															 {
																 if (callback)
																 {
																	 BuddyAuthenticatedUser *authUser;
																	 NSException *exception;
																	 @try
																	 {
																		 if (callbackParams.isCompleted && jsonArray != nil && [jsonArray count] > 0)
																		 {
																			 NSDictionary *dict = (NSDictionary *)[jsonArray objectAtIndex:0];
																			 if (dict && [dict count] > 0)
																			 {
																				 authUser = [[BuddyAuthenticatedUser alloc]
												   initAuthenticatedUser:_token userFullUserProfile:dict buddyClient:_self];

																				 if (recordDeviceInfo && hasRecordedDeviceInfo == FALSE)
																				 {
																					 hasRecordedDeviceInfo = TRUE;
																					 [self recordDeviceInfo:authUser];
																				 }
																			 }
																		 }
																	 }
																	 @catch (NSException *ex)
																	 {
																		 exception = ex;
																	 }

																	 if (exception)
																	 {
																		 callback([[BuddyAuthenticatedUserResponse alloc] initWithError:exception
																																  state:callbackParams.state
																																apiCall:callbackParams.apiCall]);
																	 }
																	 else
																	 {
																		 callback([[BuddyAuthenticatedUserResponse alloc] initWithResponse:callbackParams
																																	result:authUser]);
																	 }
																 }
																 _token = nil;
																 _self = nil;
															 } copy]];
}

- (void)InternalCreateUser:(NSString *)userName
				  password:(NSString *)password
					gender:(UserGender)gender
					   age:(NSNumber *)age
					 email:(NSString *)email
					status:(UserStatus)status
			  fuzzLocation:(BOOL)fuzzLocation
			 celebrityMode:(BOOL)celebMode
					appTag:(NSString *)appTag
					 state:(NSObject *)state
				  callback:(void (^)(BuddyStringResponse *response))block
{
	[[self webService] UserAccount_Profile_Create:userName
							 UserSuppliedPassword:password
									NewUserGender:[BuddyUtility UserGenderToString:gender]
										  UserAge:age
									 NewUserEmail:email
										 StatusID:[NSNumber numberWithInt:[BuddyUtility UserStatusToInteger:status]]
							  FuzzLocationEnabled:[NSNumber numberWithBool:fuzzLocation]
								 CelebModeEnabled:[NSNumber numberWithBool:celebMode]
								   ApplicationTag:appTag
										 RESERVED:@""
											state:state
										 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
												   {
													   if (callbackParams.isCompleted && block)
													   {
														   NSString *dataResult = (NSString *)callbackParams.stringResult;
														   if ([dataResult hasPrefix:@"UT-"])
														   {
															   block([[BuddyStringResponse alloc] initWithResponse:callbackParams result:dataResult]);
														   }
														   else
														   {
															   block([[BuddyStringResponse alloc] initWithError:callbackParams reason:dataResult]);
														   }
													   }
													   else
													   {
														   if (block)
														   {
															   block([[BuddyStringResponse alloc] initWithError:callbackParams reason:(NSString *)callbackParams.exception.reason]);
														   }
													   }
												   } copy]];
}

- (void)createUser:(NSString *)userName
		  password:(NSString *)password
		  callback:(BuddyClientCreateUserCallback)callback
{
	NSNumber *age = [NSNumber numberWithInt:0];

	[self createUser:userName password:password gender:UserGender_Any age:age email:nil status:UserStatus_AnyUserStatus fuzzLocation:FALSE celebrityMode:FALSE appTag:nil state:nil callback:callback];
}

- (void)createUser:(NSString *)userName
		  password:(NSString *)password
			gender:(UserGender)gender
			   age:(NSNumber *)age
			 email:(NSString *)email
			status:(UserStatus)status
	  fuzzLocation:(BOOL)fuzzLocation
	 celebrityMode:(BOOL)celebrityMode
			appTag:(NSString *)appTag
			 state:(NSObject *)state
		  callback:(BuddyClientCreateUserCallback)callback
{
	[self checkUserName:userName functionName:@"CreateUser"];

	if ([BuddyUtility isNilOrEmpty:password])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"CreateUser password"];
	}

	if (age == nil || [age intValue] < 0)
	{
		[BuddyUtility throwInvalidArgException:@"BuddyClient" reason:@"CreateUser age: can't be nil or less than 0."];
	}

	__block BuddyClient *_self = self;

	[self InternalCreateUser:userName password:password gender:gender age:age email:email status:status fuzzLocation:fuzzLocation celebrityMode:celebrityMode appTag:appTag state:state
					callback:[^(BuddyStringResponse *response) {
								  if (response.isCompleted && response.result != nil)
								  {
									  NSString *token = (NSString *)response.result;
									  [_self login:token state:state callback:^(BuddyAuthenticatedUserResponse *authResponse)
							{
								if (authResponse != nil && authResponse.isCompleted)
								{
									if (callback)
									{
										callback(authResponse);
									}
								}
							}];
								  }
								  else
								  {
	                                  // failed to get UserToken...
									  if (callback)
									  {
										  callback([[BuddyAuthenticatedUserResponse alloc] initWithError:response.apiCall reason:response.exception.reason state:response.state]);
									  }
								  }
								  _self = nil;
							  } copy]];
}

- (void)checkIfEmailExists:(NSString *)email
					 state:(NSObject *)state
				  callback:(BuddyClientCheckIfEmailExistsCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:email])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"CheckIfEmailExists email"];
	}

	[[self webService] UserAccount_Profile_CheckUserEmail:email RESERVED:@"" state:state
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   BOOL emailExists = FALSE;
																   NSString *dataResult = callbackParams.stringResult;
																   NSException *exception;
																   if ([dataResult isEqualToString:@"UserEmailTaken"])
																   {
																	   emailExists = TRUE;
																   }
																   else
																   {
																	   if (![dataResult isEqualToString:@"UserEmailAvailable"])
																	   {
																		   exception = [BuddyUtility buildBuddyUnknownErrorException:dataResult];
																	   }
																   }
																   if (exception)
																   {
																	   callback([[BuddyBoolResponse alloc] initUnKnownErrorResponse:callbackParams exception:exception]);
																   }
																   else
																   {
																	   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams localResult:emailExists]);
																   }
															   }
														   } copy]];
}

- (void)CheckIfUsernameExists:(NSString *)userName
						state:(NSObject *)state
					 callback:(void (^)(BuddyBoolResponse *response))block
{
	[self checkUserName:userName functionName:@"CheckIfUsernameExists"];

	[[self webService] UserAccount_Profile_CheckUserName:userName RESERVED:@"" state:state
												callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														  {
															  if (block)
															  {
																  BOOL userNameExists = FALSE;
																  NSString *dataResult = callbackParams.stringResult;
																  NSException *exception;
																  if ([dataResult isEqualToString:@"UserNameAlreadyInUse"])
																  {
																	  userNameExists = TRUE;
																  }
																  else if (![dataResult isEqualToString:@"UserNameAvailble"])                                                                 // misspelling is on purpose                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              // intentional misspelling due to backward compatibility
																  {
																	  exception = [BuddyUtility buildBuddyUnknownErrorException:dataResult];
																  }

																  if (exception)
																  {
																	  block([[BuddyBoolResponse alloc] initUnKnownErrorResponse:callbackParams exception:exception]);
																  }
																  else
																  {
																	  block([[BuddyBoolResponse alloc] initWithResponse:callbackParams localResult:userNameExists]);
																  }
															  }
														  } copy]];
}

- (void)StartSession:(BuddyAuthenticatedUser *)user
		 sessionName:(NSString *)sessionName
			callback:(void (^)(BuddyStringResponse *response))block
{
	[self StartSession:user sessionName:sessionName appTag:nil state:nil callback:block];
}

- (void)StartSession:(BuddyAuthenticatedUser *)user
		 sessionName:(NSString *)sessionName
			  appTag:(NSString *)appTag
			   state:(NSObject *)state
			callback:(void (^)(BuddyStringResponse *response))block
{
	[self checkUser:user name:@"StartSession"];

	if ([BuddyUtility isNilOrEmpty:sessionName])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"StartSession sessionName"];
	}

	[[self webService] Analytics_Session_Start:user.token SessionName:sessionName StartAppTag:appTag state:state
									  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
												{
													if (block)
													{
														NSString *dataResult = (NSString *)callbackParams.stringResult;
														if (![BuddyUtility isAStandardError:dataResult])
														{
															block([[BuddyStringResponse alloc] initWithResponse:callbackParams result:dataResult]);
														}
														else
														{
															block([[BuddyStringResponse alloc] initWithError:callbackParams reason:dataResult]);
														}
													}
												} copy]];
}

- (void)EndSession:(BuddyAuthenticatedUser *)user
		 sessionId:(NSString *)sessionId
		  callback:(void (^)(BuddyBoolResponse *response))block
{
	[self EndSession:user sessionId:sessionId appTag:nil state:nil callback:block];
}

- (void)EndSession:(BuddyAuthenticatedUser *)user
		 sessionId:(NSString *)sessionId
			appTag:(NSString *)appTag
			 state:(NSObject *)state
		  callback:(void (^)(BuddyBoolResponse *response))block
{
	[self checkUser:user name:@"EndSession"];

	if ([BuddyUtility isNilOrEmpty:sessionId])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"EndSession sessionId"];
	}

	[[self webService] Analytics_Session_End:user.token SessionID:sessionId EndAppTag:appTag state:state
									callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
											  {
												  if (block)
												  {
													  block([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
												  }
											  } copy]];
}

- (void)checkUser:(BuddyAuthenticatedUser *)user name:(NSString *)name
{
	if (user == nil || [BuddyUtility isNilOrEmpty:user.token])
	{
		[BuddyUtility throwInvalidArgException:name reason:@"user: A BuddyAuthenticatedUser value is required for parameter user."];
	}
}

- (void)checkUserName:(NSString *)user functionName:(NSString *)functionName
{
	if ([BuddyUtility isNilOrEmpty:user])
	{
		[BuddyUtility throwInvalidArgException:functionName reason:@"user name can't be nil or empty."];
	}
}

- (void)RecordSessionMetric:(BuddyAuthenticatedUser *)user
				  sessionId:(NSString *)sessionId
				  metricKey:(NSString *)metricKey
				metricValue:(NSString *)metricValue
				   callback:(void (^)(BuddyBoolResponse *response))block
{
	[self RecordSessionMetric:user sessionId:sessionId metricKey:metricKey metricValue:metricValue appTag:nil state:nil callback:block];
}

- (void)RecordSessionMetric:(BuddyAuthenticatedUser *)user
				  sessionId:(NSString *)sessionId
				  metricKey:(NSString *)metricKey
				metricValue:(NSString *)metricValue
					 appTag:(NSString *)appTag
					  state:(NSObject *)state
				   callback:(void (^)(BuddyBoolResponse *response))block
{
	[self checkUser:user name:@"RecordSessionMetric"];

	if ([BuddyUtility isNilOrEmpty:metricKey])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"RecordSessionMetric metricKey"];
	}

	if ([BuddyUtility isNilOrEmpty:metricValue])
	{
		[BuddyUtility throwNilArgException:@"BuddyClient" reason:@"RecordSessionMetric metricValue"];
	}

	[[self webService] Analytics_Session_RecordMetric:user.token SessionID:sessionId MetricKey:metricKey MetricValue:metricValue AppTag:appTag state:state
											 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													   {
														   if (block)
														   {
															   block([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														   }
													   } copy]];
}

@end