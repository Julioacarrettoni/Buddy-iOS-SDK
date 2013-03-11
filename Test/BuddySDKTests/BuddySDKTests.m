/*
 * Copyright (C) 2012 Buddy Platform, Inc.
 *
 * Licensed under the BUDDY SDK LICENSE  (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.buddy.com/terms-of-service/ 
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

#import "BuddyTestAppTests.h"
#import "BuddyDataResponses.h"
#import "BuddyClient.h"
#import "BuddyUser.h"
#import "BuddyGameScores.h"
#import "BuddyAuthenticatedUser.h"
#import "BuddyPhotoAlbums.h"
#import "BuddyPhotoAlbum.h"
#import "BuddyPicture.h"
#import "BuddyPlace.h"
#import "BuddyPlaces.h"
#import "BuddyNotificationsApple.h"
#import "BuddyDevice.h"
#import "BuddyGameScore.h"





@implementation BuddyTestAppTests


+(NSArray *) GetTextFileData: (NSString *) filename
{
    NSError *error;
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
    NSData *data =[NSData dataWithContentsOfFile:sourcePath] ;
    
    id json = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&error];
    
    NSArray *resArray = [json objectForKey:@"data"];
    return resArray;
}


+(NSData *) GetPicFileData: (NSString *) filename
{
    NSString* sourcePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
    NSData *data =[NSData dataWithContentsOfFile:sourcePath] ;
    return data;
    
}



@end
