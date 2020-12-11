% TRX model for DPD
clear all
fs = 10e9;
uprate = 8;
fin =10e6;
fin_LO = 1e9;
fs_slow = fs/uprate;
sampLen = 2^11;
bit_ADC = 12;

time_slow  = 0:1/(fs/8):(sampLen-1)/(fs/8);
time  = 0:1/fs:(uprate*sampLen-1)/fs;

ampl      = 0.5; % p-p, max=0.5 for single tone

fin_new   = coherent_in(fin,fin_LO,fs,uprate*sampLen); 
fin_new   = coherent_in(fin,0,fs/8,sampLen); 


sysin_i   = ampl/2*cos((2*pi*fin_new).*time_slow); 
sysin_q   = ampl/2*sin((2*pi*fin_new).*time_slow);

% up-sample
sysin_i_up     = interpNRZ(sysin_i,uprate);
sysin_q_up     = interpNRZ(sysin_q,uprate);

% up-mixing
LO_i = cos((2*pi*fin_LO).*time);
LO_q = sin((2*pi*fin_LO).*time);
RF_out = sysin_i_up .* LO_i - sysin_q_up .* LO_q;

% DAC&PA, model non-linearity, this can be played with to see effects
RF_out_final = RF_out + 0.2*RF_out.^2 + 0.2*RF_out.^3;
%fft_my(RF_out_final', fs, fin_LO+fin_new, 1)
hold on
% RFADC
RF_out_quant = floor(RF_out_final*2^bit_ADC)/(2^bit_ADC);
%fft_my(RF_out_quant', fs, fin_LO+fin_new, 1);

% down mix
bb_i = RF_out_quant.*LO_i;
bb_q = RF_out_quant.*LO_q;
%fft_my(bb_i', fs,fin_new, 1)

% FIR filter
load('FIR_100MHzBW_10GSs_60dB.mat')
bb_i_fir = fir_my(bb_i,FIR_100MHzBW_10GSs_60dB);
bb_q_fir = fir_my(bb_q,FIR_100MHzBW_10GSs_60dB);
%fft_my(bb_i_fir', fs,fin_new, 1)

% down sample
bb_i_fir_down = bb_i_fir (1:uprate:end);
bb_q_fir_down = bb_q_fir (1:uprate:end);
fft_my(bb_i_fir_down', fs/8,fin_new, 1)

%dpd

