% INTERP2D Two dimensional table lookup with held endpoints
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Interp2D:
%     Two dimensional table lookup with held endpoints
%
% SYNTAX:
%	[VI] = Interp2D(DataX1, DataX2, Table2D, LookupX1, LookupX2, flgHoldEPs)
%	[VI] = Interp2D(DataX1, DataX2, Table2D, LookupX1, LookupX2)
%
% INPUTS:
%	Name		Size        Units	Description
%	DataX1		[M]         [N/A]   Breakpont of independent variable #1
%	DataX2		[N]         [N/A]   Breakpont of independent variable #2
%	Table2D		[M x N]     [N/A]   Dependent data, 2D table data
%	LookupX1	[m]         [N/A]   DataX1 Values to look up
%	LookupX2	[n]         [N/A]   DataX2 Values to look up
%   flgHoldEPs  [1]         [bool]  Hold Endpoints for out of bound 
%                                    lookups? False returns 0 for all out 
%                                    of bound points. (Default: true)
% OUTPUTS:
%	Name		Size        Units	Description
%	 VI         [m x n]     [N/A]   Interpolated Data
%
% NOTES:
%	 MATLAB's interpn returns 'NaN' for out of bounds
%
% EXAMPLES:
%   Example1: Interpolation of point within the data
%             DataX1  = [1 2 3]; DataX2  = [0 1 2 3 4];
%             Table2D=[1 2 3 4 5;5 6 7 8 9;9 10 11 12 13];
%             LookupX1=[1 2.5 3]; LookupX2=[0.5 1 3.5];
%
%             [VI]= Interp2D(DataX1,DataX2,Table2D,LookupX1,LookupX2);
%             Returns VI =[ 1.5000    8.0000   12.5000]
%
%   Example 2: Extrapolation of points outside the range
%             DataX1  = [1 2 3];
%             DataX2  = [0 1 2 3 4];
%             Table2D=[1 2 3 4 5;5 6 7 8 9;9 10 11 12 13];
%             LookupX1=[0.5 2 3.5 3]; LookupX2=[0 -.5 4 4.5];
%             [VI]= Interp2D(DataX1,DataX2,Table2D,LookupX1,LookupX2);
%             Returns VI =[ 1     5    13    13 ] %holds the end points
%
%             Compare with output if MATLAB's interpn
%             arrY2 = interpn(DataX1,DataX2,Table2D,LookupX1,LookupX2)
%             arrY2 =   NaN    NaN    NaN       NaN
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Interp2D.m">Interp2D.m</a>
%	  Driver script: <a href="matlab:edit Driver_Interp2D.m">Driver_Interp2D.m</a>
%	  Documentation: <a href="matlab:winopen(which('Interp2D_Function_Documentation.pptx'));">Interp2D_Function_Documentation.pptx</a>
%
% See also  Interp1D Interp3D Interp4D Interp5D Interp6D
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/452
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/Interp2D.m $
% $Rev: 2602 $
% $Date: 2012-11-01 20:45:40 -0500 (Thu, 01 Nov 2012) $
% $Author: sufanmi $

function [VI] = Interp2D(DataX1,DataX2,Table2D,LookupX1,LookupX2,flgHoldEPs)

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

%% Input check:
if(nargin < 5)
    disp([mfnam '>> ERROR: Not Enough Input Arguments.  See <a href="matlab:help Interp2D.m">help Interp2D</a>']);
    disp([mfspc '          ' num2str(nargin) ' provided when 5 required']);
    error([mfnam ':InputArgCheck'], 'Not Enough Input Arguments');
end

if(nargin == 5)
    flgHoldEPs = 1;
end

%% Main Function:
if(flgHoldEPs)
    % %% Check DataX1 Breakpoints:
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
end

%% Look up the data:
try
    % 2012a & newer
    F= griddedInterpolant({DataX1, DataX2}, Table2D);
    VI= (F({LookupX1 LookupX2}));
catch
    %% Call interpn:
    % 2011b & older
    VI = interpn( DataX1, DataX2, Table2D, ...
        LookupX1, LookupX2 );
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
% 100819  JJ: Filled the description and units of the I/O added input check
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
