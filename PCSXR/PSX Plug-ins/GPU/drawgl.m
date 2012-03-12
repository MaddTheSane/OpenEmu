/***************************************************************************
    drawgl.m
    PeopsSoftGPU
  
    Created by Gil Pedersen on Sun April 18 2004.
    Copyright (c) 2004 Gil Pedersen.
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version. See also the license.txt file for *
 *   additional informations.                                              *
 *                                                                         *
 ***************************************************************************/

#include "ExtendedKeys.h"
#include "externals.h"
#include "draw.h"
#include "gpu.h"
#include "menu.h"
#include "drawgl.h"

////////////////////////////////////////////////////////////////////////////////////
// misc globals
////////////////////////////////////////////////////////////////////////////////////

int            iResX;
int            iResY;
long           lLowerpart;
BOOL           bIsFirstFrame = TRUE;
BOOL           bCheckMask=FALSE;
unsigned short sSetMask=0;
unsigned long  lSetMask=0;
int            iDesktopCol=16;
int            iShowFPS=0;
int            iWinSize; 
int            iUseScanLines=0;
int            iUseNoStretchBlt=0;
int            iFastFwd=0;
int            iDebugMode=0;
int            iFVDisplay=0;
PSXPoint_t     ptCursorPoint[8];
unsigned short usCursorActive=0;
char *			Xpixels;
char *         pCaptionText;

//static PluginWindowController *windowController;
//static PluginGLView *glView;
static unsigned char* image = NULL;
#define image_width  640
#define image_height 480
#define image_depth 32

unsigned char* PSXVideoBuffer()
{
	return image;
}

////////////////////////////////////////////////////////////////////////

void DoBufferSwap(void)                                // SWAP BUFFERS
{
#if 1
	//[glView swapBuffer];
#else
	static long long lastTickCount = -1;
	static int skipCount = 0;
	long long microTickCount;
	long deltaTime;
	
	Microseconds((struct UnsignedWide *)&microTickCount);
	deltaTime = (long)(microTickCount - lastTickCount);
	if (deltaTime <= (PSXDisplay.PAL ? 1000000/50 : 100000000 / 5994) ||
		 skipCount >= 3) {
		skipCount = 0;
		[glView swapBuffer];
	} else {
		skipCount++;
	}
	NSLog(@"count: %i", deltaTime);
	lastTickCount = microTickCount;
#endif
}


////////////////////////////////////////////////////////////////////////

void DoClearScreenBuffer(void)                         // CLEAR DX BUFFER
{
	// clear the screen, and DON'T flush it
	//[glView clearBuffer:NO];
}


////////////////////////////////////////////////////////////////////////

void DoClearFrontBuffer(void)                          // CLEAR DX BUFFER
{
	// clear the screen, and flush it
	//[glView clearBuffer:YES];
}

////////////////////////////////////////////////////////////////////////

unsigned long ulInitDisplay(void)	// OPEN GAME WINDOW
{
	bUsingTWin=FALSE;                          

	InitMenu();                

	bIsFirstFrame = FALSE;

	if(iShowFPS)
	{
		//iShowFPS=0;
		ulKeybits|=KEY_SHOWFPS;
		szDispBuf[0]=0;
		BuildDispMenu(0);
	}
	image = calloc(((image_width * image_height) / 3) * 4, image_depth >> 3);

	
	//PluginWindowController *windowController = [PluginWindowController openGameView];
	//glView = [windowController openGLView];
	
   // NSString *title = [NSString stringWithCString:pCaptionText encoding:NSUTF8StringEncoding];
	//[[windowController window] setTitle:title];
	
	//return (unsigned long)[windowController window];
	return (unsigned long)image;
}


////////////////////////////////////////////////////////////////////////

void CloseDisplay(void)
{
#if 0
	if (gameController) {
		[gameController close];
		[gameController release];
		gameController = nil;
		gameWindow = nil;
	}
#endif
	free(image);
}


////////////////////////////////////////////////////////////////////////

void CreatePic(unsigned char * pMem)
{
}


///////////////////////////////////////////////////////////////////////////////////////

void DestroyPic(void)
{
}


///////////////////////////////////////////////////////////////////////////////////////

void DisplayPic(void)
{
}


///////////////////////////////////////////////////////////////////////////////////////

void ShowGpuPic(void)
{
	// this is the default implementation...
}

///////////////////////////////////////////////////////////////////////////////////////

void ShowTextGpuPic(void)
{
	// this is the default implementation...
}


void HandleKey(int keycode)
{
	switch (keycode) {
		case GPU_FULLSCREEN_KEY:
			//[gameController setFullscreen:![gameController fullscreen]];
			break;
		default:
			break;
	}
}
