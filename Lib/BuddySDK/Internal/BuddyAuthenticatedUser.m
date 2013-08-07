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

#import "BuddyClient.h"
#import "BuddyUtility.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a user that has been authenticated with the Buddy Platform. Use this object to interact with the service on behalf of the user.
/// </summary>

@implementation BuddyAuthenticatedUser

@synthesize token;
@synthesize email = _email;
@synthesize locationFuzzing = _locationFuzzing;
@synthesize celebrityMode = _celebrityMode;
@synthesize pushNotifications;
@synthesize photoAlbums;
@synthesize places;
@synthesize identityValues;
@synthesize metadata;
@synthesize virtualAlbums;
@synthesize friends;
@synthesize messages;
@synthesize gamePlayers;
@synthesize blobs;
@synthesize videos;
@synthesize startups;
@synthesize commerce;

- (NSString *)toString
{
	NSMutableString *params = [[NSMutableString alloc] init];

	[params appendFormat:@"%@, ", [super toString]];
	[params appendFormat:@"email: %@, ", self.email];
	[params appendFormat:@"locationFuzzing: %@, ",  self.locationFuzzing ? @"TRUE":@"FALSE"];
	[params appendFormat:@"celebrityMode: %@",  self.celebrityMode ? @"TRUE":@"FALSE"];

	return params;
}

- (id)initAuthenticatedUser:(NSString *)localToken
		userFullUserProfile:(NSDictionary *)profile
				buddyClient:(BuddyClient *)localClient
{
	if (profile == (NSDictionary *)[NSNull null] || profile == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyAuthenticatedUser" reason:@"profile"];
	}

	[BuddyUtility checkForToken:localToken functionName:@"BuddyAuthenticatedUser"];

	NSNumber *userId = [BuddyUtility NSNumberFromStringInt:[profile objectForKey:@"userID"]];

	self = [super initWithUserId:localClient userId:userId];

	token = localToken;

	pushNotifications = [[BuddyNotificationsApple alloc] initWithClient:localClient authUser:self];

	photoAlbums = [[BuddyPhotoAlbums alloc] initWithAuthUser:localClient authUser:self];

	places = [[BuddyPlaces alloc] initWithAuthUser:localClient authUser:self];

	identityValues = [[BuddyIdentity alloc] initIdentity:localClient token:self.token];

	virtualAlbums = [[BuddyVirtualAlbums alloc] initWithAuthUser:localClient authUser:self];

	friends = [[BuddyFriends alloc] initWithAuthUser:localClient authUser:self];

	metadata = [[BuddyUserMetadata alloc] initUserMetadata:localClient token:localToken];

	messages = [[BuddyMessages alloc] initWithAuthUser:localClient authUser:self];

	gamePlayers = [[BuddyGamePlayers alloc] initWithAuthUser:localClient authUser:self];
    
    blobs = [[BuddyBlobs alloc] initBlobs:localClient authUser:self];
    
    videos = [[BuddyVideos alloc] initVideos:localClient authUser:self];

    startups  = [[BuddyStartups alloc] initWithAuthUser:localClient authUser:self];
    
    commerce = [[BuddyCommerce alloc] initWithAuthUser:localClient authUser:self];
    
	[self updateFromProfile:profile];

	return self;
}

- (NSString *)tokenOrId
{
	return self.token;
}

- (void)updateFromProfile:(NSDictionary *)profile
{
	[self initParams:(NSDictionary *)profile];

	_userId = [BuddyUtility NSNumberFromStringInt:[profile objectForKey:@"userID"]];

	_email = [BuddyUtility stringFromString:[profile objectForKey:@"userEmail"]];

	_locationFuzzing = [BuddyUtility boolFromString:[profile objectForKey:@"locationFuzzing"]];

	_celebrityMode = [BuddyUtility boolFromString:[profile objectForKey:@"celebMode"]];
}

