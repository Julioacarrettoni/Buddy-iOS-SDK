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
/// Represents a public user profile. Public user profiles are usually returned when looking at an AuthenticatedUser's friends or making a search with FindUser.
/// </summary>

@implementation BuddyUser

@synthesize client;
@synthesize name = _name;
@synthesize userId = _userId;
@synthesize gender = _gender;
@synthesize applicationTag = _applicationTag;
@synthesize latitude;
@synthesize longitude;
@synthesize lastLoginOn;
@synthesize profilePicture;
@synthesize profilePictureId;
@synthesize age = _age;
@synthesize status = _status;
@synthesize createdOn;
@synthesize distanceInKilometers;
@synthesize distanceInMeters;
@synthesize distanceInMiles;
@synthesize distanceInYards;
@synthesize friendRequestPending;
@synthesize gameScores;
@synthesize gameStates;

- (NSString *)tokenOrId
{
	return [self.userId stringValue];
}

- (NSString *)toString
{
	NSString *createDate = [NSDateFormatter localizedStringFromDate:self.createdOn dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];

	NSString *lastLoginDate = [NSDateFormatter localizedStringFromDate:self.lastLoginOn dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];

	NSMutableString *params = [[NSMutableString alloc] init];

	[params appendFormat:@"[%d], ", [self.userId intValue]];
	[params appendFormat:@"name: %@, ", self.name];
	[params appendFormat:@"gender: %@, ", [BuddyUtility UserGenderToString:self.gender]];
	[params appendFormat:@"applicationTag: %@, ", self.applicationTag];
	[params appendFormat:@"latitude: %f, ", self.latitude];
	[params appendFormat:@"longitude: %f, ", self.latitude];
	[params appendFormat:@"createdOn: %@, ", createDate];
	[params appendFormat:@"lastLoginOn: %@, ", lastLoginDate];
	[params appendFormat:@"profilePicture: %@, ", [self.profilePicture absoluteURL]];
	[params appendFormat:@"age: %d, ", [self.age intValue]];
	[params appendFormat:@"status: %d", [BuddyUtility UserStatusToInteger:self.status]];

	return params;
}

- (id)initWithUserId:(BuddyClient *)localClient
			  userId:(NSNumber *)userId
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyUser"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	_userId = userId;

	gameScores = [[BuddyGameScores alloc] initGameScores:localClient authUser:nil user:self];
	gameStates = [[BuddyGameStates alloc] initGameStates:localClient user:self];

	return self;
}

- (id)initWithClientPublicUserProfile:(BuddyClient *)localClient
						  userProfile:(NSDictionary *)profile;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (profile == nil || [profile count] == 0)
	{
		return self;
	}

	NSString *userId = [profile objectForKey:@"userId"];
	if ([BuddyUtility isNilOrEmpty:userId])
	{
		[BuddyUtility throwNilArgException:@"BuddyUser" reason:@"userId"];
	}

	NSNumber *uid = [NSNumber numberWithInt:[userId intValue]];

	self = [self initWithUserId:localClient userId:uid];
	[self initParams:profile];

	return self;
}

- (void)dealloc
{
	client = nil;
}

- (void)initParams:(NSDictionary *)profile
{
	_name = [BuddyUtility stringFromString:[profile objectForKey:@"userName"]];
	_gender = [BuddyUtility stringToUserGender:[BuddyUtility stringFromString:[profile objectForKey:@"userGender"]]];
	_applicationTag = [BuddyUtility stringFromString:[profile objectForKey:@"userApplicationTag"]];
	latitude = [BuddyUtility doubleFromString:[profile objectForKey:@"userLatitude"]];
	longitude = [BuddyUtility doubleFromString:[profile objectForKey:@"userLongitude"]];
	lastLoginOn = [BuddyUtility dateFromString:[profile objectForKey:@"lastLoginDate"]];

	profilePicture = [NSURL URLWithString:[BuddyUtility stringFromString:[profile objectForKey:@"profilePictureUrl"]]];
	if (!profilePicture.scheme || !profilePicture.host)
	{
		profilePicture = nil;
		profilePictureId = [BuddyUtility stringFromString:[profile objectForKey:@"profilePictureUrl"]];
	}

	createdOn = [BuddyUtility dateFromString:[profile objectForKey:@"createdDate"]];
	_status = [BuddyUtility stringToUserStatus:[BuddyUtility stringFromString:[profile objectForKey:@"statusID"]]];
	_age = [BuddyUtility NSNumberFromStringInt:[profile objectForKey:@"age"]];

	friendRequestPending = FALSE;
}

