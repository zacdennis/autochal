% INTGTS Integrate a timeseries object
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% intgts:
%     Integrates a timeseries object for the length of the ts object.  Has
%     extra smarts to look at the units of the original ts when
%     propagating and determining units of output.
% 
% SYNTAX:
%	[ts_intg] = intgts(ts, varargin, 'PropertyName', PropertyValue)
%	[ts_intg] = intgts(ts, varargin)
%	[ts_intg] = intgts(ts)
%
% INPUTS: 
%	Name    	Size		Units           Description
%	ts  	    timeseries  [varies]        Timeseries object to integrate
%	varargin	[N/A]		[varies]        Optional function inputs that
%                                            should be entered in pairs.
%                                            See the 'VARARGIN' section
%                                            below for more details
%
% OUTPUTS: 
%	Name    	Size		Units           Description
%	ts_intg     timeseries  [varies*time]   Propagated timeseries
%
% NOTES:
%	VARARGIN PROPERTIES:
%	PropertyName	PropertyValue	Default         Description
%   'Name'          'string'        'intg(ts.Name)' Name to use for
%                                                    integrated timeseries
%   'Units'         'string'        ''              Units of integrated
%                                                    timeseries
%   'IC'            [varies]        zeros           Initial output
%   'IntgType'      'string'        'ForwardEuler'  Integration Scheme to
%                                                    use. Options include:
%                                                    'ForwardEuler'
%                                                    'BackwardsEuler'
% EXAMPLES:
%	% Example #1: Perform a double integration
%     t = [0:0.01:10];    % [sec]
%     y = sin(t);
%     tsDD = timeseries(y', t');
%     tsDD.Name = 'ThetaDDot';
%     tsDD.DataInfo.Units = '[deg/sec^2]';
% 
%     tsD = intgts(tsDD, 'Name', 'ThetaDot', 'IC', 1);
%     ts  = intgts(tsD, 'Name', 'Theta', 'IC', -10);
%
%     figure('Position',  [520   380   666   853])
%     subplot(311); plotts(tsDD, 'LegLoc', 'Best');
%     title('\bf\fontsize{14}Example #1: intgts');
%     subplot(312); plotts(tsD, 'LegLoc', 'Best');
%     subplot(313); plotts(ts, 'LegLoc', 'Best');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit intgts.m">intgts.m</a>
%	  Driver script: <a href="matlab:edit Driver_intgts.m">Driver_intgts.m</a>
%	  Documentation: <a href="matlab:winopen(which('intgts_Function_Documentation.pptx'));">intgts_Function_Documentation.pptx</a>
%
% See also plotts
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/814
%  
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/TimeseriesToolbox/intgts.m $
% $Rev: 3012 $
% $Date: 2013-09-12 19:39:49 -0500 (Thu, 12 Sep 2013) $
% $Author: sufanmi $

function [ts_intg] = intgts(ts, varargin)

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

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
[strName, varargin]     = format_varargin('Name','', 2, varargin);
[strUnits, varargin]    = format_varargin('Units','', 2, varargin);
[arrIC, varargin]       = format_varargin('IC','', 2, varargin);
[IntgType, varargin]    = format_varargin('IntgType','ForwardEuler', 2, varargin);

%% Main Function:
t = ts.Time;    % [sec]
flgSec = strcmp(ts.TimeInfo.Units', 'seconds');
if(~flgSec)
    % Not sure yet how to handle if not seconds
end

strRefUnits = ts.DataInfo.Units;
if(strcmp(strRefUnits(1), '['))
    strRefUnits = strRefUnits(2:end);
end
if(strcmp(strRefUnits(end), ']'))
    strRefUnits = strRefUnits(1:end-1);
end
ptrSlash = strfind(strRefUnits, '/');
if(~isempty(ptrSlash))
    strRefTime = strRefUnits(ptrSlash(end)+1:end);
else
    strRefTime = strRefUnits;
end
ptrExponent = strfind(strRefTime, '^');
if(~isempty(ptrExponent))
    strRefTime = strRefTime(1:ptrExponent-1);
end

flgNoTime = 0;
switch lower(strRefTime)
    case {'s';'sec';'seconds'}
        ratio = 1;          % [sec] to [sec]
    case {'m';'min';'minutes'}
        ratio = 1/60;       % [sec] to [min]
    case {'h';'hr';'hour'}
        ratio = 1/(60*60);  % [sec] to [hr]
    otherwise
        ratio = 1;
        flgNoTime = 1;
        strRefTime = 'sec';
end

u = ts.Data * ratio;
y = u * 0;

[numPts, numCol] = size(u);
if(isempty(arrIC))
    arrIC = zeros(1,numPts);
end

for iCol = 1:numCol
    y(1,iCol) = arrIC(iCol);
    
    for i = 2:numPts
        dt = t(i) - t(i-1);
        
        switch lower(IntgType)
            case 'forwardeuler'
                y(i) = y(i-1) + u(i-1)*dt;
            case 'backwardeuler'
                y(i) = y(i-1) + u(i)*dt;
        end
    end
end

ts_intg = timeseries(y, t);
if(isempty(strName))
    strName = sprintf('intg(%s)', ts.Name);
end
ts_intg.Name = strName;

if(isempty(strUnits))
    strUnits = ts.DataInfo.Units;
    if(strcmp(strUnits(1), '['))
        strUnits = strUnits(2:end);
    end
    if(strcmp(strUnits(end), ']'))
        strUnits = strUnits(1:end-1);
    end
    strUnits = ['[' strUnits ']'];
    strUnits = strrep(strUnits, ['/' strRefTime ']'], ']');
    strUnits = strrep(strUnits, ['/' strRefTime '^2]'], ['/' strRefTime]);
    strUnits = strrep(strUnits, ['/' strRefTime '^3]'], ['/' strRefTime '^2']);

    if(flgNoTime)
        strUnits = [strUnits(1:end-1) '*' strRefTime ']'];
    end
    
end
ts_intg.DataInfo.Units = strUnits;

end % << End of function intgts >>

%% REVISION HISTORY
% YYMMDD INI: note
% 130912 MWS: Created function using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName     : Email                 : NGGN Username
% MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi

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
