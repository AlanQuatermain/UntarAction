//
//  UntarAction.m
//  Untar
//
//  Created by Jim Dovey on 09-10-02.
//  Copyright (c) 2009 Jim Dovey. All Rights Reserved.
//

#import "UntarAction.h"
#import <dispatch/dispatch.h>

@implementation UntarAction

@synthesize stopOnError;

- (id) runWithInput: (id) input fromAction: (AMAction *) anAction error: (NSDictionary **) errorInfo
{
	NSMutableArray * output = [[NSMutableArray alloc] initWithCapacity: [input count]];
	dispatch_group_t group = dispatch_group_create();
	
	[input enumerateObjectsWithOptions: NSEnumerationConcurrent usingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		dispatch_group_enter( group );
		
		NSString * path = obj;
		if ( [obj isKindOfClass: [NSURL class]] )
			path = [obj path];
		
		path = [path stringByStandardizingPath];
		
		NSString * arg = @"xvf";
		if ( [path hasSuffix: @".gz"] )
			arg = @"zxvf";
		
		NSTask * task = [[NSTask alloc] init];
		[task setLaunchPath: @"/usr/bin/tar"];
		[task setArguments: [NSArray arrayWithObjects: arg, path, nil]];
		[task setCurrentDirectoryPath: [path stringByDeletingLastPathComponent]];
		[task launch];
		
		[task waitUntilExit];
		if ( ([task terminationStatus] != 0) && (self.stopOnError) )
		{
			*stop = YES;
		}
		else
		{
			[output addObject: obj];
		}
		
		[task release];
		
		dispatch_group_leave( group );
		[pool drain];
	}];
	
	dispatch_group_wait( group, DISPATCH_TIME_FOREVER );
	dispatch_release( group );
	
	return ( output );
}

@end
