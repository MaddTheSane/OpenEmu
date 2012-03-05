//
//  PCSXRHelpers.c
//  PCSXR
//
//  Created by Charles Betts on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCSXRGameController.h"
#include "psxcommon.h"

char* Pcsxr_locale_text(char* toloc){
	NSBundle *mainBundle = [NSBundle bundleForClass:[PCSXRGameController class]];
	NSString *origString = nil, *transString = nil;
	origString = [NSString stringWithCString:toloc encoding:NSUTF8StringEncoding];
	transString = [mainBundle localizedStringForKey:origString value:nil table:nil];
	return [transString cStringUsingEncoding:NSUTF8StringEncoding];
}

