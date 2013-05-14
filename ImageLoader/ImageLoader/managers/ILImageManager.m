//
//  ILImageManager.m
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import "ILImageManager.h"

@implementation ILImageManager
@synthesize queue;

+(ILImageManager *) shared
{
    static dispatch_once_t pred;
    static ILImageManager *sharedManager = nil;
    
    dispatch_once(&pred, ^{ sharedManager = [[ILImageManager alloc] init]; });
    return sharedManager;
}
-(id) init
{
    self = [super init];
    
    if (self)
    {
        queue = [[RequestQueue alloc] init];
    }
    return self;
}

-(void) cacheImageURL:(NSString*)url withImageView:(id)view{
    
    if (url!=nil){
        NSMutableString *fileName= [NSMutableString stringWithString:url];
        [fileName replaceOccurrencesOfString:@"//" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [fileName length])];
        [fileName replaceOccurrencesOfString:@"/" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [fileName length])];
        [fileName replaceOccurrencesOfString:@":" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [fileName length])];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths lastObject];
        NSString *storePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];        
        BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:storePath isDirectory:NO];
        
        if(isFile)
        {
            UIImage *image = [UIImage imageWithContentsOfFile:storePath];
            if (image){
                NSLog(@"load from file");
                if ([view isMemberOfClass:[UIImageView class]]) {
                    ((UIImageView *)view).image = image;
                }
                if ([view isMemberOfClass:[UIWebView class]]) {
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:storePath]];
                    NSData *data = [NSData dataWithContentsOfFile:storePath];
                    [(UIWebView *)view loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];                    
                }
            }
        }
        else
        {
            
            NSLog(@"START %@",url);
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            [queue addRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (data && error==nil)
                {
                    NSLog(@"Image loaded %@",response.URL.absoluteString);
                    [data writeToFile:storePath atomically:YES];
                    if ([view isMemberOfClass:[UIImageView class]]) {
                        ((UIImageView *)view).image = [UIImage imageWithData:data];
                    }
                    if ([view isMemberOfClass:[UIWebView class]]) {
                        [(UIWebView *)view loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                        
                    }
                }
                else{
                    NSLog(@"ERROR %@",response.URL.absoluteString);

                }
            }];
            
        }
    }
    
}

@end
