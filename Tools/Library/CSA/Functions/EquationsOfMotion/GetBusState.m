% GETBUSSTATE returns Bus Values at User Specified Time
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% GetBusState:
%     Returns Bus Values at User Specified Time
% 
% SYNTAX:
%	[BusState] = GetBusState(InputBus, userTime, simtime)
%	[BusState] = GetBusState(InputBus, userTime)
%	[BusState] = GetBusState(InputBus)
%
% INPUTS: 
%	Name    	Size	Units		Description
%   InputBus     [structure]        Time History Structure (i.e. StateBus)
%   userTime    [1x1]   [sec]       Timestep at which to grab states (leave
%                                   blank, or use '[ ]' for final/end time)
%                                   {Default is end time}
%   simtime     [Mx1]   [sec]       Time History Time Vector
%                                   {If no simtime given, function will
%                                   search InputBus for a 'simtime'
%                                   vector}
%
% OUTPUTS: 
%	Name    	Size	Units		Description
%   BusState     [structure]        Bus States @ userTime
%
% NOTES:
%	<Any Additional Information>
%
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[BusState] = GetBusState(InputBus, userTime, simtime, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[BusState] = GetBusState(InputBus, userTime, simtime)
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
%	Source function: <a href="matlab:edit GetBusState.m">GetBusState.m</a>
%	  Driver script: <a href="matlab:edit Driver_GetBusState.m">Driver_GetBusState.m</a>
%	  Documentation: <a href="matlab:pptOpen('GetBusState_Function_Documentation.pptx');">GetBusState_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/391
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/EquationsOfMotion/GetBusState.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [BusState] = GetBusState(InputBus, userTime, simtime)

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
BusState= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        simtime= ''; userTime= ''; InputBus= ''; 
%       case 1
%        simtime= ''; userTime= ''; 
%       case 2
%        simtime= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(simtime))
%		simtime = -1;
%  end
%% Main Function:
%% Retrieve Bus Fieldnames:
arrFieldNames = listStruct(InputBus);

%% Find Pointers to Desired Time:
if exist('userTime')
    %% userTime is Defined, therefore simtime must exist

    %% Retrieve simtime:
    if ~exist('simtime')
        %%  Retrieve Simtime from InputBus (if it exists):
        for i = 1:length(arrFieldNames);
            if (findstr( char(arrFieldNames(i)), 'simtime') ~= 0)
                mem = eval(['InputBus.' char(arrFieldNames(i))]); 
                if isnumeric(mem)
                    simtime = mem;
                    break;
                end
            end
        end
    end
    
    if ~exist('simtime')
        disp('ERROR GetBusState: simtime must exist for a defined userTime');
        return;
    else

        %% Simtime exists, now find pointers to userTime
        if length(userTime) == 2
            ptrEnd = min(find(simtime >= userTime(2)));
            ptrStart = max(find(simtime <= userTime(1)));
            if isempty(ptrStart)
                ptrStart = 1;
            end            
        else
            ptrEnd = min(find(simtime >= userTime));
            ptrStart = ptrEnd;
        end
    end
end

%% Cycle Through Each Bus Member:
for i = 1:length(arrFieldNames);
    % Pick off member of InputBus:
    mem = eval(['InputBus.' char(arrFieldNames(i))]);
    sizemem = size(mem);
    
    if ~isnumeric(mem)
        eval(['BusState.' char(arrFieldNames(i)) ' = mem;']);
    else
        if exist('ptrEnd')
            if sizemem(1) > sizemem(2)
                eval(['BusState.' char(arrFieldNames(i)) ' = mem(ptrStart:ptrEnd,:);']);
            else
                eval(['BusState.' char(arrFieldNames(i)) ' = mem(:,ptrStart:ptrEnd);']);
            end
        else
            eval(['BusState.' char(arrFieldNames(i)) ' = mem(end,:);']);
        end
    end
end
%% Compile Outputs:
%	BusState= -1;

end % << End of function GetBusState >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
