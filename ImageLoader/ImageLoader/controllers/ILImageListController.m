//
//  ILImageListController.m
//  ImageLoader
//
//  Created by Andrey Mukhametov on 14.05.13.
//  Copyright (c) 2013 Andrey Mukhametov. All rights reserved.
//

#import "ILImageListController.h"
#import "ILImageListCell.h"
#import "ILServerManager.h"
#import "ILROImage.h"
#import "ILImageManager.h"
#import "ILImageViewController.h"
@interface ILImageListController ()

@end

@implementation ILImageListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Веселые картинки";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonTap:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTap:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor darkGrayColor];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(imageListLoaded:)
                                                 name:nImagesLoaded
											   object:[ILServerManager shared]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ILImageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ILImageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
    ILROImage *obj = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.name;    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ILROImage *obj = [data objectAtIndex:indexPath.row];
    ILImageViewController *imageViewController = [[ILImageViewController alloc] initWithImageWithURL:obj.url];
    [self.navigationController pushViewController:imageViewController animated:YES];
}

- (void) refreshButtonTap:(id)selector {
    NSLog(@"refresh start");
    [self updateList];
    
}
- (void) trashButtonTap:(id)selector {
    [[ILImageManager shared] clearCache];
}
- (void) updateList{
    [[ILServerManager shared] loadImageList];
}

-(void) imageListLoaded:(NSNotification*)notification{

    data = [notification.userInfo objectForKey:@"list"];
    [self.tableView reloadData];
    
}


@end
