
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

#import <Foundation/Foundation.h>
#import "BuddyClient.h"


@class BuddyCallbackParams;

@interface BuddyWebWrapper ()

@property (readonly, nonatomic, assign) BuddyClient *client;

@property (nonatomic, assign) int http_getTimeout;

@property (nonatomic, assign) int http_postTimeout;


- (id)initWrapper:(BuddyClient *)client httpGetTimeout:(int)getTimeout httpPostTimeout:(int)postTimeout;

- (id)initWrapper:(BuddyClient *)client;

- (void)directPost:(NSString *)api path:(NSString *)path params:(NSDictionary *)params  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)setClient:(BuddyClient *)client;

- (void)UserAccount_Defines_GetStatusValues:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Identity_AddNewValue:(NSString *)UserToken IdentityValue:(NSString *)IdentityValue RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Identity_CheckForValues:(NSString *)UserToken IdentityValue:(NSString *)IdentityValue RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Identity_GetMyList:(NSString *)UserToken RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Identity_RemoveValue:(NSString *)UserToken IdentityValue:(NSString *)IdentityValue RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Location_Checkin:(NSString *)UserToken Latitude:(double)Latitude Longitude:(double)Longitude CheckInComment:(NSString *)CheckInComment ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Location_GetHistory:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_ResetPassword:(NSString *)UserName ResetCode:(NSString *)ResetCode NewPassword:(NSString *)NewPassword callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_RequestPasswordReset:(NSString *)UserName callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_CheckUserEmail:(NSString *)UserEmailToVerify RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_CheckUserName:(NSString *)UserNameToVerify RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_Create:(NSString *)NewUserName UserSuppliedPassword:(NSString *)UserSuppliedPassword NewUserGender:(NSString *)NewUserGender UserAge:(NSNumber *)UserAge NewUserEmail:(NSString *)NewUserEmail StatusID:(NSNumber *)StatusID FuzzLocationEnabled:(NSNumber *)FuzzLocationEnabled CelebModeEnabled:(NSNumber *)CelebModeEnabled ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_DeleteAccount:(NSNumber *)UserProfileID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_GetFromUserID:(NSString *)UserToken UserIDToFetch:(NSNumber *)UserIDToFetch  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_GetFromUserName:(NSString *)UserToken UserNameToFetch:(NSString *)UserNameToFetch  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_GetFromUserToken:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_GetUserIDFromUserToken:(NSString *)UserToken RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_SocialLogin:(NSString *)ProviderName ProviderUserID:(NSString *)ProviderUserId AccessToken:(NSString *)AccessToken callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_Recover:(NSString *)username UserSuppliedPassword:(NSString *)UserSuppliedPassword  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_Search:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit Gender:(NSString *)Gender AgeStart:(NSNumber *)AgeStart AgeStop:(NSNumber *)AgeStop StatusID:(NSNumber *)StatusID TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)UserAccount_Profile_Update:(NSString *)UserToken UserName:(NSString *)UserName UserSuppliedPassword:(NSString *)UserSuppliedPassword UserGender:(NSString *)UserGender UserAge:(NSNumber *)UserAge UserEmail:(NSString *)UserEmail StatusID:(NSNumber *)StatusID FuzzLocationEnabled:(NSNumber *)FuzzLocationEnabled CelebModeEnabled:(NSNumber *)CelebModeEnabled ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_Filters_ApplyFilter:(NSString *)UserToken ExistingPhotoID:(NSNumber *)ExistingPhotoID FilterName:(NSString *)FilterName FilterParameters:(NSString *)FilterParameters ReplacePhoto:(NSNumber *)ReplacePhoto  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_Filters_GetList:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_Photo_Delete:(NSString *)UserToken PhotoAlbumPhotoID:(NSNumber *)PhotoAlbumPhotoID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_Photo_Get:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID PhotoID:(NSNumber *)PhotoID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_Photo_SetAppTag:(NSString *)UserToken PhotoAlbumPhotoID:(NSNumber *)PhotoAlbumPhotoID ApplicationTag:(NSString *)ApplicationTag  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_Create:(NSString *)UserToken AlbumName:(NSString *)AlbumName PublicAlbumBit:(NSNumber *)PublicAlbumBit ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_Delete:(NSString *)UserToken PhotoAlbumID:(NSNumber *)PhotoAlbumID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_Get:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID PhotoAlbumID:(NSNumber *)PhotoAlbumID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_GetAllPictures:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID SearchFromDateTime:(NSString *)SearchFromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_GetFromAlbumName:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID PhotoAlbumName:(NSString *)PhotoAlbumName  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_GetByDateTime:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID StartDateTime:(NSString *)StartDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_PhotoAlbum_GetList:(NSString *)UserToken UserProfileID:(NSNumber *)UserProfileID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_ProfilePhoto_Add:(NSString *)UserToken bytesFullPhotoData:(NSString *)bytesFullPhotoData ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Sound_Sounds_GetSound:(NSString *)soundName quality:(NSString *)quality  callback:(void (^)(BuddyCallbackParams *callbackParams, NSData* data))callback;

