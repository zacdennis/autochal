% PARSERECORDEDDATA Parses a mat file of time history data into a structure
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ParseRecordedData:
%   Parses a mat file of time history data into a plottable structure 
% 
% SYNTAX:
%	[Results] = ParseRecordedData(Results, strMatFile, ListMatFile, OutputStruct, flgVerbose)
%	[Results] = ParseRecordedData(Results, strMatFile, ListMatFile, OutputStruct)
%	[Results] = ParseRecordedData(Results, strMatFile, ListMatFile)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	Results         {struct}    N/A         Results Structure to add parsed
%                                            data to
%	strMatFile      'string'    [char]      String of Mat File containing
%                                           run results from a Simulink 
%                                           'To File' block
%	ListMatFile     {[Mx3]}                 Cell list defining recorded
%                                            data where:
%                                            Column 1: String identifier of data
%                                            Column 2: Size of data
%                                            Column 3: Data units in string form
%   OutputStruct    'string'     [char]     Additional Struct Name (Optional)
%                                            Default: '' (empty string)
%   flgVerbose      [1]         [bool]      Display Parsing? (Optional)
%                                           Default: 1 (true)
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%   Results       [various] [various]    Input Results Structure with added data
%
% NOTES:
%
% EXAMPLES:
%   Suppose that a single signal (e.g. StateBus.P_i) was recorded for
%   100 timesteps from a simulink model using a 'To File' block.
%
%   Assumptions:    The Filename (strMatFile) is 'StateBus.mat'
%                   The Variable name is 'StateBus'
%
%   Because the 'To File' block automatically saves the timestep along with
%   the desired signal, ListMatFile becomes:
%    
%   ListMatFile = {'StateBus.simtime'   1   '[sec]';
%     'StateBus.P_i'                    3   '[ft]'};
%
%   When parsed, the returned Results structure becomes:
%
%   Results.StateBus
%             Units:    [1x1 struct]
%           simtime:    [100x1 double]
%               P_i:    [100x3 double]
%
%   where...
%
%   Results.StateBus.Units
%           simtime:    '[sec]'
%               P_i:    '[ft]'
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/494
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/ParseRecordedData.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Results] = ParseRecordedData(Results, strMatFile, ListMatFile, OutputStruct, flgVerbose, varargin)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
mlink = ['<a href = "matlab:help ' mfnam '">' mfnam '</a>']; % Hyperlink to mask help that can be added to a error disp

% Examples of Different Display Formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfnam '>> ERROR: <define error here> See ' mlink ' help'];      % <-- Couple with error function
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function with error string

%% Input Argument Checking:
if nargin < 5
    flgVerbose = 1;
end

if nargin < 4
    OutputStruct = '';
end

%% Check OutputStruct:
if(~isempty(OutputStruct))
    OutputStruct = [OutputStruct '.'];
end

%% Input Error Checking:
%   Remove '.mat' from strMatFile, if it exists
ptrMat = findstr(strMatFile, '.mat');
if(~isempty(ptrMat))
    strMatFile = strMatFile(1:(ptrMat-1));
end

if(exist([strMatFile '.mat']))
    load([strMatFile '.mat']);
    if(flgVerbose)
        disp(['ParseRecordedData : Parsing ' strMatFile]);
    end

    %% Error Checking:
    sizeExpected = sum(cell2mat(ListMatFile(:,2)));
    sizeRecorded = size(eval(strMatFile),1);

    if (sizeExpected ~= sizeRecorded)
        disp(' ');
        disp(['ERROR : ParseRecordedData : Size Mismatched in parsing ' strMatFile '!']);
        disp([' The size of the expected data (' ...
            num2str(sizeExpected) ') does NOT match the']);
        disp(['size of the recorded data (' num2str(sizeRecorded) ').']);

        disp(' Data will NOT be Parsed.');

    else

        %% Add Date/Time at which Data was Parsed/Recorded
        DataRecorded = [datestr(now, 'dddd, mmmm') ...
            datestr(now,' dd, yyyy @ HH:MM:SS PM')];
        ec = sprintf('Results.%sDataRecorded = ''%s'';', ...
            char(OutputStruct), DataRecorded );
        eval(ec);
        
        k = 0;
        for i = 1:size(ListMatFile,1);
            %% Loop Through the Dimensions of the ListMatFile Member
            for j = 1:cell2mat(ListMatFile(i,2));
                k = k + 1;

                %% Add the Units to the Results Structure:
                strMember = char(ListMatFile(i,1));
                ptrEnd = max(findstr(strMember, '.'));
                if(~isempty(ptrEnd))
                    ec = sprintf('Results.%s%s.Units.%s = char(ListMatFile(i,3));', ...
                        char(OutputStruct), strMember(1:(ptrEnd-1)), ...
                        strMember((ptrEnd+1):end) );
                else
                    
                    if(isempty(OutputStruct))
                        ec = sprintf('Results.Units.%s = char(ListMatFile(i,3));', ...
                            char(strMember) );
                    else
                        
                    ec = sprintf('Results.%s.Units.%s = char(ListMatFile(i,3));', ...
                        char(OutputStruct), char(strMember) );                    
                    end
                end
                ec = strrep(ec, '..', '.');
                eval(ec);

                %% Add the Recorded Value to the Results Structure:
                ec = sprintf('Results.%s%s(:,%.0f) = %s(%.0f,:)'';', ...
                    char(OutputStruct), char(ListMatFile(i,1)), j, strMatFile, k);
                eval(ec);

            end
        end
    end
end

end % << End of function ParseRecordedData >>

%% REVISION HISTORY
% YYMMDD INI: note
% <YYMMDD> <initials>: <Revision update note>
% 101019 MWS: Cleaned up internal documentation with CreateNewFunc
% 061106 MWS: Originally created function
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
