% INTERP9D Nine dimensional table lookup with held endpoints
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% Interp9D:
%     Nine dimensional table lookup with held endpoints
%
% SYNTAX:
%	[VI] = Interp4D(DataX1, DataX2, DataX3, DataX4, DataX5, DataX6, ...
%                       DataX7, DataX8, DataX9, Table9D, ...
%                       LookupX1, LookupX2, LookupX3, LookupX4, ...
%                       LookupX5, LookupX6, LookupX7, LookupX8, ...
%                       LookupX9, flgHoldEPs)
%
% INPUTS:
%	Name		Size            Units	Description
%	DataX1		[M]             [N/A]   Breakpont of independent variable #1
%	DataX2		[N]             [N/A]   Breakpont of independent variable #2
%	DataX3		[O]             [N/A]   Breakpont of independent variable #3
%	DataX4		[P]             [N/A]   Breakpont of independent variable #4
%	DataX5		[Q]             [N/A]   Breakpont of independent variable #5
%	DataX6		[R]             [N/A]   Breakpont of independent variable #6
%	DataX7		[S]             [N/A]   Breakpont of independent variable #7
%	DataX8		[T]             [N/A]   Breakpont of independent variable #8
%	DataX9		[U]             [N/A]   Breakpont of independent variable #9
%	Table9D		[M x N x O x ...
%                P x Q x R x ...
%                S x T x U]     [N/A]   Dependent data, 9D table data
%	LookupX1	[m]             [N/A]   DataX1 Values to look up
%	LookupX2	[n]             [N/A]   DataX2 Values to look up
%	LookupX3	[o]             [N/A]   DataX3 Values to look up
%	LookupX4	[p]             [N/A]   DataX4 Values to look up
%	LookupX5	[q]             [N/A]   DataX5 Values to look up
%	LookupX6	[r]             [N/A]   DataX6 Values to look up
%	LookupX7	[s]             [N/A]   DataX7 Values to look up
%	LookupX8	[t]             [N/A]   DataX8 Values to look up
%	LookupX9	[u]             [N/A]   DataX9 Values to look up
%   flgHoldEPs  [1]             [bool]  Hold Endpoints for out of bound 
%                                       lookups? False returns 0 for all out 
%                                       of bound points. (Default: true)
%   flgUseGI    [1]             [bool]  Use 'griddedInterpolant' over
%                                       'interpn'? (Default: true)
%  
% OUTPUTS:
%	Name		Size            Units	Description
%	 VI         [m x n x o x ...
%                p x q x r x ...
%                s x t x u]     [N/A]   Interpolated Data
%
% NOTES:
%	 MATLAB's interpn returns 'NaN' for out of bounds
%
% EXAMPLES:
%   See Driver script for working examples
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit Interp4D.m">Interp9D.m</a>
%	  Driver script: <a href="matlab:edit Driver_Interp9D.m">Driver_Interp9D.m</a>
%	  Documentation: <a href="matlab:winopen(which('Interp9D Documentation.pptx'));">Interp9D Documentation.pptx</a>
%
% See also Interp1D Interp2D Interp3D Interp4D Interp5D Interp6D
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/842
%
% Copyright Northrop Grumman Corp 2013
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/Interp4D.m $
% $Rev: 2602 $
% $Date: 2012-11-01 18:45:40 -0700 (Thu, 01 Nov 2012) $
% $Author: sufanmi $

function [VI] = Interp9D(DataX1, DataX2, DataX3, DataX4, DataX5, ...
    DataX6, DataX7, DataX8, DataX9, Table9D, LookupX1, LookupX2, ...
    LookupX3, LookupX4, LookupX5, LookupX6, LookupX7, LookupX8, LookupX9, ...
    flgHoldEPs, flgUseGI)

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

%% Input checks:
if( (nargin < 21) || isempty(flgUseGI) )
    flgUseGI = 1;
end

if( (nargin < 20) || isempty(flgHoldEPs) )
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
    
    %% Check DataX7 Breakpoints:
    iX7high = find(LookupX7 > max(DataX7));
    if ~isempty(iX7high)
        LookupX7(iX7high) = max(DataX7);
    end
    
    iX7low = find(LookupX7 < min(DataX7));
    if ~isempty(iX7low)
        LookupX7(iX7low) = min(DataX7);
    end
    
    %% Check DataX8 Breakpoints:
    iX8high = find(LookupX8 > max(DataX8));
    if ~isempty(iX8high)
        LookupX8(iX8high) = max(DataX8);
    end
    
    iX8low = find(LookupX8 < min(DataX8));
    if ~isempty(iX8low)
        LookupX8(iX8low) = min(DataX8);
    end
    
    %% Check DataX9 Breakpoints:
    iX9high = find(LookupX9 > max(DataX9));
    if ~isempty(iX9high)
        LookupX9(iX9high) = max(DataX9);
    end
    
    iX9low = find(LookupX9 < min(DataX9));
    if ~isempty(iX9low)
        LookupX9(iX9low) = min(DataX9);
    end
    
end

%% Look up the data:
if(verLessThan('matlab', '7.14'))
    % Earlier than MATLAB 2012a
        VI = interpn(DataX1, DataX2, DataX3, DataX4, DataX5, ...
            DataX6, DataX7, DataX8, DataX9, Table9D, ...
            LookupX1, LookupX2, LookupX3, LookupX4, LookupX5, ...
            LookupX6, LookupX7, LookupX8, LookupX9);

else
     % MATLAB 2012a & newer
    if(flgUseGI)
        F  = griddedInterpolant({DataX1, DataX2, DataX3, DataX4, ...
            DataX5, DataX6, DataX7, DataX8, DataX9}, Table9D);
        VI = (F({LookupX1 LookupX2 LookupX3 LookupX4 ...
            LookupX5 LookupX6 LookupX7 LookupX8 LookupX9}));
    else
        VI = interpn(DataX1, DataX2, DataX3, DataX4, DataX5, ...
            DataX6, DataX7, DataX8, DataX9, Table9D, ...
            LookupX1, LookupX2, LookupX3, LookupX4, LookupX5, ...
            LookupX6, LookupX7, LookupX8, LookupX9);
    end
end

if(~flgHoldEPs)
    iNaN = isnan(VI);
    VI(iNaN) = 0;
end

end

%% AUTHORS
% INI: FullName     : Email                 : NGGN Username
% JMT: Janet Todd   : Janet.Todd@ngc.com    : B95685
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
