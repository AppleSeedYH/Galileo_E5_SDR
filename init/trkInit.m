function [trk] = trkInit(trk,codeRate)

trk.secSync = 0;
trk.secPol = 0;
trk.errPhas = 0.0;
trk.sumP = 0.0;
trk.sumE = 0.0;
trk.sumL = 0.0;
trk.sumN = 0.0;
trk.C(:)=0;
trk.P(:)=0;

trk.codeFreq=codeRate;
trk.nco=0;
trk.errCodeOld=0;
trk.ncoOld=0;