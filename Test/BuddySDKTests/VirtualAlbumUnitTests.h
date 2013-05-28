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

#import <SenTestingKit/SenTestingKit.h>


@class BuddyPicture;
@class BuddyAuthenticatedUser;
@class BuddyVirtualAlbum;
@class BuddyClient;
@class BuddyVirtualAlbums;


@interface VirtualAlbumUnitTests : SenTestCase

@property (nonatomic, strong) BuddyPicture *picture;

@property (nonatomic, strong) BuddyAuthenticatedUser *buddyUser;

@property (nonatomic, strong) BuddyVirtualAlbum *virtualAlbum;

@property (nonatomic, strong) BuddyClient *buddyClient;

@property (nonatomic, strong) BuddyVirtualAlbums *virtualAlbums;

@property (nonatomic, strong) NSArray *virtualAlbumArray;

@end
