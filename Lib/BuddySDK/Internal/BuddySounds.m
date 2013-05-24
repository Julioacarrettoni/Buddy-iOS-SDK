//
//  BuddySounds.m
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/23/13.
//
//

#import "BuddySounds.h"
#import "BuddyClient_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"

@implementation BuddySounds

@synthesize client;
@synthesize authUser;

-(void)dealloc
{
    client =nil;
    authUser=nil;
}

-(id)initSounds:(BuddyClient *)localClient
       authUser:(BuddyAuthenticatedUser *)localAuthUser
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    client = (BuddyClient *)localClient;
    authUser = (BuddyAuthenticatedUser *)localAuthUser;
    
    return self;
}

-(void)getSound:(NSString *)soundName
        quality:(Qualities)quality
       callback:(void(^)(NSData *))callback
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
    
    
    [[client webService] Sound_Sounds_GetSound:soundName Quality:qualStr callback:[^(BuddyCallbackParams *callbackParams, id jsonArray){
        //TODO
    } copy ]];
}

@end
