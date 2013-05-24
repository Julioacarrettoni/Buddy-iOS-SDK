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

@class BuddyClient;
@class BuddyAuthenticatedUser;
@class BuddyUser;

@interface BuddyRegisteredDeviceApple ()


@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initRegisteredDeviceApple:(NSDictionary *)deviceProfile
                       authUser:(BuddyAuthenticatedUser*)authUser;

@end


#import "BuddyGameScores.h"

@interface BuddyGameScores ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyUser *user;

- (id)initGameScores:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)authUser
				user:(BuddyUser *)user;

- (NSArray *)makeScoresList:(NSArray *)data;  

@end


#import "BuddyNotificationsApple.h"

@interface BuddyNotificationsApple ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initWithClient:(BuddyClient *)client
        authUser:(BuddyAuthenticatedUser *)authUser;
@end


#import "BuddyGameScore.h"

@interface BuddyGameScore ()

- (id)initGameScore:(NSDictionary *)gameList;

@end



#import "BuddyPicturePublic.h"

@interface BuddyPicturePublic ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyUser *user;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *owner;
@property (readonly, nonatomic, strong) NSNumber *userId;

- (id)initPicturePublic:(BuddyClient *)client
				fullUrl:(NSString *)fullUrl
		   thumbnailUrl:(NSString *)thumbUrl
			   latitude:(double)latitude
			  longitude:(double)longitude
				comment:(NSString *)comment
				 appTag:(NSString *)appTag
				addedOn:(NSDate *)addedOn
				photoID:(NSNumber *)photoId
				   user:(BuddyUser *)user;

- (id)initPicturePublic:(BuddyClient *)client
		publicPhotoData:(NSDictionary *)photoData
				   user:(BuddyUser *)user;

- (id)initPicturePublic:(BuddyClient *)client
                   user:(BuddyUser *)user
  publicPhotoSearchData:(NSDictionary *)photoSearchData
                 userId:(NSNumber *)userId
               authUser:(BuddyAuthenticatedUser *)searchOwner;

- (id)initPicturePublic:(BuddyClient *)client
	   virtualPhotoList:(NSDictionary *)virtualPhotoSearchData;

@end


#import "BuddyPhotoAlbum.h"

@interface BuddyPhotoAlbum ()

@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;


- (id)initWithClient:(BuddyClient *)client
            authUser:(BuddyAuthenticatedUser *)localAuthUser
             albumId:(NSNumber *)localAlbumId
            pictures:(NSArray *)localPictures;

- (id)initWithClient:(BuddyClient *)client
            authUser:(BuddyAuthenticatedUser *)localAuthUser
             albumId:(NSNumber *)localAlbumId;

@end


#import "BuddyPhotoAlbums.h"

@interface BuddyPhotoAlbums ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

-(BuddyPhotoAlbum *)makeBuddyPhotoAlbum:(NSArray *)data albumId:(NSNumber *)albumId;

-(BuddyPhotoAlbum *) makeBuddyPhotoAlbum:(NSArray *)data;

-(NSDictionary *) makeBuddyPhotoAlbumDictionary:(NSArray *)data;

- (id)initWithAuthUser:(BuddyClient *)client
              authUser:(BuddyAuthenticatedUser *)user;
@end


#import "BuddyPhotoAlbumPublic.h"

@interface BuddyPhotoAlbumPublic ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, strong) NSMutableArray *tempPictures;

- (id)initWithClient:(BuddyClient *)client
			  userId:(NSNumber *)userId
		   albumName:(NSString *)albumName;

- (void)setPictures;

@end


#import "BuddyGameState.h"

@interface BuddyGameState ()
{
    @private NSNumber *gameStateId;
}

- (id)initGame:(NSDictionary *)gameList;

@end


#import "BuddyGameStates.h"

@interface BuddyGameStates ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyUser *user;

- (id)initGameStates:(BuddyClient *)client user:(BuddyUser *)user;

@end


#import "BuddyPlaces.h"

@interface BuddyPlaces ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initWithAuthUser:(BuddyClient *)client
			  authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeBuddyPlaceList:(NSArray *)data;

- (NSDictionary *)makeCategoryDictionary:(NSArray *)data;

- (BuddyPlace *)makeBuddyPlace:(NSArray *)data;

@end


#import "BuddyPlace.h"
@interface BuddyPlace ()


@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initPlace:(BuddyClient *)client
       authUser:(BuddyAuthenticatedUser *)authUser
   placeDetails:(NSDictionary*)data;

@end


#import "BuddyAuthenticatedUser.h"

@interface BuddyAuthenticatedUser ()
{
	@protected
        
    NSString *_email;
    BOOL _locationFuzzing;
    BOOL _celebrityMode;
    
}

- (id)initAuthenticatedUser:(NSString *)token userFullUserProfile:(NSDictionary*) profile buddyClient:(BuddyClient *)client;

