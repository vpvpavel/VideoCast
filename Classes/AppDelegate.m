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


#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#import "HTTPDataResponse.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AppDelegate

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
    
    // Create server using our custom MyHTTPServer class
    httpServer = [[HTTPServer alloc] init];
    
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    // [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    DDLogInfo(@"Setting document root: %@", webPath);
    
    [httpServer setDocumentRoot:webPath];
    
    
    [self startServer];
    
    
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

@end