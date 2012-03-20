/***************************************************************************
 *   Copyright (C) 2007 Ryan Schultz, PCSX-df Team, PCSX team              *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.           *
 ***************************************************************************/

#ifndef __PLUGINS_H__
#define __PLUGINS_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "psxcommon.h"

//#define ENABLE_SIO1API 1


typedef void* HWND;
#define CALLBACK

extern long GPUopen(unsigned long *, char *, char *);
extern long SPUopen(void);
typedef long (*PADopen)(unsigned long *);
typedef long (*NETopen)(unsigned long *);
typedef long (*SIO1open)(unsigned long *);

#include "spu.h"

#include "psemu_plugin_defs.h"
#include "decode_xa.h"

int LoadPlugins();
void ReleasePlugins();
int OpenPlugins();
void ClosePlugins();

//typedef unsigned long (CALLBACK* PSEgetLibType)(void);
//typedef unsigned long (CALLBACK* PSEgetLibVersion)(void);
//typedef char *(CALLBACK* PSEgetLibName)(void);

// GPU Functions
extern long GPUinit(void);
extern long GPUshutdown(void);
extern long GPUclose(void);
extern void GPUwriteStatus(uint32_t);
extern void GPUwriteData(uint32_t);
extern void GPUwriteDataMem(uint32_t *, int);
extern uint32_t GPUreadStatus(void);
extern uint32_t GPUreadData(void);
extern void GPUreadDataMem(uint32_t *, int);
extern long GPUdmaChain(uint32_t *,uint32_t);
extern void GPUupdateLace(void);
extern long GPUconfigure(void);
extern long GPUtest(void);
extern void GPUabout(void);
extern void GPUmakeSnapshot(void);
extern void GPUkeypressed(int);
extern void GPUdisplayText(char *);
typedef struct {
	uint32_t ulFreezeVersion;
	uint32_t ulStatus;
	uint32_t ulControl[256];
	unsigned char psxVRam[1024*512*2];
} GPUFreeze_t;
extern long GPUfreeze(uint32_t, GPUFreeze_t *);
extern long GPUgetScreenPic(unsigned char *);
extern long GPUshowScreenPic(unsigned char *);
extern void GPUclearDynarec(void (CALLBACK *callback)(void));
extern void GPUhSync(int);
extern void GPUvBlank(int);
extern void GPUvisualVibration(uint32_t, uint32_t);
extern void GPUcursor(int, int, int);
extern void GPUaddVertex(short,short,s64,s64,s64);

typedef long (CALLBACK* GPUshowScreenPicFunc)(unsigned char *);
typedef void (CALLBACK* GPUdisplayTextFunc)( char *);

// CD-ROM Functions
typedef long (CALLBACK* CDRinitFunc)(void);
typedef long (CALLBACK* CDRshutdownFunc)(void);
typedef long (CALLBACK* CDRopenFunc)(void);
typedef long (CALLBACK* CDRcloseFunc)(void);
typedef long (CALLBACK* CDRgetTNFunc)(unsigned char *);
typedef long (CALLBACK* CDRgetTDFunc)(unsigned char, unsigned char *);
typedef long (CALLBACK* CDRreadTrackFunc)(unsigned char *);
typedef unsigned char* (CALLBACK* CDRgetBufferFunc)(void);
typedef unsigned char* (CALLBACK* CDRgetBufferSubFunc)(void);
typedef long (CALLBACK* CDRconfigureFunc)(void);
typedef long (CALLBACK* CDRtestFunc)(void);
typedef void (CALLBACK* CDRaboutFunc)(void);
typedef long (CALLBACK* CDRplayFunc)(unsigned char *);
typedef long (CALLBACK* CDRstopFunc)(void);
typedef long (CALLBACK* CDRsetfilenameFunc)(char *);
struct CdrStat {
	uint32_t Type;
	uint32_t Status;
	unsigned char Time[3];
};
typedef long (CALLBACK* CDRgetStatusFunc)(struct CdrStat *);
typedef char* (CALLBACK* CDRgetDriveLetterFunc)(void);
struct SubQ {
	char res0[12];
	unsigned char ControlAndADR;
	unsigned char TrackNumber;
	unsigned char IndexNumber;
	unsigned char TrackRelativeAddress[3];
	unsigned char Filler;
	unsigned char AbsoluteAddress[3];
	unsigned char CRC[2];
	char res1[72];
};
typedef long (CALLBACK* CDRreadCDDAFunc)(unsigned char, unsigned char, unsigned char, unsigned char *);
typedef long (CALLBACK* CDRgetTEFunc)(unsigned char, unsigned char *, unsigned char *, unsigned char *);