- (id)initAuthenticatedUser:(BuddyClient *)client applicationUserProfile:(NSDictionary *)profile
{
	if (profile == (NSDictionary *)[NSNull null] || profile == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyAuthenticatedUser" reason:@"profile"];
	}

	self = [self initWithUserId:client userId:[BuddyUtility NSNumberFromStringInt:[profile objectForKey:@"userId"]]];

	token = @"";

	[self updateFromProfile:profile];

	return self;
}

- (void)findUser:(NSNumber *)userId
		   
		callback:(BuddyAuthenticatedUserFindUserCallback)callback
{
	if (userId == nil || [userId intValue] <= 0)
	{
		[BuddyUtility throwInvalidArgException:@"BuddyAuthenticatedUser" reason:@"userId can't be <= 0"];
	}

	__block BuddyAuthenticatedUser *_self = self;

	[[self.client webService] UserAccount_Profile_GetFromUserID:self.token UserIDToFetch:userId 
													   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																 {
																	 if (callback)
																	 {
																		 BuddyUser *buddyUser;
																		 NSException *exception;
																		 @try
																		 {
																			 if (callbackParams.isCompleted && jsonArray != nil && [jsonArray count] > 0)
																			 {
																				 buddyUser = [[BuddyUser alloc] initWithClientPublicUserProfile:_self.client userProfile:(NSDictionary *)[jsonArray objectAtIndex:0]];
																			 }
																		 }
																		 @catch (NSException *ex)
																		 {
																			 exception = ex;
																		 }

																		 if (exception)
																		 {
																			 callback([[BuddyUserResponse alloc] initWithError:exception
																														 
																													   apiCall:callbackParams.apiCall]);
																		 }
																		 else
																		 {
																			 callback([[BuddyUserResponse alloc] initWithResponse:callbackParams
																														   result:buddyUser]);
																		 }
																	 }
																	 _self = nil;
																 } copy]];
}

- (NSArray *)makeUserList:(NSArray *)data
{
	NSMutableArray *users = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyUser *buddyUser = [[BuddyUser alloc] initWithClientSearchPeople:self.client userProfile:dict];
				if (buddyUser)
				{
					[users addObject:buddyUser];
				}
			}
		}
	}
	return users;
}

- (void)  findUser:(double)latitude
		 longitude:(double)longitude
	searchDistance:(NSNumber *)searchDistance
		  callback:(BuddyAuthenticatedUserFindUsersCallback)callback
{
	[self findUser:latitude longitude:longitude searchDistance:searchDistance recordLimit:nil gender:UserGender_Any ageStart:nil ageStop:nil userStatus:UserStatus_AnyUserStatus checkinsWithinMinutes:nil appTag:nil  callback:callback];
}

- (void)         findUser:(double)latitude
				longitude:(double)longitude
		   searchDistance:(NSNumber *)searchDistance
			  recordLimit:(NSNumber *)recordLimit
				   gender:(UserGender)gender
				 ageStart:(NSNumber *)ageStart
				  ageStop:(NSNumber *)ageStop
			   userStatus:(UserStatus)userStatus
	checkinsWithinMinutes:(NSNumber *)checkinsWithinMinutes
				   appTag:(NSString *)appTag
					
				 callback:(BuddyAuthenticatedUserFindUsersCallback)callback
{
	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyAuthenticatedUser"];

	if (ageStop == nil)
	{
		ageStop = [NSNumber numberWithInt:200];
	}

	if (ageStart == nil)
	{
		ageStart = [NSNumber numberWithInt:0];
	}

	if (searchDistance == nil)
	{
		searchDistance = [NSNumber numberWithInt:40075000];
	}

	if (checkinsWithinMinutes == nil)
	{
		checkinsWithinMinutes = [NSNumber numberWithInt:-1];
	}

	if (recordLimit == nil)
	{
		recordLimit = [NSNumber numberWithInt:10];
	}

	NSNumber *statusInt = [NSNumber numberWithInt:[BuddyUtility UserStatusToInteger:userStatus]];
	NSString *genderString = [BuddyUtility UserGenderToString:gender];
	NSString *timeFilter = [NSString stringWithFormat:@"%d", [checkinsWithinMinutes intValue]];

	__block BuddyAuthenticatedUser *_self = self;

	[[self.client webService] UserAccount_Profile_Search:self.token SearchDistance:searchDistance Latitude:latitude Longitude:longitude RecordLimit:recordLimit Gender:genderString AgeStart:ageStart AgeStop:ageStop StatusID:statusInt TimeFilter:timeFilter ApplicationTag:appTag RESERVED:@"" 
												callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														  {
															  if (callback)
															  {
																  NSArray *users;
																  NSException *exception;
																  @try
																  {
																	  if (callbackParams.isCompleted && jsonArray != nil)
																	  {
																		  users = [_self makeUserList:jsonArray];
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
																													 result:users]);
																  }
															  }
															  _self = nil;
														  } copy]];
}

