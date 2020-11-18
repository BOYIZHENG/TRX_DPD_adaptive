% TRX model for DPD
clear all
fs = 10e9;
uprate = 8;
fin =10e6;
fin_LO = 1e9;
fs_slow = fs/uprate;
sampLen = 2^11;

time_slow  = 0:1/(fs/8):(sampLen-1)/(fs/8);
time  = 0:1/fs:(uprate*sampLen-1)/fs;

ampl      = 0.5; % p-p, max=0.5 for single tone

fin_new     = coherent_in(fin,0,fs,uprate*sampLen); 
sysin_i   = ampl/2*sin((2*pi*fin_new).*time_slow); 
sysin_q   = ampl/2*cos((2*pi*fin_new).*time_slow);

% up-sample
sysin_i_up     = interpNRZ(sysin_i,uprate);
sysin_q_up     = interpNRZ(sysin_q,uprate);

% up-mixing
LO_i = sin((2*pi*fin_LO).*time);
LO_q = cos((2*pi*fin_LO).*time);
RF_out = sysin_i_up .* LO_i + sysin_q_up .* LO_q;

% DAC&PA, model non-linearity, this can be played with to see effects
RF_out_final = RF_out + 0.0001*RF_out.^2 + 0.0005*RF_out.^3;
fft_my(RF_out', fs, fin_LO-fin_new, 1)