- (void)Pictures_ProfilePhoto_Delete:(NSString *)UserToken ProfilePhotoID:(NSNumber *)ProfilePhotoID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_ProfilePhoto_GetAll:(NSNumber *)UserProfileID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_ProfilePhoto_GetMyList:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_ProfilePhoto_Set:(NSString *)UserToken ProfilePhotoResource:(NSString *)ProfilePhotoResource  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_SearchPhotos_Data:(NSString *)UserToken Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_SearchPhotos_Nearby:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_AddPhoto:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID ExistingPhotoID:(NSNumber *)ExistingPhotoID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_AddPhotoBatch:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID ExistingPhotoIDBatchString:(NSString *)ExistingPhotoIDBatchString RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_Create:(NSString *)UserToken AlbumName:(NSString *)AlbumName ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_DeleteAlbum:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_Get:(NSString *)UserToken VirtualPhotoAlbumID:(NSNumber *)VirtualPhotoAlbumID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_GetAlbumInformation:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_GetMyAlbums:(NSString *)UserToken RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_RemovePhoto:(NSString *)UserToken VirtualAlbumID:(NSNumber *)VirtualAlbumID ExistingPhotoID:(NSNumber *)ExistingPhotoID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_Update:(NSString *)UserToken VirtualPhotoAlbumID:(NSNumber *)VirtualPhotoAlbumID NewAlbumName:(NSString *)NewAlbumName NewAppTag:(NSString *)NewAppTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Pictures_VirtualAlbum_UpdatePhoto:(NSString *)UserToken ExistingPhotoID:(NSNumber *)ExistingPhotoID NewPhotoComment:(NSString *)NewPhotoComment NewAppTag:(NSString *)NewAppTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Category_GetList:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Category_Submit:(NSString *)UserToken NewCategoryName:(NSString *)NewCategoryName Comment:(NSString *)Comment ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Location_Add:(NSString *)UserToken Latitude:(double)Latitude Longitude:(double)Longitude LocationName:(NSString *)LocationName Address1:(NSString *)Address1 Address2:(NSString *)Address2 LocationCity:(NSString *)LocationCity LocationState:(NSString *)LocationState LocationZipPostal:(NSString *)LocationZipPostal CategoryID:(NSNumber *)CategoryID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Location_Edit:(NSString *)UserToken ExistingGeoRecordID:(NSNumber *)ExistingGeoRecordID NewLatitude:(double)NewLatitude NewLongitude:(double)NewLongitude NewLocationName:(NSString *)NewLocationName NewAddress:(NSString *)NewAddress NewLocationCity:(NSString *)NewLocationCity NewLocationState:(NSString *)NewLocationState NewLocationZipPostal:(NSString *)NewLocationZipPostal NewCategoryID:(NSString *)NewCategoryID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Location_Flag:(NSString *)UserToken ExistingGeoRecordID:(NSNumber *)ExistingGeoRecordID FlagReason:(NSString *)FlagReason  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Location_GetFromID:(NSString *)UserToken ExistingGeoID:(NSNumber *)ExistingGeoID Latitude:(double)Latitude Longitude:(double)Longitude RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Location_Search:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit SearchName:(NSString *)SearchName SearchCategoryID:(NSString *)SearchCategoryID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GeoLocation_Location_SetTag:(NSString *)UserToken ExistingGeoID:(NSNumber *)ExistingGeoID ApplicationTag:(NSString *)ApplicationTag UserTag:(NSString *)UserTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)PushNotifications_Apple_RegisterDevice:(NSString *)UserToken GroupName:(NSString *)GroupName AppleDeviceToken:(NSString *)AppleDeviceToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)PushNotifications_Apple_RemoveDevice:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)PushNotifications_Apple_SendRawMessage:(NSString *)UserTokenOrID DeliverAfter:(NSString *)DeliverAfter GroupName:(NSString *)GroupName AppleMessage:(NSString *)AppleMessage AppleBadge:(NSString *)AppleBadge AppleSound:(NSString *)AppleSound CustomItems:(NSString *)CustomItems  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)PushNotifications_Apple_GetRegisteredDevices:(NSString *)GroupName PageSize:(NSNumber *)PageSize CurrentPageNumber:(NSNumber *)CurrentPageNumber  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)PushNotifications_Apple_GetGroupNames:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Messages_SentMessages_Get:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Messages_Messages_Get:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Messages_Message_Send:(NSString *)UserToken MessageString:(NSString *)MessageString ToUserID:(NSNumber *)ToUserID ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Message_Send:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID MessageContent:(NSString *)MessageContent Latitude:(double)Latitude Longitude:(double)Longitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Message_Get:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID FromDateTime:(NSString *)FromDateTime RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Membership_RemoveUser:(NSString *)UserToken UserProfileIDToRemove:(NSNumber *)UserProfileIDToRemove GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Membership_JoinGroup:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Membership_GetMyList:(NSString *)UserToken RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Membership_GetAllGroups:(NSString *)UserToken RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Membership_DepartGroup:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Membership_AddNewMember:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID UserProfileIDToAdd:(NSNumber *)UserProfileIDToAdd RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Manage_DeleteGroup:(NSString *)UserToken GroupChatID:(NSNumber *)GroupChatID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Manage_CreateGroup:(NSString *)UserToken GroupName:(NSString *)GroupName GroupSecurity:(NSString *)GroupSecurity ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)GroupMessages_Manage_CheckForGroup:(NSString *)UserToken GroupName:(NSString *)GroupName RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_Block_Add:(NSString *)UserToken UserProfileToBlock:(NSNumber *)UserProfileToBlock ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_Block_GetList:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_Block_Remove:(NSString *)UserToken BlockedProfileID:(NSNumber *)BlockedProfileID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_FriendRequest_Accept:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_FriendRequest_Add:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_FriendRequest_Deny:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_FriendRequest_Get:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_FriendRequest_GetSentRequests:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_Friends_GetList:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_Friends_Remove:(NSString *)UserToken FriendProfileID:(NSNumber *)FriendProfileID  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Friends_Friends_Search:(NSString *)UserToken TimeFilter:(NSNumber *)TimeFilter SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude PageSize:(NSNumber *)PageSize PageNumber:(NSNumber *)PageNumber  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Score_Add:(NSString *)UserTokenOrID ScoreLatitude:(double)ScoreLatitude ScoreLongitude:(double)ScoreLongitude ScoreRank:(NSString *)ScoreRank ScoreValue:(double)ScoreValue ScoreBoardName:(NSString *)ScoreBoardName ApplicationTag:(NSString *)ApplicationTag OneScorePerPlayerBit:(NSNumber *)OneScorePerPlayerBit RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Score_DeleteAllScoresForUser:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Score_GetBoardHighScores:(NSString *)ScoreBoardName RecordLimit:(NSNumber *)RecordLimit RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Score_GetBoardLowScores:(NSString *)ScoreBoardName RecordLimit:(NSNumber *)RecordLimit RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Score_GetScoresForUser:(NSString *)UserTokenOrID RecordLimit:(NSNumber *)RecordLimit RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Score_SearchScores:(NSString *)UserTokenOrID SearchDistance:(NSNumber *)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude RecordLimit:(NSNumber *)RecordLimit SearchBoard:(NSString *)SearchBoard TimeFilter:(NSNumber *)TimeFilter MinimumScore:(NSNumber *)MinimumScore AppTag:(NSString *)AppTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Player_Add:(NSString *)UserTokenOrID PlayerName:(NSString *)PlayerName PlayerLatitude:(double)PlayerLatitude PlayerLongitude:(double)PlayerLongitude PlayerRank:(NSString *)PlayerRank PlayerBoardName:(NSString *)PlayerBoardName ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Player_Update:(NSString *)UserTokenOrID PlayerName:(NSString *)PlayerName PlayerLatitude:(double)PlayerLatitude PlayerLongitude:(double)PlayerLongitude PlayerRank:(NSString *)PlayerRank PlayerBoardName:(NSString *)PlayerBoardName ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Player_Delete:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_Player_GetPlayerInfo:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Game_Player_SearchPlayers:(NSString *)UserTokenOrID SearchDistance:(NSNumber *)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude RecordLimit:(NSNumber *)RecordLimit SearchBoard:(NSString *)SearchBoard TimeFilter:(NSNumber *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Game_State_GetAll:(NSString *)UserTokenOrID RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_State_Get:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_State_Remove:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_State_Update:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey GameStateValue:(NSString *)GameStateValue ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Game_State_Add:(NSString *)UserTokenOrID GameStateKey:(NSString *)GameStateKey GameStateValue:(NSString *)GameStateValue ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Analytics_CrashRecords_Add:(NSString *)UserToken AppVersion:(NSString *)AppVersion DeviceOSVersion:(NSString *)DeviceOSVersion DeviceType:(NSString *)DeviceType MethodName:(NSString *)MethodName StackTrace:(NSString *)StackTrace Metadata:(NSString *)Metadata Latitude:(double)Latitude Longitude:(double)Longitude  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Analytics_DeviceInformation_Add:(NSString *)UserToken DeviceOSVersion:(NSString *)DeviceOSVersion DeviceType:(NSString *)DeviceType Latitude:(double)Latitude Longitude:(double)Longitude AppName:(NSString *)AppName AppVersion:(NSString *)AppVersion Metadata:(NSString *)Metadata  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Analytics_Session_Start:(NSString *)UserToken SessionName:(NSString *)SessionName StartAppTag:(NSString *)StartAppTag  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Analytics_Session_End:(NSString *)UserToken SessionID:(NSString *)SessionID EndAppTag:(NSString *)EndAppTag  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Analytics_Session_RecordMetric:(NSString *)UserToken SessionID:(NSString *)SessionID MetricKey:(NSString *)MetricKey MetricValue:(NSString *)MetricValue AppTag:(NSString *)AppTag  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_BatchSum:(NSString *)UserToken UserMetaKeyCollection:(NSString *)UserMetaKeyCollection SearchDistanceCollection:(NSString *)SearchDistanceCollection Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_BatchSet:(NSString *)UserToken UserMetaKeyCollection:(NSString *)MetaKeys UserMetaValueCollection:(NSString *)MetaValues MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_Delete:(NSString *)UserToken MetaKey:(NSString *)MetaKey  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_DeleteAll:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_Get:(NSString *)UserToken MetaKey:(NSString *)MetaKey  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_GetAll:(NSString *)UserToken  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_Search:(NSString *)UserToken SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit MetaKeySearch:(NSString *)MetaKeySearch MetaValueSearch:(NSString *)MetaValueSearch TimeFilter:(NSString *)TimeFilter SortValueAsFloat:(NSNumber *)SortValueAsFloat SortDirection:(NSNumber *)SortDirection DisableCache:(NSString *)DisableCache  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_Set:(NSString *)UserToken MetaKey:(NSString *)MetaKey MetaValue:(NSString *)MetaValue MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_UserMetaDataValue_Sum:(NSString *)UserToken MetaKey:(NSString *)MetaKey SearchDistance:(NSNumber *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataCounter_Decrement:(NSString *)SocketMetaKey DecrementValueAmount:(NSString *)DecrementValueAmount MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataCounter_Increment:(NSString *)SocketMetaKey IncrementValueAmount:(NSString *)IncrementValueAmount MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_BatchSum:(NSString *)ApplicationMetaKeyCollection SearchDistanceCollection:(NSString *)SearchDistanceCollection Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSNumber *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_Delete:(NSString *)SocketMetaKey  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_DeleteAll:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_Get:(NSString *)SocketMetaKey  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_GetAll:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_SearchData:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit MetaKeySearch:(NSString *)MetaKeySearch MetaValueSearch:(NSString *)MetaValueSearch TimeFilter:(NSString *)TimeFilter MetaValueMin:(NSNumber *)MetaValueMin MetaValueMax:(NSNumber *)MetaValueMax SearchAsFloat:(NSNumber *)SearchAsFloat SortResultsDirection:(NSString *)SortResultsDirection DisableCache:(NSString *)DisableCache  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_SearchNearby:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit MetaKeySearch:(NSString *)MetaKeySearch MetaValueSearch:(NSString *)MetaValueSearch TimeFilter:(NSString *)TimeFilter MetaValueMin:(NSNumber *)MetaValueMin MetaValueMax:(NSNumber *)MetaValueMax SortResultsDirection:(NSString *)SortResultsDirection DisableCache:(NSString *)DisableCache  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_Set:(NSString *)SocketMetaKey SocketMetaValue:(NSString *)SocketMetaValue MetaLatitude:(double)MetaLatitude MetaLongitude:(double)MetaLongitude ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)MetaData_ApplicationMetaDataValue_Sum:(NSString *)SocketMetaKey SearchDistance:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude TimeFilter:(NSString *)TimeFilter ApplicationTag:(NSString *)ApplicationTag RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Service_DateTime_Get:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Service_Ping_Get:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Service_SocketErrorRecords_Get:(NSNumber *)RecordLimitCount  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Service_Version_Get:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Application_Users_GetEmailList:(NSNumber *)FirstRow LastRow:(NSNumber *)LastRow RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Application_Users_GetProfileList:(NSNumber *)FirstRow LastRow:(NSNumber *)LastRow RESERVED:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Application_Metrics_GetStats:(NSString *)RESERVED  callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Blobs_Blob_GetBlobInfo:(NSString *)UserToken BlobID:(NSNumber *)BlobID callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback;
- (void)Blobs_Blob_EditInfo:(NSString *)UserToken BlobID:(NSNumber *)BlobID FriendlyName:(NSString *)FriendlyName AppTag:(NSString *)AppTag callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_GetBlob:(NSString *)UserToken BlobID:(NSNumber *)BlobID callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_AddBlob:(NSString *)UserToken FriendlyName:(NSString *)FriendlyName AppTag:(NSString *)AppTag Latitude:(double)Latitude Longitude:(double)Longitude ContentType:(NSString *)ContentType BlobData:(NSData *)BlobData callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_DeleteBlob:(NSString *)UserToken BlobID:(NSNumber *)BlobID callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_SearchMyBlobs:(NSString *)UserToken FriendlyName:(NSString *)FriendlyName MimeType:(NSString *)MimeType AppTag:(NSString *)AppTag SearchDistance:(int)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude TimeFilter:(int)TimeFilter RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_SearchBlobs:(NSString *)UserToken FriendlyName:(NSString *)FriendlyName MimeType:(NSString *)MimeType AppTag:(NSString *)AppTag SearchDistance:(int)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude TimeFilter:(int)TimeFilter RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_GetBlobList:(NSString *)UserToken UserID:(NSNumber *)UserID RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Blobs_Blob_GetMyBlobList:(NSString *)UserToken RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Videos_Video_GetVideoInfo:(NSString *)UserToken VideoID:(NSNumber *)VideoID callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonString))callback;
- (void)Videos_Video_EditInfo:(NSString *)UserToken VideoID:(NSNumber *)VideoID FriendlyName:(NSString *)FriendlyName AppTag:(NSString *)AppTag callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Videos_Video_AddVideo:(NSString *)UserToken FriendlyName:(NSString *)FriendlyName AppTag:(NSString *)AppTag Latitude:(double)Latitude Longitude:(double)Longitude ContentType:(NSString *)ContentType VideoData:(NSData *)VideoData callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Videos_Video_DeleteVideo:(NSString *)UserToken VideoID:(NSNumber *)VideoID callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Videos_Video_SearchMyVideos:(NSString *)UserToken FriendlyName:(NSString *)FriendlyName MimeType:(NSString *)MimeType AppTag:(NSString *)AppTag SearchDistance:(int)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude TimeFilter:(int)TimeFilter RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Videos_Video_SearchVideos:(NSString *)UserToken FriendlyName:(NSString *)FriendlyName MimeType:(NSString *)MimeType AppTag:(NSString *)AppTag SearchDistance:(int)SearchDistance SearchLatitude:(double)SearchLatitude SearchLongitude:(double)SearchLongitude TimeFilter:(int)TimeFilter RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Videos_Video_GetVideoList:(NSString *)UserToken UserID:(NSNumber *)UserID RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Videos_Video_GetMyVideoList:(NSString *)UserToken RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Sound_Sounds_GetSound:(NSString *)SoundName Quality:(NSString *)Quality callback:(void (^)(BuddyCallbackParams * callbackParams, id jsonArray))callback;