- (void)addProfilePhoto:(NSData *)blob
			   callback:(BuddyAuthenticatedUserAddProfilePhotoCallback)callback
{
	[self addProfilePhoto:blob appTag:nil  callback:callback];
}

- (void)addProfilePhoto:(NSData *)blob
				 appTag:(NSString *)appTag
				  
			   callback:(BuddyAuthenticatedUserAddProfilePhotoCallback)callback
{
	[BuddyUtility checkBlobParam:blob functionName:@"BuddyAuthenticatedUser"];

	if (appTag == nil)
	{
		appTag = @"";
	}

	NSString *encodedBlob = [BuddyUtility encodeBlob:blob];

	NSMutableString *path = [[NSMutableString alloc] init];
	[path appendFormat:@"?%@", kPictures_ProfilePhoto_Add];

	NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
								[BuddyUtility encodeValue:self.client.appName], @"BuddyApplicationName",
								[BuddyUtility encodeValue:self.client.appPassword], @"BuddyApplicationPassword",
								[BuddyUtility encodeValue:self.token], @"UserToken",
								encodedBlob, @"bytesFullPhotoData",
								[BuddyUtility encodeValue:appTag], @"ApplicationTag",
								@"", @"RESERVED",
								nil];

	[[self.client webService] directPost:kPictures_ProfilePhoto_Add
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

- (void)checkIn:(double)latitude
	  longitude:(double)longitude
	   callback:(BuddyAuthenticatedUserCheckInCallback)callback
{
	[self checkIn:latitude longitude:longitude comment:nil appTag:nil  callback:callback];
}

- (void)checkIn:(double)latitude
	  longitude:(double)longitude
		comment:(NSString *)comment
		 appTag:(NSString *)appTag
		  
	   callback:(BuddyAuthenticatedUserCheckInCallback)callback
{
	[[self.client webService] UserAccount_Location_Checkin:self.token Latitude:latitude Longitude:longitude CheckInComment:comment ApplicationTag:appTag RESERVED:@"" 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (NSArray *)makeLocationList:(NSArray *)data
{
	NSMutableArray *locations = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyCheckInLocation *checkIn = [[BuddyCheckInLocation alloc] initCheckInLocation:dict];
				if (checkIn)
				{
					[locations addObject:checkIn];
				}
			}
		}
	}
	return locations;
}

- (void)getCheckins:(BuddyAuthenticatedUserGetCheckinsCallback)callback
{
	[self getCheckins:nil  callback:callback];
}

- (void)getCheckins:(NSDate *)afterDate
			  
		   callback:(BuddyAuthenticatedUserGetCheckinsCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *afterDateString = [BuddyUtility buddyDateToString:afterDate];

	__block BuddyAuthenticatedUser *_self = self;

	[[self.client webService] UserAccount_Location_GetHistory:self.token FromDateTime:afterDateString 
													 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															   {
																   if (callback)
																   {
																	   NSArray *locations;
																	   NSException *exception;
																	   @try
																	   {
																		   if (callbackParams.isCompleted && jsonArray != nil)
																		   {
																			   locations = [_self makeLocationList:jsonArray];
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
																														  result:locations]);
																	   }
																   }
																   _self = nil;
															   } copy]];
}

