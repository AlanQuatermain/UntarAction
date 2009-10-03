//
//  UntarAction.h
//  Untar
//
//  Created by Jim Dovey on 09-10-02.
//  Copyright (c) 2009 Jim Dovey. All Rights Reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface UntarAction : AMBundleAction 

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
