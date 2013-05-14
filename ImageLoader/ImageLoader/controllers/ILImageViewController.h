//
//  ILImageViewController.h
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILImageViewController : UIViewController{
    NSString *url;
}
@property (nonatomic,assign) IBOutlet UIWebView *imageView;
- (id)initWithImageWithURL:(NSString *)aURL;
@end
