//
//  BuddyBlob.m
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/15/13.
//
//

#import "BuddyBlob.h"
#import "BuddyUtility.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyWebWrapper.h"
#import "BuddyClient_Exn.h"

@implementation BuddyBlob

@synthesize client;
@synthesize authUser;

@synthesize blobId;
@synthesize friendlyName;
@synthesize mimeType;
@synthesize fileSize;
@synthesize appTag;
@synthesize owner;
@synthesize latitude;
@synthesize longitude;
@synthesize uploadDate;
@synthesize lastTouchDate;

- (id)initBlob:(BuddyClient *)localClient authUser:(BuddyAuthenticatedUser *)localAuthUser blobList:(NSDictionary *)blobList
{
        self = [super init];
        if(!self)
            {
                    return nil;
                }
    
        if (blobList == nil || [blobList count] == 0)
            {
                    return self;
                }
        client = (BuddyClient *)localClient;
        authUser = (BuddyAuthenticatedUser *)localAuthUser;
        blobId = [BuddyUtility NSNumberFromStringLong :[blobList objectForKey:@"blobID"]];
        friendlyName = [BuddyUtility stringFromString :[blobList objectForKey:@"friendlyName"]];
        mimeType = [BuddyUtility stringFromString: [blobList objectForKey:@"mimeType"]];
        fileSize = [BuddyUtility NSNumberFromStringInt: [blobList objectForKey:@"fileSize"]];
        appTag = [BuddyUtility stringFromString:[blobList objectForKey:@"appTag"]];
        owner = [BuddyUtility NSNumberFromStringLong:[blobList objectForKey:@"owner"]];
        latitude = [BuddyUtility doubleFromString:[blobList objectForKey:@"latitude"]];
        longitude = [BuddyUtility doubleFromString:[blobList objectForKey:@"longitude"]];
        uploadDate = [BuddyUtility dateFromString:[blobList objectForKey:@"uploadDate"]];
        lastTouchDate =[BuddyUtility dateFromString:[blobList objectForKey:@"lastTouchDate"]];
    
        return self;
    }

-(void)getBlob:(BuddyBlobGetBlobCallback)callback
{
    }

-(void)editBlob:(NSString *)friendlyName
         appTag:(NSString *)appTag
       callback:(BuddyBlobEditBlobCallback)callback
{
    }

-(void)deleteBlob:(BuddyBlobDeleteBlobCallback)callback
{}

@end