//
//  BuddySounds.h
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/23/13.
//
//

#import <Foundation/Foundation.h>

@class BuddyArrayResponse;

typedef void (^BuddySoundGetSoundCallback) (NSData *data);

typedef enum {Low=0, Medium=1, High=2} Qualities;

@interface BuddySounds : NSObject

-(void)getSound:(NSString *)soundName
        quality:(Qualities)quality
       callback:(BuddySoundGetSoundCallback)callback;

@end
