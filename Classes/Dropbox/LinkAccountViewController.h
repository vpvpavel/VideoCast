//
//  LinkAccountViewController.h
//  CastVideos
//
//  Created by PavelVPV on 11.08.15.
//  Copyright (c) 2015 Google inc. All rights reserved.
//
#import "PhotoViewController.h"

@class DBRestClient;


@interface LinkAccountViewController : UIViewController {
    UIButton* linkButton;
    PhotoViewController* photoViewController;
	DBRestClient* restClient;
}

- (IBAction)didPressLink;

@property (nonatomic, retain) IBOutlet UIButton* linkButton;
@property (nonatomic, retain) UIViewController* photoViewController;

@end