- (void)   update:(NSString *)name
		 password:(NSString *)password
		   gender:(UserGender)gender
			  age:(NSNumber *)age
			email:(NSString *)email
	   userStatus:(UserStatus)status
	 fuzzLocation:(BOOL)fuzzLocation
	celebrityMode:(BOOL)celebrityMode
		   appTag:(NSString *)appTag
			
		 callback:(BuddyAuthenticatedUserUpdateCallback)callback
{
	if (age == nil)
	{
		age = [NSNumber numberWithInt:0];
	}

	NSNumber *statusInt = [NSNumber numberWithInt:[BuddyUtility UserStatusToInteger:status]];
	NSString *genderString = [BuddyUtility UserGenderToString:gender];
	NSNumber *fuzzLocationInt = (fuzzLocation == TRUE) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
	NSNumber *celebrityModeInt = (celebrityMode == TRUE) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];

	__block BuddyAuthenticatedUser *_self = self;

	[[self.client webService] UserAccount_Profile_Update:self.token UserName:name UserSuppliedPassword:password UserGender:genderString UserAge:age UserEmail:email StatusID:statusInt FuzzLocationEnabled:fuzzLocationInt CelebModeEnabled:celebrityModeInt ApplicationTag:appTag RESERVED:@"" 
												callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														  {
															  if (callback)
															  {
																  BOOL resultSucceeded = FALSE;
																  if (callbackParams.isCompleted)
																  {
																	  if ([callbackParams.stringResult isEqualToString:@"1"])
																	  {
																		  resultSucceeded = TRUE;
																		  if (name != nil && [name length] > 0)
																		  {
																			  _self->_name = name;
																		  }
																		  if (gender != UserGender_Any)
																		  {
																			  _self->_gender = gender;
																		  }
																		  if (appTag != nil && [appTag length] > 0)
																		  {
																			  _self->_applicationTag = appTag;
																		  }
																		  if (status != UserStatus_AnyUserStatus)
																		  {
																			  _self->_status = status;
																		  }
																		  self->_locationFuzzing = fuzzLocation;
																		  self->_celebrityMode = celebrityMode;
																		  if (email != nil && [email length] > 0)
																		  {
																			  _self->_email = email;
																		  }
																		  if ([age intValue] != -1)
																		  {
																			  _self->_age = age;
																		  }
																	  }
																  }
																  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams localResult:resultSucceeded]);
															  }
															  _self = nil;
														  } copy]];
}

- (void)delete:(BuddyAuthenticatedUserDeleteCallback)callback
{
	[[self.client webService] UserAccount_Profile_DeleteAccount:self.userId 
													   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																 {
																	 if (callback)
																	 {
																		 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																	 }
																 } copy]];
}

- (void)getPicture:(NSNumber *)pictureId
			 
		  callback:(BuddyAuthenticatedUserGetPictureCallback)callback
{
	if (pictureId == nil || [pictureId intValue] < 0)
	{
		[BuddyUtility throwInvalidArgException:@"BuddyAuthenticatedUser" reason:@"pictureId: can't be smaller than 0."];
	}

	__block BuddyAuthenticatedUser *_self = self;

	[[self.client webService] Pictures_Photo_Get:self.token UserProfileID:self.userId PhotoID:pictureId 
										callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
												  {
													  if (callback)
													  {
														  BuddyPicture *picture;
														  NSException *exception;
														  @try
														  {
															  if (callbackParams.isCompleted && jsonArray != nil)
															  {
																  if ([jsonArray isKindOfClass:[NSArray class]] && [jsonArray count] > 0)
																  {
																	  picture = [[BuddyPicture alloc] initPicture:_self.client authUser:_self photoList:[jsonArray objectAtIndex:0]];
																  }
															  }
														  }
														  @catch (NSException *ex)
														  {
															  exception = ex;
														  }

														  if (exception)
														  {
															  callback([[BuddyPictureResponse alloc] initWithError:exception
																											 
																										   apiCall:callbackParams.apiCall]);
														  }
														  else
														  {
															  callback([[BuddyPictureResponse alloc] initWithResponse:callbackParams
																											   result:picture]);
														  }
													  }
													  _self = nil;
												  } copy]];
}

