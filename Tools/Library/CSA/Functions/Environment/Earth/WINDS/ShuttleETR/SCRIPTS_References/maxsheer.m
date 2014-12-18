function [normP, velocityfilt, azimuthfilt] = maxsheer(azimuth, velocity)

%% Filter the data:
[numvel, denvel] = cheby1(6, 0.1, 0.05, 'low');
[numaz, denaz] = cheby1(6, 0.075, 0.06, 'low');
velocityfilt = filtfilt(numvel, denvel, velocity);
% azimuthfilt = filtfilt(numaz, denaz, azimuth);
azimuthfilt = azimuth;

[X,Y]=pol2cart(azimuthfilt*pi/180, velocityfilt);
wind = [X, Y];

% diffP = diff(wind)./25;
diffP(:,1) = gradient(wind(:,1), 25);
diffP(:,2) = gradient(wind(:,2), 25);

normP = sqrt(diffP(:,1).^2 + diffP(:,2).^2);



