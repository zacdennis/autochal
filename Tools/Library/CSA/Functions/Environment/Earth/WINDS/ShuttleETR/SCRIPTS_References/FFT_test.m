Y=fft(ETR_Wind.apr.velocity(1, :));
Y=fft(ETR_Wind.apr.azimuth(1, :));
Pyy = Y.* conj(Y) / 512;
f = 1000*(0:256)/512;
plot(f,Pyy(1:257))
title('Frequency content of y')
xlabel('frequency (Hz)')