- (NSDictionary *)makePhotoAlbumDictionary:(NSArray *)data
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

			NSString *albumName = [[NSString alloc] initWithString:[BuddyUtility stringFromString:[dict objectForKey:@"photoAlbumName"]]];
			NSNumber *userProfileId = [BuddyUtility NSNumberFromStringInt:[dict objectForKey:@"userProfileId"]];

			if ([BuddyUtility isNilOrEmpty:albumName] || [albumName isEqualToString:@"0"])
			{
				continue;
			}

			if ([dictOut objectForKey:albumName] == nil)
			{
				BuddyPhotoAlbumPublic *publicAlbum = [[BuddyPhotoAlbumPublic alloc] initWithClient:self.client userId:userProfileId albumName:albumName];
				if (publicAlbum)
				{
					[dictOut setObject:publicAlbum forKey:albumName];
				}
			}

			BuddyPicturePublic *publicPicture = [[BuddyPicturePublic alloc] initPicturePublic:self.client user:nil publicPhotoSearchData:dict userId:userProfileId authUser:self];

			BuddyPhotoAlbumPublic *publicPhotoAlbum = [dictOut objectForKey:albumName];
			if (publicPhotoAlbum != nil)
			{
				[publicPhotoAlbum.tempPictures addObject:publicPicture];
			}
		}

		for (id key in dictOut)
		{
			BuddyPhotoAlbumPublic *publicPhotoAlbum = (BuddyPhotoAlbumPublic *)[dictOut objectForKey:key];
			[publicPhotoAlbum setPictures];
		}
	}

	return dictOut;
}

- (void)searchForAlbums:(BuddyAuthenticatedUserSearchForAlbumsCallback)callback
{
	[self searchForAlbums:nil latitude:0.0 longitude:0.0 limitResults:nil  callback:callback];
}

- (void)searchForAlbums:(NSNumber *)searchDistanceInMeters
			   latitude:(double)latitude
			  longitude:(double)longitude
		   limitResults:(NSNumber *)resultsLimit
				  
			   callback:(BuddyAuthenticatedUserSearchForAlbumsCallback)callback
{
	if (searchDistanceInMeters == nil)
	{
		searchDistanceInMeters = [NSNumber numberWithInt:99999999];
	}

	if (resultsLimit == nil)
	{
		resultsLimit = [NSNumber numberWithInt:50];
	}

	__block BuddyAuthenticatedUser *_self = self;

	[[self.client webService] Pictures_SearchPhotos_Nearby:self.token SearchDistance:searchDistanceInMeters Latitude:latitude Longitude:longitude RecordLimit:resultsLimit 
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
																			dict = [_self makePhotoAlbumDictionary:jsonArray];
																		}
																	}
																	@catch (NSException *ex)
																	{
																		exception = ex;
																	}

																	if (exception)
																	{
																		callback([[BuddyDictionaryResponse alloc] initWithError:exception
																														  
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

- (void)deleteProfilePhoto:(BuddyPicturePublic *)picture
					 
				  callback:(BuddyAuthenticatedUserDeleteProfilePhotoCallback)callback
{
	if (picture == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyAuthenticatedUser" reason:@"picture"];
	}

	[[self.client webService] Pictures_ProfilePhoto_Delete:self.token ProfilePhotoID:picture.photoId 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (void)setProfilePhoto:(BuddyPicturePublic *)picture
				  
			   callback:(BuddyAuthenticatedUserSetProfilePhotoCallback)callback
{
	if (picture == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyAuthenticatedUser" reason:@"picture"];
	}

	NSString *photoId = [NSString stringWithFormat:@"%d", [picture.photoId intValue]];

	[[self.client webService] Pictures_ProfilePhoto_Set:self.token ProfilePhotoResource:photoId 
											   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														 {
															 if (callback)
															 {
																 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															 }
														 } copy]];
}

@end
