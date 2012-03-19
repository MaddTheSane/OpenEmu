//
//  drawgl.h
//  PCSXR
//
//  Created by Charles Betts on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PCSXR_drawgl_h
#define PCSXR_drawgl_h

extern unsigned char* PSXVideoBuffer();
extern void GPUTick();
// setGPUDefaults is used to avoid conflicts with externals_gpu.h and externals_spu.h
extern void setGPUDefaults();

#endif