- (id)initAuthenticatedUser:(BuddyClient *)client applicationUserProfile:(NSDictionary*)profile;

- (NSString *)tokenOrId;

- (NSArray *)makeLocationList:(NSArray *)data;

- (NSArray *)makeUserList:(NSArray *)data;

- (NSDictionary *)makePhotoAlbumDictionary:(NSArray *)data;

@end


#import "BuddyUser.h"

@interface BuddyUser ()
{
	@protected

	NSNumber *_userId;
	NSString *_name;
	UserGender _gender;
	NSString *_applicationTag;
	UserStatus _status;
	NSNumber *_age;
}

@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initWithUserId:(BuddyClient *)client
              userId:(NSNumber *)userId;

- (id)initWithClientPublicUserProfile:(BuddyClient *)client
						  userProfile:(NSDictionary *)profile;

- (id)initWithClientFriendList:(BuddyClient *)client
				   userProfile:(NSDictionary *)profile
						userId:(NSNumber *)userId;

- (id)initWithClientFriendRequests:(BuddyClient *)client
					   userProfile:(NSDictionary *)profile
							userId:(NSNumber *)userId;

- (id)initWithClientSearchPeople:(BuddyClient *)client
					 userProfile:(NSDictionary *)profile;

- (void)initParams:(NSDictionary *)profile;

- (id)initWithClientBlockedFriend:(BuddyClient *)client
					  userProfile:(NSDictionary *)profile;

- (NSArray *)makePictureList:(NSArray *)data;
@end


#import "BuddyCheckInLocation.h"

@interface BuddyCheckInLocation ()

- (id)initCheckInLocation:(NSDictionary *)dict;

@end

#import "BuddyBlob.h"
@interface BuddyBlob ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyUser *user;

- (id)initBlob:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)authUser
            blobList:(NSDictionary *)blobList;

@end

#import "BuddyBlobs.h"
@interface BuddyBlobs ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyUser *user;

- (id)initBlobs:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeBlobsList:(NSArray *)data;

@end

#import "BuddyVideo.h"

@interface BuddyVideo ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyUser *user;

- (id)initVideo:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)authUser
           videoList:(NSDictionary *)videoList;

@end

#import "BuddyVideos.h"

@interface BuddyVideos ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyUser *user;

- (id)initVideos:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeVideosList:(NSArray *)data;

@end

#import "BuddySounds.h"

@interface BuddySounds()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initSounds:(BuddyClient *)client
        authUser:(BuddyAuthenticatedUser *)authUser;

@end

#import "BuddyDevice.h"

@interface BuddyDevice ()

@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initWithClient:(BuddyClient *)client;

@end


#import "BuddyFriends.h"

@interface BuddyFriends ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initWithAuthUser:(BuddyClient *)client
              authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeFriendsList:(NSArray *)data;

@end


#import "BuddyFriendRequests.h"

@interface BuddyFriendRequests ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initWithAuthUser:(BuddyClient *)client
			  authUser:(BuddyAuthenticatedUser *)authUser;
@end


#import "BuddyGameBoards.h"

@interface BuddyGameBoards ()

@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initWithClient:(BuddyClient *)client;

- (NSArray *)makeScores:(NSArray *)data;

@end


#import "BuddyGroupMessage.h"

@class BuddyMessageGroup;

@interface BuddyGroupMessage ()

- (id)initWithData:(NSDictionary *)data
			 group:(BuddyMessageGroup *)group;
@end


#import "BuddyVirtualAlbum.h"

@interface BuddyVirtualAlbum ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, strong) NSMutableArray *_pictures;

- (id)   initWithAuthUser:(BuddyClient *)client
				 authUser:(BuddyAuthenticatedUser *)authUser
	virtualPhotoAlbumInfo:(NSDictionary *)virtualPhotoAlbumInfo
				 pictures:(NSArray *)pictures;

@end


#import "BuddyVirtualAlbums.h"

@interface BuddyVirtualAlbums ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initWithAuthUser:(BuddyClient *)client
			  authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeVirtualAlbumIdList:(NSArray *)data;

@end


#import "BuddyIdentityItem.h"

@interface BuddyIdentityItem ()


- (id)  initIdentityItem:(NSDictionary *)date;

@end


#import "BuddyIdentityItemSearchResult.h"

@interface BuddyIdentityItemSearchResult ()


- (id)  initSearchItem:(NSDictionary *)data;

@end


#import "BuddyIdentity.h"

@interface BuddyIdentity ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, strong) NSString *token;

- (id)  initIdentity:(BuddyClient *)client
               token:(NSString *)token;

- (NSArray *)makeIdentitySearchList:(NSArray *)data;
- (NSArray *)makeIdentityList:(NSArray *)data;

@end


#import "BuddyMessage.h"

@interface BuddyMessage ()

- (id)initFrom:(NSDictionary *)data
      toUserId:(NSNumber *)toUserId;

- (id)initTo:(NSDictionary *)data
  fromUserId:(NSNumber *)fromUserId;
