function [ch] = startTrack(ch,fd,coff,cn0,time)

ch.status='LOCK';
ch.lockCount=0;
ch.dopFreq=fd;
ch.codeOffset=coff;
ch.adr=0;
ch.cn0=cn0;
ch.time=time;
ch.week = 0;
ch.tow = -1;

ch.trk = trkInit(ch.trk,ch.codeRate);