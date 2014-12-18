function Out = ReadWindMonth(datafile)
%% NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
%% Parse Text File Data form Excel saves:
%
% This script is intended to read the Suttle STS ETR wind data files which
% are in ASCII format. It will create one Matlab variable with the data in
% it for the Wind Month which is read in.
%

% Loop around to get all the data for the velocity:
for set = 1 : 150
    disp(['Reading set # ' num2str(set)]);

    %% Read the Azimuth:
    % Build the Excel read location strings:
    startrow = 61 * set - 59;
    endrow = startrow + 29;

    readstring = sprintf('a%d:aa%d', startrow, endrow);

    data = xlsread(datafile, readstring);

    % Reshape to an array:
    data = reshape(data', numel(data), 1);
    Out.azimuth(set, :) = data(1:801)';

    %% Read the Velocity:
    startrow = 61 * set - 29;
    endrow = startrow + 58;
    
    readstring = sprintf('a%d:aa%d', startrow, endrow);

    data = xlsread(datafile, readstring);

    % Reshape to an array:
    data = reshape(data', numel(data), 1);
    Out.velocity(set, :) = data(1:801)';
    
    %% Build the alititude
    Out.altitude(set, :) = [0:25:800*25]';

end

save([datafile '.mat'], 'Out');
disp(sprintf('Saved file %s.mat\n', datafile));





