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
#include "externals_gpu.h"
#include "draw.h"
#include "gpu.h"
#include "menu.h"
#include "drawgl.h"
#include <OpenGL/gl.h>

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
int            iMaintainAspect = 0;
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

static int mylog2(int val)
{
	int i;
	for (i=1; i<31; i++)
		if (val <= (1 << i))
			return (1 << i);
	
	return -1;
}

unsigned char* PSXVideoBuffer()
{
	return image;
}

void GPUTick()
{
	int image_width2 = mylog2(image_width);
	//int image_height2 = mylog2(image_height);

	
	unsigned char * surf;
	long x = PSXDisplay.DisplayPosition.x;
	long y = PSXDisplay.DisplayPosition.y;
	GLuint lu;
	unsigned short row,column;
	unsigned short dx=(unsigned short)PSXDisplay.DisplayEnd.x;//PreviousPSXDisplay.Range.x1;
	unsigned short dy=(unsigned short)PSXDisplay.DisplayEnd.y;//PreviousPSXDisplay.DisplayMode.y;
	long lPitch;
	
	//printf("y=%i",PSXDisplay.DisplayPosition.y);
	
	if (/*[glLock tryLock]*/ 1) {
		
		if ((image_width != PreviousPSXDisplay.Range.x1) || 
			(image_height != PreviousPSXDisplay.DisplayMode.y) ||
			((PSXDisplay.RGB24 ? 32 : 16) != image_depth)) {
		}
		
		surf = image;
		lPitch=image_width2<<(image_depth >> 4);
		
		if(PreviousPSXDisplay.Range.y0)                       // centering needed?
		{
			surf+=PreviousPSXDisplay.Range.y0*lPitch;
			dy-=PreviousPSXDisplay.Range.y0;
		}
		
		if(/*PSXDisplay.RGB24*/ 1) //We'll always be in 32-bit mode
		{
			unsigned char * pD;unsigned int startxy;
			
			surf+=PreviousPSXDisplay.Range.x0<<2;
			
			for(column=0;column<dy;column++)
			{ 
				startxy = (1024 * (column + y)) + x;
				pD = (unsigned char *)&psxVuw[startxy];
				
				row = 0;
				// make sure the reads are aligned
				while ((intptr_t)pD & 0x3) {
					*((unsigned long *)((surf)+(column*lPitch)+(row<<2))) =
					(*(pD+0)<<16)|(*(pD+1)<<8)|*(pD+2);
					
					pD+=3;
					row++;
				}
				
				for(;row<dx;row+=4)
				{
					GLuint lu1 = *((GLuint *)pD);
					GLuint lu2 = *((GLuint *)pD+1);
					GLuint lu3 = *((GLuint *)pD+2);
					GLuint *dst = ((GLuint *)((surf)+(column*lPitch)+(row<<2)));
					*(dst)=
					(((lu1>>0)&0xff)<<16)|(((lu1>>8)&0xff)<<8)|(((lu1>>16)&0xff));
					*(dst+1)=
					(((lu1>>24)&0xff)<<16)|(((lu2>>0)&0xff)<<8)|(((lu2>>8)&0xff));
					*(dst+2)=
					(((lu2>>16)&0xff)<<16)|(((lu2>>24)&0xff)<<8)|(((lu3>>0)&0xff));
					*(dst+3)=
					(((lu3>>8)&0xff)<<16)|(((lu3>>16)&0xff)<<8)|(((lu3>>24)&0xff));
					pD+=12;
				}
				
				//for(;row<dx;row+=4)
				/*while (pD&0x3) {
				 *((unsigned long *)((surf)+(column*lPitch)+(row<<2)))=
				 (*(pD+0)<<16)|(*(pD+1)<<8)|(*(pD+2)&0xff));
				 pD+=3;
				 row++;
				 }*/
			}
		}
	}
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
