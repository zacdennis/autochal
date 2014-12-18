% SAVESTKART Creates STK articulation file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SaveSTKart:
%     Creates STK articulation file
% 
% SYNTAX:
%	[] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus, filetype, varargin, 'PropertyName', PropertyValue)
%	[] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus, filetype, varargin)
%	[] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus, filetype)
%	[] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus)
%
% INPUTS: 
%	Name     	Size		Units		Description
%   STKBus     {struct}    Actuator 'Results' structure that contains
%                               surface deflections, RCS thrust levels,
%                               and/or engine throttle levels
%                               (e.g. Results.Stage1.STKBus)
%   vehSTKBus  [string]    Name of Vehicle articulation file is for
%                               (e.g. 'Stage1')
%   lstSTKBus  {struct}    List of control surfaces with STK
%                               articulation command.  Note that control
%                               surfaces and gimbals are typically called
%                               'Deflect'.  Rocket engines like RCS and
%                               Boosters are called 'Size'.
%                                Example:
%                                 lstSTKBus = {'Flap'   'Deflect';
%                                                   'RCS'    'Size'};
%   filetype   [string]    File type of articulation file
%                                  Examples:
%                                   'sama': Spacecraft/satellite {default}
%                                   'acma': Aircraft
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	    	         <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus, filetype, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus, filetype)
%	% <Copy expected outputs from Command Window>
%
% SOURCE DOCUMENTATION:
% <Enter as many sources as needed.  Some popular ones are listed here.>
% <Note, these citation examples came from: http://honolulu.hawaii.edu/legacylib/mlahcc.html >
% Website Citation:
% [1]   Author.  "Title of Web Page." Title of the Site. Editor. Dat and/or Version Number.
%       Date of Access <URL>
% Book with One Author:
% [2]   Author Last Name, Author First Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
% Book with Two Author:
% [3]   Author #1 Last Name, Author #1 First Name, and Author #2 Full Name. Title of Book. City of Publication: Publisher, Year. Eqn #, pg #
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit SaveSTKart.m">SaveSTKart.m</a>
%	  Driver script: <a href="matlab:edit Driver_SaveSTKart.m">Driver_SaveSTKart.m</a>
%	  Documentation: <a href="matlab:pptOpen('SaveSTKart_Function_Documentation.pptx');">SaveSTKart_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/555
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/STK/SaveSTKart.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = SaveSTKart(STKBus, vehSTKBus, lstSTKBus, filetype, varargin)

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

%% Initialize Outputs:


%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        filetype= ''; lstSTKBus= ''; vehSTKBus= ''; STKBus= ''; 
%       case 1
%        filetype= ''; lstSTKBus= ''; vehSTKBus= ''; 
%       case 2
%        filetype= ''; lstSTKBus= ''; 
%       case 3
%        filetype= ''; 
%       case 4
%        
%       case 5
%        
%  end
%
%  if(isempty(filetype))
%		filetype = -1;
%  end
%% Main Function:
%% Create a waitbar:
h = waitbar(0,['Writing Articulation File for ' strrep(vehSTKBus, '_', '\_')]);
progress = 0;

if nargin < 4
    filetype = 'sama';      % Default to spacecraft
end

warning off MATLAB:DELETE:FileNotFound;

%% Stand-Alone Filename:
iPeriod = max(find(filetype == '.')); %#ok<MXFND>
if isempty(iPeriod)
    ArticulationFilename = [vehSTKBus '.' filetype];
else
    ArticulationFilename = [vehSTKBus '.' filetype(iPeriod+1:end)];
end

%% Create Local Control Surface matrix, CS:
%   Matrix contains the time histories of the desired STK articulations

iCSfull = 0;        % [int] Initialize Master Counter

