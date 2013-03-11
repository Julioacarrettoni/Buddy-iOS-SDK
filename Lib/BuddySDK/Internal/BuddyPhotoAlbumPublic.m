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


/// <summary>
/// Represents a public photo album. Public albums are returned from album searches.
/// </summary>

@implementation BuddyPhotoAlbumPublic

@synthesize client;
@synthesize userId;
@synthesize albumName;
@synthesize pictures = _pictures;
@synthesize tempPictures;

- (id)initWithClient:(BuddyClient *)localClient
              userId:(NSNumber *)localUserId
		   albumName:(NSString *)localAlbumName
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyPhotoAlbumPublic"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	userId = localUserId;
	albumName =  localAlbumName;
	tempPictures = [[NSMutableArray alloc] init];

	return self;
}

- (void)dealloc
{
	client = nil;
}

- (void)setPictures
{
	if (self.tempPictures != nil)
	{
		self->_pictures = [[NSArray alloc] initWithArray:tempPictures];
	}
}

@end