- (void)StartupData_Location_GetMetroList:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)StartupData_Location_Search:(NSString *)UserToken SearchDistance:(NSString *)SearchDistance Latitude:(double)Latitude Longitude:(double)Longitude RecordLimit:(NSNumber *)RecordLimit SearchName: (NSString *)SearchName callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)StartupData_Location_GetFromMetroArea:(NSString *)UserToken MetroName:(NSString *)MetroName RecordLimit:(int)RecordLimit callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

- (void)Commerce_Receipt_Save:(NSString *)UserToken ReceiptData:(NSString *)ReceiptData CustomTransactionID:(NSString *)CustomTransactionID AppData:(NSString *)AppData TotalCost:(NSString *)TotalCost TotalQuantity:(int)TotalQuantity StoreItemID:(NSString *)StoreItemID StoreName:(NSString *)StoreName callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Commerce_Receipt_GetForUserAndTransactionID:(NSString *)UserToken CustomTransactionID:(NSString *)CustomTransactionID callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Commerce_Receipt_GetForUser:(NSString *)UserToken FromDateTime:(NSString *)FromDateTime callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Commerce_Store_GetAllItems:(NSString *)UserToken callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Commerce_Store_GetActiveItems:(NSString *)UserToken callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;
- (void)Commerce_Store_GetFreeItems:(NSString *)UserToken callback:(void (^)(BuddyCallbackParams *callbackParams, id jsonArray))callback;

@end