// CD-ROM function pointers
extern CDRinitFunc               CDR_init;
extern CDRshutdownFunc           CDR_shutdown;
extern CDRopenFunc               CDR_open;
extern CDRcloseFunc              CDR_close;
extern CDRtestFunc               CDR_test;
extern CDRgetTNFunc              CDR_getTN;
extern CDRgetTDFunc              CDR_getTD;
extern CDRreadTrackFunc          CDR_readTrack;
extern CDRgetBufferFunc          CDR_getBuffer;
extern CDRgetBufferSubFunc       CDR_getBufferSub;
extern CDRplayFunc               CDR_play;
extern CDRstopFunc               CDR_stop;
extern CDRgetStatusFunc          CDR_getStatus;
extern CDRgetDriveLetterFunc     CDR_getDriveLetter;
extern CDRconfigureFunc          CDR_configure;
extern CDRaboutFunc              CDR_about;
extern CDRsetfilenameFunc        CDR_setfilename;
extern CDRreadCDDAFunc           CDR_readCDDA;
extern CDRgetTEFunc              CDR_getTE;

// SPU Functions
extern long SPUinit(void);
extern long SPUshutdown(void);
extern long SPUclose(void);
extern void SPUplaySample(unsigned char);
extern void SPUwriteRegister(unsigned long, unsigned short);
extern unsigned short SPUreadRegister(unsigned long);
extern void SPUwriteDMA(unsigned short);
extern unsigned short SPUreadDMA(void);
extern void SPUwriteDMAMem(unsigned short *, int);
extern void SPUreadDMAMem(unsigned short *, int);
extern void SPUplayADPCMchannel(xa_decode_t *);
extern void SPUregisterCallback(void (CALLBACK *callback)(void));
extern long SPUconfigure(void);
extern long SPUtest(void);
extern void SPUabout(void);
typedef struct {
	unsigned char PluginName[8];
	uint32_t PluginVersion;
	uint32_t Size;
	unsigned char SPUPorts[0x200];
	unsigned char SPURam[0x80000];
	xa_decode_t xa;
	unsigned char *SPUInfo;
} SPUFreeze_t;
extern long SPUfreeze(uint32_t, SPUFreeze_t *);
extern void SPUasync(uint32_t);
extern void SPUplayCDDAchannel(short *, int);

// PAD Functions
typedef long (CALLBACK* PADconfigure)(void);
typedef void (CALLBACK* PADabout)(void);
typedef long (CALLBACK* PADinit)(long);
typedef long (CALLBACK* PADshutdown)(void);
typedef long (CALLBACK* PADtest)(void);
typedef long (CALLBACK* PADclose)(void);
typedef long (CALLBACK* PADquery)(void);
typedef long (CALLBACK* PADreadPort1)(PadDataS*);
typedef long (CALLBACK* PADreadPort2)(PadDataS*);
typedef long (CALLBACK* PADkeypressed)(void);
typedef unsigned char (CALLBACK* PADstartPoll)(int);
typedef unsigned char (CALLBACK* PADpoll)(unsigned char);
typedef void (CALLBACK* PADsetSensitive)(int);
typedef void (CALLBACK* PADregisterVibration)(void (CALLBACK *callback)(uint32_t, uint32_t));
typedef void (CALLBACK* PADregisterCursor)(void (CALLBACK *callback)(int, int, int));

