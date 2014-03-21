//
//  SimplerMaskTestAppDelegate.m
//  SimplerMaskTest
//

#import "SimplerMaskTestAppDelegate.h"

@implementation SimplerMaskTestAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
