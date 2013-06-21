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


#import "BuddySounds.h"
#import "BuddyClient_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"

/// <summary>
/// Represents a class that can be used to retrieve Sounds.
/// </summary>

@implementation BuddySounds

@synthesize client;

-(void)dealloc
{
    client =nil;
}

-(id)initSounds:(BuddyClient *)localClient
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    client = (BuddyClient *)localClient;
    
    return self;
}

-(void)getSound:(NSString *)soundName
        quality:(Qualities)quality
       callback:(void(^)(NSData * data))callback
{
    NSString* qualStr;
    switch (quality) {
        case Low:
            qualStr = @"Low";
            break;
        case Medium:
            qualStr = @"Medium";
            break;
        case High:
            qualStr = @"High";
            break;
    }
    
    
    [[client webService] Sound_Sounds_GetSound:soundName Quality:qualStr callback:[^(BuddyCallbackParams *callbackParams, NSData* data){
        callback(data);
    } copy ]];
}

@end
