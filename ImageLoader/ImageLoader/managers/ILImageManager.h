//
//  ILImageManager.h
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestQueue.h"

@interface ILImageManager : NSObject
@property (nonatomic,retain) RequestQueue *queue;

+(ILImageManager *) shared;
-(void) cacheImageURL:(NSString*)url withImageView:(id)view andProgress:(UIProgressView *) progressBar;
-(void) clearCache;
@end