- (id)initWithClientFriendList:(BuddyClient *)localClient
				   userProfile:(NSDictionary *)profile
						userId:(NSNumber *)userId;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	self = [self completeInit:localClient userProfile:profile userId:userId];
	[self initParams:(NSMutableDictionary *)profile];

	friendRequestPending = FALSE;
	_status = UserStatus_AnyUserStatus;

	return self;
}

- (id)initWithClientFriendRequests:(BuddyClient *)localClient
					   userProfile:(NSDictionary *)profile
							userId:(NSNumber *)userId;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	self = [self completeInit:localClient userProfile:profile userId:userId];
	[self initParams:profile];

	return self;
}

- (id)initWithClientBlockedFriend:(BuddyClient *)localClient
					  userProfile:(NSDictionary *)profile
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	NSString *userId = [profile objectForKey:@"userID"];
	NSNumber *userIdString = [NSNumber numberWithInt:[userId intValue]];

	self = [self initWithUserId:localClient userId:userIdString];
	friendRequestPending = FALSE;
	[self initParams:profile];

	return self;
}

- (id)completeInit:(BuddyClient *)localClient
	   userProfile:(NSDictionary *)profile
			userId:(NSNumber *)userId
{
	if (profile == (NSDictionary *)[NSNull null] || profile == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyUser" reason:@"userProfile"];
	}

	NSString *friendIdString = [profile objectForKey:@"friendID"];
	NSNumber *friendId = [NSNumber numberWithInt:[friendIdString intValue]];

	NSString *userIdString = [profile objectForKey:@"userID"];
	NSNumber *userIdTemp = [NSNumber numberWithInt:[userIdString intValue]];

	NSNumber *tempUserId = [NSNumber numberWithInt:[friendId intValue] == [userId intValue] ? [userIdTemp intValue]:[friendId intValue]];

	if ([tempUserId intValue] == 0)
	{
		[BuddyUtility throwNilArgException:@"BuddyUser" reason:@"userId"];
	}

	return [self initWithUserId:localClient userId:tempUserId];
}

- (id)initWithClientSearchPeople:(BuddyClient *)localClient
					 userProfile:(NSDictionary *)profile;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	self = [self completeInit:localClient userProfile:profile userId:0];
	[self initParams:profile];

	_userId = [BuddyUtility NSNumberFromStringInt:[profile objectForKey:@"userID"]];

	distanceInKilometers = [BuddyUtility doubleFromString:[profile objectForKey:@"distanceInKilometers"]];
	distanceInMeters = [BuddyUtility doubleFromString:[profile objectForKey:@"distanceInMeters"]];
	distanceInMiles = [BuddyUtility doubleFromString:[profile objectForKey:@"distanceInMiles"]];
	distanceInYards = [BuddyUtility doubleFromString:[profile objectForKey:@"distanceInYards"]];

	return self;
}

- (NSArray *)makePictureList:(NSArray *)data
{
	NSMutableArray *pictures = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict != nil && [dict count] > 0)
			{
				BuddyPicturePublic *picture = [[BuddyPicturePublic alloc] initPicturePublic:client publicPhotoData:dict user:self];
				if (picture)
				{
					[pictures addObject:picture];
				}
			}
		}
	}

	return pictures;
}

- (void)getProfilePhotos:(BuddyUserGetProfilePhotosCallback)callback
{
	__block BuddyUser *_self = self;

	[[client webService] Pictures_ProfilePhoto_GetAll:self.userId 
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
																	   data = [_self makePictureList:jsonArray];
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