//
//  ILImageViewController.m
//  ImageLoader
//
//  Created by Andrey Mukhametov on 15.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import "ILImageViewController.h"
#import "ILImageManager.h"
@interface ILImageViewController ()

@end

@implementation ILImageViewController

- (id)initWithImageWithURL:(NSString *)aURL{
    self = [super initWithNibName:@"ILImageViewController" bundle:nil];
    if (self) {
        url = aURL;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[ILImageManager shared] cacheImageURL:url withImageView:self.imageView];
    self.imageViewTest.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewTest.backgroundColor = [UIColor darkGrayColor];
    [[ILImageManager shared] cacheImageURL:url withImageView:self.imageViewTest andProgress:self.progressBar];
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[ILImageManager shared] stopLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
