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
#import "BuddyClient_Exn.h"
#import "BuddyUtility.h"


@implementation BuddyRegisteredDeviceApple

@synthesize authUser;
@synthesize APNSDeviceToken;
@synthesize groupName;
@synthesize lastUpdateDate;
@synthesize registrationDate;
@synthesize userId;

- (id)initRegisteredDeviceApple:(NSDictionary *)deviceProfile
                       authUser:(BuddyAuthenticatedUser*)localAuthUser
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    [BuddyUtility checkForNilUser:localAuthUser name:@"BuddyRegisteredDeviceApple"];
 
    if (deviceProfile == nil)
    {
       [BuddyUtility throwNilArgException:@"BuddyRegisteredDeviceApple" reason: @"deviceProfile"];
    } 
    
    authUser = localAuthUser;
    
    userId = [BuddyUtility NSNumberFromStringInt:[deviceProfile objectForKey:@"userID"]];
    APNSDeviceToken = [BuddyUtility stringFromString: [deviceProfile objectForKey:@"aPNSDeviceToken"]];  
    groupName = [BuddyUtility stringFromString: [deviceProfile objectForKey:@"groupName"]];
    lastUpdateDate = [BuddyUtility dateFromString: [deviceProfile objectForKey:@"deviceModified"]];
    registrationDate = [BuddyUtility dateFromString: [deviceProfile objectForKey:@"deviceRegistered"]];
      
    return self;
}

- (void)dealloc
{
    authUser = nil;
}

- (NSString *)userIdAsString
{
    return [userId stringValue];
}

@end