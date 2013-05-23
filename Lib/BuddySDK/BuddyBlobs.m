//
//  BuddyBlobs.m
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/16/13.
//
//

#import "BuddyBlobs.h"
#import "BuddyBlob.h"
#import "BuddyClient_Exn.h"

@implementation BuddyBlobs

@synthesize client;
@synthesize authUser;

-(id)initBlobs:(BuddyClient *)localClient
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

-(NSArray *)makeBlobsList:(NSArray *)data
{
    NSMutableArray *blobs = [[NSMutableArray alloc] init];
    
    if(data && [data isKindOfClass:[NSArray class]])
    {
        int i = (int)[data count];
        for (int j = 0; j < i; j++)
        {
            NSDictionary *dict = (NSDictionary *) [data objectAtIndex:(unsigned int)j];
            if(dict && [dict count] > 0)
            {
                BuddyBlob * blob = [[BuddyBlob alloc] initBlob:self.client authUser:self.authUser blobList:(NSDictionary *)dict];
                if(blob)
                {
                    [blobs addObject:blob];
                }
            }
        }
    }
        
    return blobs;
}

-(void)addBlob:(NSString *)friendlyName
        appTag:(NSString *)appTag
      latitude:(double)latitude
     longtidue:(double)longitude
      mimeType:(NSString *)mimeType
      blobData:(NSData *)blobData
{
    [[client webService] Blobs_Blob_AddBlob:authUser.token FriendlyName:friendlyName AppTag:appTag Latitude:latitude Longitude:longitude BlobData:blobData]
}

@end