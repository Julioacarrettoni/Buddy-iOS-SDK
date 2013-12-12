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
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a single picture on the Buddy Platform. Pictures can be accessed through an AuthenticatedUser, either by using the photoAlbums property to retrieve
/// pictures that belong to the user, or using the SearchForAlbums method to find public pictures.
/// </summary>

@implementation BuddyPicture

@synthesize authUser;

- (void)dealloc
{
	authUser = nil;
}

- (id)initPicture:(BuddyClient *)client
		 authUser:(BuddyAuthenticatedUser *)localAuthUser
		photoList:(NSDictionary *)data;
{
	[BuddyUtility checkForNilClient:client name:@"BuddyPicture"];

	if (data == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyPicture" reason:@"Photolist"];
	}

	self = [super initPicturePublic:client
							fullUrl:[BuddyUtility stringFromString:[data objectForKey:@"fullPhotoURL"]]
					   thumbnailUrl:[BuddyUtility stringFromString:[data objectForKey:@"thumbnailPhotoURL"]]
						   latitude:[BuddyUtility doubleFromString:[data objectForKey:@"latitude"]]
						  longitude:[BuddyUtility doubleFromString:[data objectForKey:@"longitude"]]
							comment:[BuddyUtility stringFromString:[data objectForKey:@"photoComment"]]
							 appTag:[BuddyUtility stringFromString:[data objectForKey:@"applicationTag"]]
							addedOn:[BuddyUtility dateFromString:[data objectForKey:@"photoAdded"]]
							photoId:[BuddyUtility NSNumberFromStringInt:[data objectForKey:@"photoID"]]
							   user:(BuddyUser *)localAuthUser];
	if (!self)
	{
		return nil;
	}

	authUser = localAuthUser;

	return self;
}

- (void)delete:(BuddyPictureDeleteCallback)callback
{
	[BuddyUtility checkForToken:authUser.token functionName:@"BuddyPicture"];

	[[self.client webService] Pictures_Photo_Delete:authUser.token PhotoAlbumPhotoID:self.photoId 
										   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray) {
														 if (callback)
														 {
															 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														 }
													 } copy]];
}

- (void)setAppTag:(NSString *)appTag
			
		 callback:(BuddyPictureSetAppTagCallback)callback
{
	[[self.client webService] Pictures_Photo_SetAppTag:authUser.token PhotoAlbumPhotoID:self.photoId
										ApplicationTag:appTag
												 
											  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray) {
															if (callback)
															{
																callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															}
														} copy]];
}

@end
