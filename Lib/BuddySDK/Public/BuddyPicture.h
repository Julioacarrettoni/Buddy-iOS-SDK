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
#import "BuddyPicturePublic.h"


@class BuddyBoolResponse;
@class BuddyDictionaryResponse;
@class BuddyPictureResponse;
@class BuddyClient;
@class BuddyPicture;



/** Callback signature for the BuddyPictureDelete function. BuddyBoolResponse.result field will be TRUE on success, FALSE otherwise. If there was an exception or error (e.g. unknown server response or invalid data) the Response.exception field will be set to an exception instance and the raw response from the server, if any, will be held in the Response.dataResult field.
 */
typedef void (^BuddyPictureDeleteCallback)(BuddyBoolResponse *response);

/** Callback signature for the BuddyPictureSetAppTag function. BuddyBoolResponse.result field will be TRUE on success, FALSE otherwise. If there was an exception or error (e.g. unknown server response or invalid data) the Response.exception field will be set to an exception instance and the raw response from the server, if any, will be held in the Response.dataResult field.
 */
typedef void (^BuddyPictureSetAppTagCallback)(BuddyBoolResponse *response);



/// <summary>
/// Represents a single picture on the Buddy Platform. pictures can be accessed through an AuthenticatedUser, either by using the photoAlbums property to retrieve
/// pictures that belong to the user, or using the SearchForAlbums method to find public pictures.
/// </summary>


/**
 * \code
 * Example:
 *  BuddyClient *bc = [[BuddyClient alloc] initClient:appName
 *                                        appPassword:appPassword];
 *
 *  [bc login:@"username" password:@"password"  callback:^(BuddyAuthenticatedUserResponse *response)
 *  {
 *      if (response.isCompleted && response.result)
 *      {   // get the user
 *          BuddyAuthenticatedUser *user = response.result;
 *
 *          [user.searchForAlbums:^(BuddyArrayResponse *response)
 *          { // get a list of public BuddyPhotoAlbums
 *              if (response.isCompleted && response.result)
 *              {
 *                  NSArray *albums = response.result;
 *                  // get the first picture from each PhotoAlbum
 *                  foreach (id _bPA  in albums)
 *                  {
 *                      BuddyPhotoAlbum *bPA =  (BuddyPhotoAlbum *)_bPA;
 *                      if ([bPA.pictures count] > 0)
 *                      {
 *                          BuddyPicture *bp =  (BuddyPicture *)[bpA.pictures objectAtIndex:0] ;
 *                          // do something with the picture
 *                      }
 *                  }
 *              }
 *          }];
 *      }
 *  }];
 * \endcode
 */

@interface BuddyPicture : BuddyPicturePublic

/// <summary>
/// Delete this picture. Note that this object will no longer be valid after this method is called. Subsequent calls will fail.
/// </summary>
/// <param name="callback">The callback to call when this method completes. BuddyBoolResponse.result field will be TRUE on success, FALSE otherwise.</param>

- (void)delete:(BuddyPictureDeleteCallback)callback;

/// <summary>
/// Sets the appTag (metadata) for an existing picture in an existing photo album, for the specified Photo ID.
/// </summary>
/// <param name="callback">The callback to call when this method completes. BuddyBoolResponse.result field will be TRUE on success, FALSE otherwise.</param>

- (void)setAppTag:(NSString *)appTag
            
         callback:(BuddyPictureSetAppTagCallback)callback;

@end