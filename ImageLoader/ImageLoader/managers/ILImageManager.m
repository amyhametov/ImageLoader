//
//  ILImageManager.m
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import "ILImageManager.h"
#import "OLImageView.h"
#import "OLImage.h"


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
        queue = [RequestQueue mainQueue];
    }
    return self;
}

-(void) cacheImageURL:(NSString*)url withImageView:(id)view andProgress:(UIProgressView *) progressBar{
    
    if (url!=nil){
        NSMutableString *fileName= [NSMutableString stringWithString:url];
        [fileName replaceOccurrencesOfString:@"//" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [fileName length])];
        [fileName replaceOccurrencesOfString:@"/" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, [fileName length])];
        [fileName replaceOccurrencesOfString:@":" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [fileName length])];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        
        
        NSString *documentsDirectoryPath = [paths lastObject];
        
        
        NSString *filePathAndDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"images"];
        NSString *pathToFile = filePathAndDirectory;
        BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:pathToFile isDirectory:NO];
        
        NSError *error = nil;
        if(!isFile)
        {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&error])
            {
                NSLog(@"Create directory error: %@", error);
            }
            
        }

        
        NSString *storePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@",fileName]];
        NSString *tmpStorePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@.tmp",fileName]];

        NSLog(@"storePath %@",storePath);
        isFile = [[NSFileManager defaultManager] fileExistsAtPath:storePath isDirectory:NO];
        
        
        
        if(isFile)
        {
            progressBar.hidden = YES;
            UIImage *image = [UIImage imageWithContentsOfFile:storePath];
            if (image){
                NSLog(@"load from file");
                if ([view isMemberOfClass:[UIImageView class]]) {
                    ((UIImageView *)view).image = image;
                }
                if ([view isMemberOfClass:[UIWebView class]]) {
                    NSData *data = [NSData dataWithContentsOfFile:storePath];
                    [(UIWebView *)view loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];                    
                }
                if ([view isMemberOfClass:[OLImageView class]]) {
                    NSData *data = [NSData dataWithContentsOfFile:storePath];
                    UIImage *image = [OLImage imageWithData:data];
                    ((OLImageView *)view).image = image;
                }
            }
        }
        else
        {
            
            NSLog(@"START %@",url);
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            RQOperation *cacheOperation = [RQOperation operationWithRequest:request andTmpFileName:tmpStorePath];
            cacheOperation.completionHandler = ^(NSURLResponse *response, NSData *data, NSError *error){
                if (data && error==nil)
                {
                    NSLog(@"Image loaded %@",response.URL.absoluteString);
                    [data writeToFile:storePath atomically:YES];
                    NSError *error = nil;
                    if (![[NSFileManager defaultManager] removeItemAtPath:tmpStorePath error:&error])
                    {
                        NSLog(@"TMP Remove error: %@", error);
                        
                    }
                    if ([view isMemberOfClass:[UIImageView class]]) {
                        ((UIImageView *)view).image = [UIImage imageWithData:data];
                    }
                    if ([view isMemberOfClass:[UIWebView class]]) {
                        [(UIWebView *)view loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
                        
                    }
                    if ([view isMemberOfClass:[OLImageView class]]) {
                        UIImage *image = [OLImage imageWithData:data];
                        ((OLImageView *)view).image = image;
                    }
                }
                else{
                    NSLog(@"ERROR %@",response.URL.absoluteString);

                }
            };
            progressBar.progress = 0;
            progressBar.hidden = NO;
            cacheOperation.downloadProgressHandler =
                ^(float progress, NSInteger bytesTransferred, NSInteger totalBytes,NSData *appendedData){
                    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:tmpStorePath isDirectory:NO];

                    if (!isFile) {
                        [[NSFileManager defaultManager] createFileAtPath:tmpStorePath contents:nil attributes:nil];
                    }
                    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:tmpStorePath];
                    [handle seekToEndOfFile];
                    [handle writeData:appendedData];
                    [handle closeFile];

                    if (progress<1)
                    {
                        progressBar.progress = progress;
                    }
                    else {
                        progressBar.hidden = YES;
                    }
                };

            [[RequestQueue mainQueue] addOperation:cacheOperation];
            
            
        }
    }
    
}
-(void) clearCache{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    
    
    NSString *documentsDirectoryPath = [paths lastObject];
    
    
    NSString *filePathAndDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"images"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:filePathAndDirectory error:&error])
    {
        NSLog(@"Create directory error: %@", error);

    }
}
-(void) stopLoad{
    [queue cancelAllRequests];
}
@end