// PAD function pointers
extern PADconfigure        PAD1_configure;
extern PADabout            PAD1_about;
extern PADinit             PAD1_init;
extern PADshutdown         PAD1_shutdown;
extern PADtest             PAD1_test;
extern PADopen             PAD1_open;
extern PADclose            PAD1_close;
extern PADquery            PAD1_query;
extern PADreadPort1        PAD1_readPort1;
extern PADkeypressed       PAD1_keypressed;
extern PADstartPoll        PAD1_startPoll;
extern PADpoll             PAD1_poll;
extern PADsetSensitive     PAD1_setSensitive;
extern PADregisterVibration PAD1_registerVibration;
extern PADregisterCursor   PAD1_registerCursor;
extern PADconfigure        PAD2_configure;
extern PADabout            PAD2_about;
extern PADinit             PAD2_init;
extern PADshutdown         PAD2_shutdown;
extern PADtest             PAD2_test;
extern PADopen             PAD2_open;
extern PADclose            PAD2_close;
extern PADquery            PAD2_query;
extern PADreadPort2        PAD2_readPort2;
extern PADkeypressed       PAD2_keypressed;
extern PADstartPoll        PAD2_startPoll;
extern PADpoll             PAD2_poll;
extern PADsetSensitive     PAD2_setSensitive;
extern PADregisterVibration PAD2_registerVibration;
extern PADregisterCursor   PAD2_registerCursor;

// NET Functions
typedef long (CALLBACK* NETinit)(void);
typedef long (CALLBACK* NETshutdown)(void);
typedef long (CALLBACK* NETclose)(void);
typedef long (CALLBACK* NETconfigure)(void);
typedef long (CALLBACK* NETtest)(void);
typedef void (CALLBACK* NETabout)(void);
typedef void (CALLBACK* NETpause)(void);
typedef void (CALLBACK* NETresume)(void);
typedef long (CALLBACK* NETqueryPlayer)(void);
typedef long (CALLBACK* NETsendData)(void *, int, int);
typedef long (CALLBACK* NETrecvData)(void *, int, int);
typedef long (CALLBACK* NETsendPadData)(void *, int);
typedef long (CALLBACK* NETrecvPadData)(void *, int);

typedef struct {
	char EmuName[32];
	char CdromID[9];	// ie. 'SCPH12345', no \0 trailing character
	char CdromLabel[11];
	void *psxMem;
	GPUshowScreenPicFunc GPU_showScreenPic;
	GPUdisplayTextFunc GPU_displayText;
	PADsetSensitive PAD_setSensitive;
	char GPUpath[256];	// paths must be absolute
	char SPUpath[256];
	char CDRpath[256];
	char MCD1path[256];
	char MCD2path[256];
	char BIOSpath[256];	// 'HLE' for internal bios
	char Unused[1024];
} netInfo;

typedef long (CALLBACK* NETsetInfo)(netInfo *);
typedef long (CALLBACK* NETkeypressed)(int);

// NET function pointers
extern NETinit               NET_init;
extern NETshutdown           NET_shutdown;
extern NETopen               NET_open;
extern NETclose              NET_close;
extern NETtest               NET_test;
extern NETconfigure          NET_configure;
extern NETabout              NET_about;
extern NETpause              NET_pause;
extern NETresume             NET_resume;
extern NETqueryPlayer        NET_queryPlayer;
extern NETsendData           NET_sendData;
extern NETrecvData           NET_recvData;
extern NETsendPadData        NET_sendPadData;
extern NETrecvPadData        NET_recvPadData;
extern NETsetInfo            NET_setInfo;
extern NETkeypressed         NET_keypressed;

#ifdef ENABLE_SIO1API

