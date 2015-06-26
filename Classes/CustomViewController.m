//
//  CustomViewController.m
//  CastVideos
//
//  Created by PavelVPV on 25.06.15.
//  Copyright (c) 2015 Google inc. All rights reserved.
//

#import "CustomViewController.h"
#import "ChromecastDeviceController.h"
#import "LocalPlayerViewController.h"
#import "MediaListModel.h"
#import "Media.h"

@interface CustomViewController () <ChromecastDeviceControllerDelegate>

@end

@implementation CustomViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Assign ourselves as delegate ONLY in viewWillAppear of a view controller.
    [ChromecastDeviceController sharedInstance].delegate = self;
    [[ChromecastDeviceController sharedInstance] decorateViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ChromecastDeviceController sharedInstance] updateToolbarForViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"playMedia"]) {
        Media *media = [[Media alloc] init];
        media.URL = [NSURL URLWithString:@"https://cs6-11v4.vk-cdn.net/p3/f77385b8af94.480.mp4?extra=i6A66d78_xQR4wESZsAhHf6a_RgFJfy8KTsoZC_BR7m7_-c9lkIYmyDRiTh10hKHEjbxmxqXLPtAzOf9Pt95mr9wVZqhSTwN"];
        // Pass the currently selected media to the next controller if it needs it.
        [[segue destinationViewController] setMediaToPlay:media];
    }
}

@end
