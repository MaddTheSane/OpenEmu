/*
 Copyright (c) 2013, OpenEmu Team
 
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

#import <Cocoa/Cocoa.h>

@protocol OESystemResponderClient;

typedef NS_ENUM(short, OE7800Button)
{
	OE7800ButtonUp,
	OE7800ButtonDown,
	OE7800ButtonLeft,
	OE7800ButtonRight,
	OE7800ButtonFire1,
    OE7800ButtonFire2,
    OE7800ButtonSelect,
	OE7800ButtonPause,
    OE7800ButtonReset,
    OE7800ButtonLeftDiff,
    OE7800ButtonRightDiff,
	OE7800ButtonCount
};

@protocol OE7800SystemResponderClient <OESystemResponderClient, NSObject>

- (oneway void)didPush7800Button:(OE7800Button)button forPlayer:(NSUInteger)player;
- (oneway void)didRelease7800Button:(OE7800Button)button forPlayer:(NSUInteger)player;
- (oneway void)mouseMovedAtPoint:(OEIntPoint)point;
- (oneway void)leftMouseDownAtPoint:(OEIntPoint)point;
- (oneway void)leftMouseUp;

@end