@end


#import "BuddyMessageGroup.h"

@interface BuddyMessageGroup ()


@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;

- (id)initMessageGroup:(BuddyClient *)localClient
              authUser:(BuddyAuthenticatedUser *)localAuthUser
               groupId:(NSNumber *)groupId
                  name:(NSString *)name;


- (id)  initMessageGroup:(BuddyClient *)client
                authUser:(BuddyAuthenticatedUser *)authUser
             memberShips:(NSDictionary *)dict;

- (NSArray *)makeGroupMessageList:(NSArray *)data;

@end


#import "BuddyMetadataSum.h"

@interface BuddyMetadataSum ()

- (id)initMetadataSum:(NSDictionary *)data
			  keyName:(NSString *)keyName;

- (id)initMetadataSum:(NSDictionary *)data;

@end


#import "BuddyAppMetadata.h"

@interface BuddyAppMetadata ()

@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initWithClient:(BuddyClient *)localClient;

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data latitude:(double)latitude longitude:(double)longitude;

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data;

- (BuddyMetadataItem *)makeMetadataItem:(NSArray *)data;

- (NSArray *)makeMetadataSumArray:(NSArray *)data;



@end


#import "BuddyApplicationStatistics.h"

@interface BuddyApplicationStatistics ()

@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initAppData:(BuddyClient *)localClient statsData:(NSDictionary *)data;

@end


#import "BuddyUserMetadata.h"

@interface BuddyUserMetadata ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, strong) NSString *token;

- (id)initUserMetadata:(BuddyClient *)client token:(NSString *)token;

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data latitude:(double)latitude longitude:(double)longitude;

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data;

- (BuddyMetadataItem *)makeMetadataItem:(NSArray *)data;

- (NSArray *)makeMetadataSumArray:(NSArray *)data;


@end


#import "BuddyMetadataItem.h"

@class BuddyUserMetadata;
@class BuddyAppMetadata;

@interface BuddyMetadataItem ()

@property (readonly, nonatomic, assign) BuddyClient *client;
@property (readonly, nonatomic, assign) BuddyUserMetadata *owner;
@property (readonly, nonatomic, assign) BuddyAppMetadata *ownerApp;
@property (readonly, nonatomic, strong) NSString *token;

- (id)initUserMetaItem:(BuddyClient *)client
			  userMeta:(BuddyUserMetadata *)owner
		   appMetadata:(BuddyAppMetadata *)ownerApp
				 token:(NSString *)token
	searchUserMetadata:(NSDictionary *)data
		  origLatitude:(double)latitude
		 origLongitude:(double)longitude;

- (id)initAppMetaItem:(BuddyClient *)client
			 userMeta:(BuddyUserMetadata *)owner
		  appMetadata:(BuddyAppMetadata *)ownerApp
				token:(NSString *)token
	searchAppMetadata:(NSDictionary *)data
		 origLatitude:(double)latitude
		origLongitude:(double)longitude;

@end


#import "BuddyPicture.h"

@interface BuddyPicture ()

@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;


- (id)initPicture:(BuddyClient *)client
         authUser:(BuddyAuthenticatedUser *)authUser
        photoList:(NSDictionary*)photoList;

- (NSDictionary *)makeFilterDictionary:(NSArray *)data;

@end


#import "BuddyMessages.h"

@interface BuddyMessages ()

@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initWithAuthUser:(BuddyClient *)client
              authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeMessageList:(NSArray *)data;

@end


#import "BuddyMessageGroups.h"

@interface BuddyMessageGroups ()

@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)   initWithUser:(BuddyClient *)client
             authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makeMessageGroupList:(NSArray *)data;

@end


#import "BuddyGamePlayer.h"

@interface BuddyGamePlayer ()

- (id)initWithUser:(BuddyAuthenticatedUser *)authUser
	gamePlayerInfo:(NSDictionary *)dict;

- (id)             initWithUser:(BuddyAuthenticatedUser *)authUser
	gamePlayerInfoSearchResults:(NSDictionary *)dict;

@end


#import "BuddyGamePlayers.h"

@interface BuddyGamePlayers ()

@property (readonly, nonatomic, assign) BuddyAuthenticatedUser *authUser;
@property (readonly, nonatomic, assign) BuddyClient *client;

- (id)initWithAuthUser:(BuddyClient *)client
              authUser:(BuddyAuthenticatedUser *)authUser;

- (NSArray *)makePlayerList:(NSArray *)data;

@end


@class BuddyWebWrapper;

#import "BuddyClient.h"

@interface BuddyClient ()

@property (readonly, nonatomic, strong) BuddyWebWrapper *webWrapper;
@property (readonly, nonatomic, assign) BOOL recordDeviceInfo;
@property (readonly, nonatomic, assign) BOOL hasRecordedDeviceInfo;

- (void)recordDeviceInfo:(BuddyAuthenticatedUser *)authUser;

@end