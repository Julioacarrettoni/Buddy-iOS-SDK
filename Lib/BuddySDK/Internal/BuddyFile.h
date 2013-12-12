//
//  BuddyFile.h
//  BuddySDK
//
//  Created by Shawn Burke on 5/22/13.
//
//

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIImage.h>
#else
#import <AppKit/NSImage.h>
#endif

@interface BuddyFile : NSObject
@property(nonatomic, retain) NSData* data;
@property(nonatomic, retain) NSString* contentType;
@property(nonatomic, retain) NSString* fileName;

-(id)init;
#if __IPHONE_OS_VERSION_MIN_REQUIRED
-(id)initWithImage:(UIImage*)image;
#else
-(id)initWithImage:(NSImage*)image;
#endif
-(id)initWithData:(NSData*)data contentType:(NSString*)contentType fileName:(NSString*) fileName;

@end
