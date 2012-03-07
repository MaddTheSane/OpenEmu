/*
 Copyright (c) 2009, OpenEmu Team
 
 
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

#import "PCSXRGameCore.h"
#import "PCSXRGameController.h"
#import <OERingBuffer.h>
#include <sys/time.h>
#import <OpenGL/gl.h>
#import "OEPCSXRSystemResponderClient.h"
#import "EmuThread.h"
#include "psxcommon.h"
#include "plugins.h"
#include "misc.h"

#define SAMPLERATE 41100

@implementation PCSXRGameCore

@synthesize romPath;

- (id)init
{
    self = [super init];
    if(self)
    {
		
    }
    return self;
}

- (GLenum)pixelFormat
{
    return GL_BGRA;
}

- (GLenum)pixelType
{
    return GL_UNSIGNED_INT_8_8_8_8_REV;
}

- (GLenum)internalPixelFormat
{
    return GL_RGB8;
}

- (BOOL)loadFileAtPath:(NSString*) path
{
	SetIsoFile([path fileSystemRepresentation]);
	return YES;
}

- (void)setupEmulation
{
    DLog(@"Setup");
	[EmuThread run];
}

- (void)stopEmulation
{
	[EmuThread stop];
}

# pragma mark -

- (void)executeFrame
{

}

# pragma mark -

- (void)resetEmulation
{
	[EmuThread reset];
}

- (void)dealloc
{

}

- (void)didPushPCSXRButton:(OEPCSXRButton)button forPlayer:(NSUInteger)player;
{
    //controls->pad[player - 1].buttons |=  NESControlValues[button];
}

- (void)didReleasePCSXRButton:(OEPCSXRButton)button forPlayer:(NSUInteger)player;
{
    //controls->pad[player - 1].buttons &= ~NESControlValues[button];
}

- (double)audioSampleRate
{
    return SAMPLERATE;
}

- (NSUInteger)channelCount
{
    return 2;
}

- (BOOL)saveStateToFileAtPath:(NSString *)fileName
{
	[EmuThread freezeAt:fileName which:1];
	
    return YES;
}

- (BOOL)loadStateFromFileAtPath:(NSString *)fileName
{    
	return [EmuThread defrostAt:fileName];
}

- (OEIntSize)bufferSize
{
	OEIntSize size;
	//TODO: Handle PAL/SECAM sizes?
	size.width = 640;
	size.height = 480;
	return size;
}

@end
