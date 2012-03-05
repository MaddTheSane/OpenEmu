/*
 Copyright (c) 2011, OpenEmu Team
 
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OEPSXSystemController.h"
#import "OEPSXSystemResponder.h"
#import "OEPCSXRSystemResponderClient.h"

@implementation OEPSXSystemController

- (Class)responderClass;
{
    return [OEPSXSystemResponder class];
}

- (NSArray *)genericSettingNames;
{
    return [super genericSettingNames];
}

- (NSArray *)genericControlNames;
{
    return [NSArray arrayWithObjects:OEPSXControlNameTable count:OEPSXButtonCount];
}

- (NSUInteger)numberOfPlayers;
{
    return 2;
}

- (NSDictionary *)defaultControls
{
    NSDictionary *controls = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardUpArrow]   , @"OEPSXButtonUp[1]"    ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardRightArrow], @"OEPSXButtonRight[1]" ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardLeftArrow] , @"OEPSXButtonLeft[1]"  ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardDownArrow] , @"OEPSXButtonDown[1]"  ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardZ]         , @"OEPSXButtonCross[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardX]         , @"OEPSXButtonCircle[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardS]         , @"OEPSXButtonSquare[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardD]         , @"OEPSXButtonTriange[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardW]         , @"OEPSXButtonL1[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardR]         , @"OEPSXButtonL2[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardE]         , @"OEPSXButtonR1[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardT]         , @"OEPSXButtonR2[1]"     ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardC]  , @"OEPSXButtonStart[1]" ,
                              [NSNumber numberWithUnsignedInt:kHIDUsage_KeyboardV]    , @"OEPSXButtonSelect[1]",
                              nil];
    return controls;
}

- (NSString *)systemName
{
	return @"PlayStation";
}

- (NSImage*)systemIcon
{
    NSString* imageName = @"psx_library";
    
    NSImage* image = [NSImage imageNamed:imageName];
    if(!image)
    {
        NSBundle* bundle = [NSBundle bundleForClass:[self class]];
        NSString* path = [bundle pathForImageResource:imageName];
        image = [[NSImage alloc] initWithContentsOfFile:path];
        [image setName:imageName];
    }
    return image;
}

@end
