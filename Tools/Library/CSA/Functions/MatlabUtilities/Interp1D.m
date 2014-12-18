% INTERP1D One dimensional linear table lookup
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Interp1D:
%   One dimensional table lookup with held or linearly extrapolated 
%   endpoints
% 
% SYNTAX:
%	[VI] = Interp1D(DataX1, Table1D, LookupX1, strInterp)
%	[VI] = Interp1D(DataX1, Table1D, LookupX1)
%
% INPUTS: 
%	Name        Size            Units       Description
%   DataX1     [1xn] or [nx1]   [N/A]       Breakpoints of independent variable
%   Table1D    [1xn] or [nx1]   [N/A]       Dependent data, 1D table data
%   LookupX1   [1xm] or [mx1]   [N/A]       Values at which to interpolate Table1D
%   strInterp  [1] or 'string'  'bool'     Interpolation Method
%                                or char    0/'linear': Linear interpolation
%                                                     with held endpoints
%                                                     (Default)
%                                           1/'extrap': Linear interpolation
%                                                     with linear
%                                                     extrapolation
%                                           'below': Use value below
%                                           'above': Use value above
%                                           'nearest': Use value nearest
% OUTPUTS: 
%	Name        Size            Units      Description
%	 VI         [1xm] or [mx1]  [N/A]      Interpolated Data
%
% NOTES:
%	 MATLAB's interpn returns 'NaN' for out of bounds
%    Linear extrapolation is based on the last two endpoints
%
% EXAMPLE:
%   % Example 1: Lookup data using simple table and held endpoints
%   %            Note data is in row form
%   arrX = [0 1];           % Independent Breakpoints
%   tblY = [2 1];           % 1-D Table Data
%   arrX2 = [-1 0.5 1 2];   % Points to look up
%   % Note that there are 3 different methods for this
%   arrY = Interp1D(arrX, tblY, arrX2)
%   arrY = Interp1D(arrX, tblY, arrX2, 0)
%   arrY = Interp1D(arrX, tblY, arrX2, 'interp')
%   % arrY =  2.0000    1.5000    1.0000    1.0000
%
%   % Compare with output if MATLAB's interp1
%   arrY2 = interp1(arrX, tblY, arrX2)
%   % arrY2 =   NaN    1.5000    1.0000       NaN
%
%   % Example 2: Same as before, but with extrapolated endpoints
%   % Note that there are 2 different methods for this
%   arrY = Interp1D(arrX, tblY, arrX2, 1)
%   arrY = Interp1D(arrX, tblY, arrX2, 'extrap')
%   % arrY =  3.0000    1.5000    1.0000         0
%
%   % Example 3: Lookup data using simple table and held endpoints
%   %            Note data is in column form
%   arrX = [0; 1];              % Independent Breakpoints
%   tblY = [2; 1];              % 1-D Table Data
%   arrX2 = [-1; 0.5; 1; 2];    % Points to look up
%   arrY = Interp1D(arrX, tblY, arrX2)
%   % arrY =
%   %     2.0000
%   %     1.5000
%   %     1.0000
%   %     1.0000
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Interp1D.m">Interp1D.m</a>
%	  Driver script: <a href="matlab:edit Driver_Interp1D.m">Driver_Interp1D.m</a>
%	  Documentation: <a href="matlab:pptOpen('Interp1D_Function_Documentation.pptx');">Interp1D_Function_Documentation.pptx</a>
%
% See also interp1
%
%
% VERIFICATION DETAILS:
% Verified: Partially. r221 was Verified via Peer Reviewed.
%           Enhancements since r221 have not been Verified.
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/120
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/Interp1D.m $
% $Rev: 2473 $
% $Date: 2012-09-05 18:46:08 -0500 (Wed, 05 Sep 2012) $
% $Author: sufanmi $

function [VI] = Interp1D(DataX1, Table1D, LookupX1, strInterp)

%% General Header 
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
[mfpath,mfnam] = fileparts(mfilename('fullpath'));
mfspc = char(ones(1,length(mfnam))*spc);

%% < Function Sections >
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Checking & Conditioning:
if(nargin < 3)
    disp([mfnam '>> ERROR: Not Enough Input Arguments.  See <a href="matlab:help Interp1D.m">help Interp1D</a>']);
    disp([mfspc '          ' num2str(nargin) ' provided when 3 or 4 required']);
    error([mfnam ':InputArgCheck'], 'Not Enough Input Arguments');
end

if( (nargin < 4) || isempty(strInterp) )
    strInterp = 'linear';
end

% Support Old 'flgExtrap'
if( strInterp == 0 )
    strInterp = 'linear';
elseif( strInterp == 1 )
    strInterp = 'extrap';
end
flgExtrap = strcmp(lower(strInterp), 'extrap');

%% Check DataX1 Breakpoints:
iX1high = find(LookupX1 > max(DataX1));
if (~isempty(iX1high) && (~flgExtrap))
    LookupX1(iX1high) = max(DataX1);
end

iX1low = find(LookupX1 < min(DataX1));
if (~isempty(iX1low) && (~flgExtrap))
    LookupX1(iX1low) = min(DataX1);
end

%% Call interpn:
switch lower(strInterp)
    case 'linear'
        % Linear Interpolation with Held Endpoints
        VI = interp1( DataX1, Table1D, LookupX1);
        
    case 'extrap'
        % Linear Interpolation with Linear Extrapolation
        VI = interp1( DataX1, Table1D, LookupX1);
        
        if ~isempty(iX1high)
            mHigh = (Table1D(end) - Table1D(end-1))/(DataX1(end) - DataX1(end-1));
            VI(iX1high) = Table1D(end) + mHigh*(LookupX1(iX1high) - DataX1(end));
        end
        
        if ~isempty(iX1low)
            mLow = (Table1D(2) - Table1D(1))/(DataX1(2) - DataX1(1));
            VI(iX1low) = Table1D(1) - mLow*(DataX1(1) - LookupX1(iX1low));
        end
        
    case 'below'
        % Use Value Below
        idxVI = interp1( DataX1, [1:length(DataX1)], LookupX1);
        idxVI = floor(idxVI);
        VI = Table1D(idxVI);
        
    case 'above'
        % Use Value Above
        idxVI = interp1( DataX1, [1:length(DataX1)], LookupX1);
        idxVI = ceil(idxVI);
        VI = Table1D(idxVI);
        
    case 'nearest'
        % Use Nearest Value
        idxVI = interp1( DataX1, [1:length(DataX1)], LookupX1);
        idxVI = round(idxVI);
        VI = Table1D(idxVI);
        
end

%% Return 
end 

%% REVISION HISTORY
% YYMMDD INI: note
% 100811 MWS: Used CreateNewFunc to reformat internal documentation fields
% 070913 MWS: Originally created function for VSI Library
%             https://vodka.ccc.northgrum.com/svn/VSI_LIB/trunk/CORE/MATLAB_UTILITES/Interp1D.m
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
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