// SIO1 Functions (link cable)
typedef long (CALLBACK* SIO1init)(void);
typedef long (CALLBACK* SIO1shutdown)(void);
typedef long (CALLBACK* SIO1close)(void);
typedef long (CALLBACK* SIO1configure)(void);
typedef long (CALLBACK* SIO1test)(void);
typedef void (CALLBACK* SIO1about)(void);
typedef void (CALLBACK* SIO1pause)(void);
typedef void (CALLBACK* SIO1resume)(void);
typedef long (CALLBACK* SIO1keypressed)(int);
typedef void (CALLBACK* SIO1writeData8)(unsigned char);
typedef void (CALLBACK* SIO1writeData16)(unsigned short);
typedef void (CALLBACK* SIO1writeData32)(unsigned long);
typedef void (CALLBACK* SIO1writeStat16)(unsigned short);
typedef void (CALLBACK* SIO1writeStat32)(unsigned long);
typedef void (CALLBACK* SIO1writeMode16)(unsigned short);
typedef void (CALLBACK* SIO1writeMode32)(unsigned long);
typedef void (CALLBACK* SIO1writeCtrl16)(unsigned short);
typedef void (CALLBACK* SIO1writeCtrl32)(unsigned long);
typedef void (CALLBACK* SIO1writeBaud16)(unsigned short);
typedef void (CALLBACK* SIO1writeBaud32)(unsigned long);
typedef unsigned char (CALLBACK* SIO1readData8)(void);
typedef unsigned short (CALLBACK* SIO1readData16)(void);
typedef unsigned long (CALLBACK* SIO1readData32)(void);
typedef unsigned short (CALLBACK* SIO1readStat16)(void);
typedef unsigned long (CALLBACK* SIO1readStat32)(void);
typedef unsigned short (CALLBACK* SIO1readMode16)(void);
typedef unsigned long (CALLBACK* SIO1readMode32)(void);
typedef unsigned short (CALLBACK* SIO1readCtrl16)(void);
typedef unsigned long (CALLBACK* SIO1readCtrl32)(void);
typedef unsigned short (CALLBACK* SIO1readBaud16)(void);
typedef unsigned long (CALLBACK* SIO1readBaud32)(void);
typedef void (CALLBACK* SIO1registerCallback)(void (CALLBACK *callback)(void));

// SIO1 function pointers
extern SIO1init               SIO1_init;
extern SIO1shutdown           SIO1_shutdown;
extern SIO1open               SIO1_open;
extern SIO1close              SIO1_close;
extern SIO1test               SIO1_test;
extern SIO1configure          SIO1_configure;
extern SIO1about              SIO1_about;
extern SIO1pause              SIO1_pause;
extern SIO1resume             SIO1_resume;
extern SIO1keypressed         SIO1_keypressed;
extern SIO1writeData8         SIO1_writeData8;
extern SIO1writeData16        SIO1_writeData16;
extern SIO1writeData32        SIO1_writeData32;
extern SIO1writeStat16        SIO1_writeStat16;
extern SIO1writeStat32        SIO1_writeStat32;
extern SIO1writeMode16        SIO1_writeMode16;
extern SIO1writeMode32        SIO1_writeMode32;
extern SIO1writeCtrl16        SIO1_writeCtrl16;
extern SIO1writeCtrl32        SIO1_writeCtrl32;
extern SIO1writeBaud16        SIO1_writeBaud16;
extern SIO1writeBaud32        SIO1_writeBaud32;
extern SIO1readData8          SIO1_readData8;
extern SIO1readData16         SIO1_readData16;
extern SIO1readData32         SIO1_readData32;
extern SIO1readStat16         SIO1_readStat16;
extern SIO1readStat32         SIO1_readStat32;
extern SIO1readMode16         SIO1_readMode16;
extern SIO1readMode32         SIO1_readMode32;
extern SIO1readCtrl16         SIO1_readCtrl16;
extern SIO1readCtrl32         SIO1_readCtrl32;
extern SIO1readBaud16         SIO1_readBaud16;
extern SIO1readBaud32         SIO1_readBaud32;
extern SIO1registerCallback   SIO1_registerCallback;

#endif

void CALLBACK clearDynarec(void);

void SetIsoFile(const char *filename);
const char *GetIsoFile(void);
boolean UsingIso(void);
void SetCdOpenCaseTime(s64 time);

#ifdef __cplusplus
}
#endif
#endif
