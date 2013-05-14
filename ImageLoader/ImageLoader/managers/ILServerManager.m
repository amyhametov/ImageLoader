//
//  ILServerManager.m
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import "ILServerManager.h"
#import "ILROImageList.h"
#import "ILROImage.h"

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
    manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString: @"https://raw.github.com/zeit9eist/ImageLoader/master/json/"]];
    [manager.router.routeSet addRoute:[RKRoute
                                             routeWithClass:[ILROImageList class]
                                             pathPattern:@"fortest.txt"
                                             method:RKRequestMethodGET]] ;
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];

    [RKObjectManager setSharedManager:manager];

}
-(void) loadImageList{
    
    RKObjectMapping *mappingImageList = [RKObjectMapping mappingForClass:[ILROImageList class]];
    RKObjectMapping *mappingImage  = [RKObjectMapping mappingForClass:[ILROImage class]];
    [mappingImage addAttributeMappingsFromArray:[NSArray arrayWithObjects: @"name",@"url", nil]];
    [mappingImageList addRelationshipMappingWithSourceKeyPath:@"list" mapping:mappingImage];
    [manager addResponseDescriptor:
     [RKResponseDescriptor responseDescriptorWithMapping:mappingImageList pathPattern:nil keyPath:nil statusCodes:nil]];
    
    ILROImageList *imageList = [[ILROImageList alloc] init];

    [manager getObject:imageList path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:imageList.list forKey:@"list"];
        [[NSNotificationCenter defaultCenter] postNotificationName:nImagesLoaded object:self userInfo:userInfo];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
}

@end
