//
//  ILServerManager.m
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import "ILServerManager.h"

@implementation ILServerManager
+(ILServerManager *) shared
{
    static dispatch_once_t pred;
    static ILServerManager *sharedManager = nil;
    
    dispatch_once(&pred, ^{ sharedManager = [[ILServerManager alloc] init]; });
    NSLog(@"%@",sharedManager);
    return sharedManager;
}
-(id) init{
    self = [super init];
    if (self) {
        [self initObjectManager];
    }
    return self;
}
-(void) initObjectManager{
    manager = [RKObjectManager managerWithBaseURL:@""];
    [RKObjectManager setSharedManager:manager];
}

@end
