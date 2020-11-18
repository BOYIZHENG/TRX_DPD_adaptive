function [THD, SFDR, spectrumdB,fout] = fft_my(data, Fs, Fin, fignum)
% Order of hann window
w_pwr = 2;

% find N for vector length to send fft functionc
long = length(data);
N = floor( log(long)/log(2) ) ; %this ensures 2^N <= length of data vector
dataforfft = data( ((long - 2^N) + 1): long) ; %this makes a new vector with the last 2^N points

points = length(dataforfft) ; %number of fft points
f = 0:1:(points - 1 );
f = f .* (Fs/points) ;
w = hann(points,'periodic').^w_pwr;
Y = fft(dataforfft.*w,points)+1e-10;
Pyy = (Y.*conj(Y))/points ;   %this is magnitude squared

bins = points/2 +1 ;


harmonic = zeros(1,10);

for ii = 1:1:10 %calculate fundamental and harmonics
    harmonic(ii) = ii*Fin ;
    while(harmonic(ii) >= Fs)       %this loop checks aliases of harmonics
        harmonic(ii) = harmonic(ii) - Fs;
    end
    if( harmonic(ii) > (Fs/2) ) 
        harmonic(ii) = round((Fs - harmonic(ii))*(points/Fs))+1 ;
    else
        harmonic(ii) = round( harmonic(ii)*(points/Fs)) +1 ;
    end
end

spectrum = (Pyy(1:bins)) ;
spectrum(bins) = spectrum(bins)*.5 ; %this halves energy in N/2 bin
spectrumdB = 10*log10(spectrum) ; %this makes it  power, 
spectrumdB = spectrumdB - spectrumdB(harmonic(1)); %this normalizes to fundamental


THD = 100 * sum(spectrum(harmonic(2:8)))./spectrum(harmonic(1));% in %

SFDR = spectrumdB(harmonic(1)) - spectrumdB( find (spectrumdB == ...
    max(spectrumdB(harmonic(2:10)))));


if fignum > 0
    figure(fignum)
    plot(f(1:bins), spectrumdB);
    xlabel('Frequency, Hz'), ylabel('Magnitude Normalized to Fundamental, dB'),
end
fout = f(1:bins);
end

