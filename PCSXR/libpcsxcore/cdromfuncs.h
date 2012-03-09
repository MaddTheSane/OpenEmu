//
//  cdromfuncs.h
//  PCSXR
//
//  Created by Charles Betts on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PCSXR_cdromfuncs_h
#define PCSXR_cdromfuncs_h
#include "plugins.h"

extern long CDRinit(void);
extern long CDRshutdown(void);
extern long CDRopen(void);
extern long CDRclose(void);
extern long CDRgetTN(unsigned char *);
extern long CDRgetTD(unsigned char, unsigned char *);
extern long CDRreadTrack(unsigned char *);
extern unsigned char* CDRgetBuffer(void);
extern unsigned char* CDRgetBufferSub(void);
extern long CDRconfigure(void);
extern long CDRtest(void);
extern void CDRabout(void);
extern long CDRplay(unsigned char *);
extern long CDRstop(void);
extern long CDRsetfilename(char *);
extern long CDRgetStatus(struct CdrStat *);
extern char* CDRgetDriveLetter(void);
extern long CDRreadCDDA(unsigned char, unsigned char, unsigned char, unsigned char *);
extern long CDRgetTE(unsigned char, unsigned char *, unsigned char *, unsigned char *);


#endif
