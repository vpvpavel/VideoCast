// Copyright 2013 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AppDelegate.h"
#import "ChromecastDeviceController.h"

#import <AVFoundation/AVFoundation.h>


//#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "RoutingHTTPServer.h"

#import "Model.h"


// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AppDelegate

@synthesize httpServer;
- (void)startServer
{
    // Start the server (and check for problems)
    
    NSError *error;
    if([httpServer start:&error])
    {
        DDLogInfo(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
        self.port = [httpServer listeningPort];
        
    }
    else
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
    }
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Configure our logging framework.
    // To keep things simple and fast, we're just going to log to the Xcode console.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    httpServer = [[RoutingHTTPServer alloc] init];
    [httpServer setPort:55820];
    [httpServer setDefaultHeader:@"Server" value:@"YourAwesomeApp/1.0"];
    
    [self startServer];
     Model *model = [Model sharedModel];
    [httpServer handleMethod:@"GET" withPath:@"/video/*.*" block:^(RouteRequest *request, RouteResponse *response) {
        [response setHeader:@"Content-Type" value:@"video/mp4"];
        [response setHeader:@"Cache-Control" value:@"public, max-age=3600"];
        [response setHeader:@"Access-Control-Expose-Headers" value:@"Content-Type, Range, Accept-Encoding"];
        [response setHeader:@"Access-Control-Allow-Origin" value:@"*"];
        [response setHeader:@"alternate-protocol" value:@"443:quic,p=1"];
        [response respondWithData:model.dataFile];
    }];
    
    [httpServer handleMethod:@"GET" withPath:@"/thumbnail/*.*" block:^(RouteRequest *request, RouteResponse *response) {
        [response setHeader:@"Content-Type" value:@"image/png"];
        [response respondWithData:model.thumbnailImage];
        
    }];
    

    
    
//  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

  // Turn on the Cast logging for debug purposes.
  [[ChromecastDeviceController sharedInstance] enableLogging];
  // Set the receiver application ID to initialise scanning.
  [ChromecastDeviceController sharedInstance].applicationID = @"4F8B3483";
  // Replace the value above with your app id.

  // Set playback category mode to allow playing audio on the video files even when the ringer
  // mute switch is on.
  NSError *setCategoryError;
  BOOL success = [[AVAudioSession sharedInstance]
                  setCategory:AVAudioSessionCategoryPlayback
                        error: &setCategoryError];
  if (!success) {
    NSLog(@"Error setting audio category: %@", setCategoryError.localizedDescription);
  }

  return YES;
}



//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    [self startServer];
//}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // There is no public(allowed in AppStore) method for iOS to run continiously in the background for our purposes (serving HTTP).
//    // So, we stop the server when the app is paused (if a users exits from the app or locks a device) and
//    // restart the server when the app is resumed (based on this document: http://developer.apple.com/library/ios/#technotes/tn2277/_index.html )
//    
//    [httpServer stop];
//}


@end