%   Loop Through Each Control Surface:
for iCS = 1: size(lstSTKBus, 1);
    % Update Waitbar:
    progress = progress + 1;
    waitbar(progress / size(lstSTKBus, 1), h);
    
    strCSsim    = (lstSTKBus(iCS,1));       % [string]
    strCSstk    = (lstSTKBus(iCS,2));       % [string]
    strCmd      = (lstSTKBus(iCS,3));       % [string]
    ec          = ['CS = STKBus.' char(strCSsim) ';'];
    eval(ec);
    numCSs      = size(CS,2); %#ok<NODEF>

    % For Control Surface Carrying Multiple Dimensions (e.g. RCS), loop
    % through each dimension:
    for iCSs = 1:numCSs;
        iCSfull = iCSfull + 1;  % Increment Master Control Surface Counter
        matCS(:,iCSfull) = CS(:,iCSs);      % Add Time Histories to matCS
        arrCScmd(iCSfull,:) = strCmd;       % Add Articulation Cmd to arrCScmd

        % Buildup Control Surface Name:
        if(numCSs > 1)
            arrCSname(iCSfull, :) = strcat(strCSstk, num2str(iCSs));
        else
            arrCSname(iCSfull, :) = strCSstk;
        end
    end
end
% Close Waitbar
close(h);
%% ========================================================================
%                           CREATE ARTICULATION FILE
%% ========================================================================
% SPREADSHEET
%     STARTTIME
%     DURATION
%     DEADBANDDURATION
%     ACCELDURATION
%     DECELDURATION
%     DUTYCYCLEDELTA
%     PERIOD
%     ARTICULATION
%     TRANSFORMATION
%     STARTVALUE
%     ENDVALUE
%
% Sample Format (for Control Surfaces):
% ARTICULATION 2.6000 0 0 0 0 0 0 ControlSurface Deflect 0 1.0000
% ARTICULATION 2.7000 0 0 0 0 0 0 ControlSurface Deflect 0 0.0000

%% Create a waitbar:
h = waitbar(0,['Writing Articulation File for ' strrep(vehSTKBus, '_', '\_') '...']);
progress = 0;

%% Delete and Create the Articulation File:
delete(ArticulationFilename);
fid = fopen(ArticulationFilename, 'w');

% Add Header Information:
fprintf(fid, 'SPREADSHEET\n\n');

% Always Record the First Timestep
% Loop Through Each Control Surface:
for iCSfull = 1: size(arrCSname, 1);
    strCSstk    = char(arrCSname(iCSfull, :));
    strCmd      = char(arrCScmd(iCSfull, :));
    CS          = matCS(:,iCSfull);
    fprintf(fid, 'ARTICULATION  %.2f .01 0 0 0 0 0 %s %s %.2f %.2f\n',...
        STKBus.simtime(1),...
        strCSstk,...
        strCmd,...
        CS(1),...
        CS(1));
    lastRecord(iCSfull) = 1;    % Update lastRecord index
end

% Loop Through Each Timestep:
for iTime = 2 : length(STKBus.simtime);
    % Update Waitbar:
    progress = progress + 1;
    waitbar(progress / length(STKBus.simtime), h);

    % Loop Through Each Control Surface:
    for iCSfull = 1: size(arrCSname, 1);
        strCSstk    = char(arrCSname(iCSfull, :));
        strCmd      = char(arrCScmd(iCSfull, :));
        CS          = matCS(:,iCSfull);

        % Determine if the Control Surface has changed since the
        % last STK recorded time.  If the Surface has not moved
        % past the given tolerances, don't bother recording the new
        % position.  This saves on file space.
        %
        % NOTE: The hard-coded tolerance (5e-3) is a function of the
        % significant digits that the fprintf function writes the
        % articulation file in.
        %   If the desired is %.2f, then the tolerance is (0.5 *
        %   1e-2, or 5e-3).
        surfDelta = CS(iTime) - CS(lastRecord(iCSfull));

        if (abs(surfDelta )) >= 5e-3;
            lastRecord(iCSfull) = iTime;    % Update lastRecord index
            % Write the Control Surface articulations:
            fprintf(fid, 'ARTICULATION  %.2f .01 0 0 0 0 0 %s %s %.2f %.2f\n',...
                STKBus.simtime(iTime), strCSstk, strCmd, CS(iTime), CS(iTime));
        end
    end
end

fclose(fid);

% Close Waitbar
close(h);
warning on MATLAB:DELETE:FileNotFound;
nowStr = [datestr(now, 'dddd, mmmm') datestr(now,' dd, yyyy @ HH:MM:SS PM')];
disp(['New ' filetype ' File Created:       ' char(ArticulationFilename) ' {' nowStr '}']);


%% Compile Outputs:
%	= -1;

end % << End of function SaveSTKart >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720

%% FOOTER
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
