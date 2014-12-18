% INTERP6D Six dimensional table lookup with held endpoints
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Interp6D:
%    Six dimensional table lookup with held endpoints
% 
% SYNTAX:
%	[VI] = Interp6D(DataX1, DataX2, DataX3, DataX4, DataX5, DataX6, Table6D, LookupX1, LookupX2, LookupX3, LookupX4, LookupX5, LookupX6, flgHoldEPs)
%	[VI] = Interp6D(DataX1, DataX2, DataX3, DataX4, DataX5, DataX6, Table6D, LookupX1, LookupX2, LookupX3, LookupX4, LookupX5, LookupX6)
%
% INPUTS: 
%	Name		Size                    Units	Description
%	DataX1		[M]                     [N/A]   Breakpont of independent variable #1
%	DataX2		[N]                     [N/A]   Breakpont of independent variable #2
%	DataX3		[O]                     [N/A]   Breakpont of independent variable #3
%	DataX4		[P]                     [N/A]   Breakpont of independent variable #4
%	DataX5		[Q]                     [N/A]   Breakpont of independent variable #5
%	DataX6		[R]                     [N/A]   Breakpont of independent variable #6
%	Table6D		[M x N x O x P x Q x R] [N/A]   Dependent data, 6D table data
%	LookupX1	[m]                     [N/A]   DataX1 Values to look up
%	LookupX2	[n]                     [N/A]   DataX2 Values to look up
%	LookupX3	[o]                     [N/A]   DataX3 Values to look up
%	LookupX4	[p]                     [N/A]   DataX4 Values to look up
%	LookupX5	[q]                     [N/A]   DataX5 Values to look up
%	LookupX5	[r]                     [N/A]   DataX6 Values to look up
%   flgHoldEPs  [1]                     [bool]  Hold Endpoints for out of bound
%                                               lookups? False returns 0 for all out
%                                               of bound points. (Default: true)
% OUTPUTS:
%	Name		Size                    Units	Description
%	 VI         [m x n x o x p x q x r] [N/A]   Interpolated Data
%
% NOTES:
%	 MATLAB's interpn returns 'NaN' for out of bounds
%
% EXAMPLES:
%   See Driver script for working examples
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Interp6D.m">Interp6D.m</a>
%	  Driver script: <a href="matlab:edit DRIVER_Interp6D.m">DRIVER_Interp6D.m</a>
%	  Documentation: <a href="matlab:winopen(which('Interp6D Documentation.pptx'));">Interp6D Documentation.pptx</a>
%
% See also Interp1D Interp2D Interp3D Interp4D Interp5D
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/456
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/Interp6D.m $
% $Rev: 2602 $
% $Date: 2012-11-01 20:45:40 -0500 (Thu, 01 Nov 2012) $
% $Author: sufanmi $

function [VI] = Interp6D(DataX1,DataX2,DataX3,DataX4,DataX5,DataX6,Table6D,LookupX1,LookupX2,LookupX3,LookupX4,LookupX5,LookupX6,flgHoldEPs)

%% Debugging & Display Utilities:
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats:
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Initialize Outputs:
if(nargin == 13)
    flgHoldEPs = 1;
end

%% Main Function:
if(flgHoldEPs)
%% Check DataX1 Breakpoints:
iX1high = find(LookupX1 > max(DataX1));
if ~isempty(iX1high)
    LookupX1(iX1high) = max(DataX1);
end

iX1low = find(LookupX1 < min(DataX1));
if ~isempty(iX1low)
    LookupX1(iX1low) = min(DataX1);
end

%% Check DataX2 Breakpoints:
iX2high = find(LookupX2 > max(DataX2));
if ~isempty(iX2high)
    LookupX2(iX2high) = max(DataX2);
end

iX2low = find(LookupX2 < min(DataX2));
if ~isempty(iX2low)
    LookupX2(iX2low) = min(DataX2);
end

%% Check DataX3 Breakpoints:
iX3high = find(LookupX3 > max(DataX3));
if ~isempty(iX3high)
    LookupX3(iX3high) = max(DataX3);
end

iX3low = find(LookupX3 < min(DataX3));
if ~isempty(iX3low)
    LookupX3(iX3low) = min(DataX3);
end

%% Check DataX4 Breakpoints:
iX4high = find(LookupX4 > max(DataX4));
if ~isempty(iX4high)
    LookupX4(iX4high) = max(DataX4);
end

iX4low = find(LookupX4 < min(DataX4));
if ~isempty(iX4low)
    LookupX4(iX4low) = min(DataX4);
end

%% Check DataX5 Breakpoints:
iX5high = find(LookupX5 > max(DataX5));
if ~isempty(iX5high)
    LookupX5(iX5high) = max(DataX5);
end

iX5low = find(LookupX5 < min(DataX5));
if ~isempty(iX5low)
    LookupX5(iX5low) = min(DataX5);
end

%% Check DataX6 Breakpoints:
iX6high = find(LookupX6 > max(DataX6));
if ~isempty(iX6high)
    LookupX6(iX6high) = max(DataX6);
end

iX6low = find(LookupX6 < min(DataX6));
if ~isempty(iX6low)
    LookupX6(iX6low) = min(DataX6);
end
end

%% Look up the data:
try
    % 2012a & newer
    F= griddedInterpolant({DataX1, DataX2, DataX3, DataX4, DataX5, DataX6}, Table6D);
    VI= (F({LookupX1 LookupX2 LookupX3 LookupX4 LookupX5 LookupX6}));
catch
    %% Call interpn:
    % 2011b & older
    VI = interpn( DataX1, DataX2, DataX3, DataX4, DataX5, DataX6, Table6D, ...
        LookupX1, LookupX2, LookupX3, LookupX4, LookupX5, LookupX6);
end

if(~flgHoldEPs)
    iNaN = isnan(VI);
    VI(iNaN) = 0;
end

end 

%% REVISION HISTORY
% YYMMDD INI: note
% 121101 MWS: Added ability to disable the held enpoint (e.g. flgHoldEPs)
% 121030 MWS: Adding griddedInterpolant for use in 2012a & newer
% 100819 JJ: Filled the description and units of the I/O added input check
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName         : Email                             :  NGGN Username 
% JJ:  Jovany Jimenez   : Jovany.Jimenez-Deparias@ngc.com   : g67086
% MWS: Mike Sufana      : mike.sufana@ngc.com               : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
