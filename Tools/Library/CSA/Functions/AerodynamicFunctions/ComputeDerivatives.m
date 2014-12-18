% COMPUTEDERIVATIVES Computes derivative of a function y = f(x) using various methods
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ComputeDerivatives:
%   Computes the derivative of some function y = f(x) using a variant of a
%   tangent line approximation.
% 
% SYNTAX:
%	[dydx] = ComputeDerivatives(x, y, strType)
%	[dydx] = ComputeDerivatives(x, y)
%
% INPUTS: 
%	Name        Size        Units   Description
%   x           [1xn]       [N/A]   Array of x-points
%   y           [1xn]       [N/A]   Array of y-points
%   strType     'string'    [char]  Type of derivative to perform. Options:
%                                    'uniform'      <-- Default
%                                    'nonuniform'
%
% OUTPUTS: 
%	Name        Size        Units	Description
%   dydx        [1xn]       [N/A]   Array of dy/dx for each x
%
% NOTES:
%   'uniform' Method: 
%       Computes the linear derivative of some function y = f(x) using a 
%       tangent line approximation. The function grabs 20*(number of 
%       y-points) number of points between points using a spline fit and 
%       then computes the forward, central, and backward difference for 
%       derivatives. This is then interpolated for each x-point. It is 
%       recommended that this only be used on data which is uniformly 
%       distributed in x.
%
%   'nonuniform' Method:
%       Computes the linear derivative of some function y = f(x) using a 
%       tangent line approximation. Unlike 'uniform', this method does NOT 
%       do any curve fitting of the data. It merely does a forward 
%       difference on the first point, central differences on the 
%       midpoints, and backward difference on the end point. This is better
%       suited for use on data which is not uniform distributed in x.
%
% EXAMPLES:
%   % Example #1: Compute derivative of a continuous and fragmented sine wave
%   % Step 1: Build the wave
%   x = 0:.01:10;
%   y = sin(x);
%   % Compute derivative of full sine wave using 'uniform' and 'nonuniform'
%   % methods
%   [dydx1] = ComputeDerivatives(x, y, 'uniform');
%   [dydx2] = ComputeDerivatives(x, y, 'nonuniform');
% 
%   % Build the fragmented sine wave.  Take only 8% of the original wave
%   numPts = length(x);
%   iReduce = unique(randi(numPts, floor(numPts*.08), 1, 'uint32'));
%   x2 = x(iReduce);
%   y2 = y(iReduce);
%   [dydx1_b] = ComputeDerivatives(x2, y2);
%   [dydx2_b] = ComputeDerivatives(x2, y2, 'nonuniform');
% 
%   % Plot the results:
%   figure();
%   subplot(211);
%   h(1) = plot(x,y, 'b-', 'LineWidth', 1.5); hold on;
%   h(2) = plot(x2,y2, 'rx', 'LineWidth', 1.5);
%   grid on; set(gca, 'FontWeight', 'bold');
%   legend(h, {'Uninform'; 'Non-uniform'}, 'Location', 'SouthWest');
% 
%   subplot(212);
%   clear h;
%   h(1) = plot(x,dydx1, 'b-', 'LineWidth', 1.5); hold on;
%   h(2) = plot(x,dydx2, 'r-', 'LineWidth', 1.5);
%   h(3) = plot(x2,dydx1_b, 'g-', 'LineWidth', 1.5);
%   h(4) = plot(x2,dydx2_b, 'm-', 'LineWidth', 1.5);
%   lstLegend = {...
%       'Uniform Data - Uniform Filter';
%       'Uniform Data - Non-Uniform Filter';
%       'Non-Uniform Data - Uniform Filter';
%       'Non-Uniform Data - Non-Uniform Filter'};
%   legend(h, lstLegend, 'Location', 'SouthWest');
%   grid on; set(gca, 'FontWeight', 'bold');
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit ComputeDerivatives.m">ComputeDerivatives.m</a>
%	  Driver script: <a href="matlab:edit Driver_ComputeDerivatives.m">Driver_ComputeDerivatives.m</a>
%	  Documentation: <a href="matlab:pptOpen('ComputeDerivatives_Function_Documentation.pptx');">ComputeDerivatives_Function_Documentation.pptx</a>
%
% See also linspace interp1
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/303
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AerodynamicFunctions/ComputeDerivatives.m $
% $Rev: 2483 $
% $Date: 2012-09-21 15:48:20 -0500 (Fri, 21 Sep 2012) $
% $Author: sufanmi $

function [dydx] = ComputeDerivatives(x, y, strType)

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
if(nargin < 3)
    strType = '';
end

if(isempty(strType))
    strType = 'uniform';
end

%% Main Function:
ii=find(isnan(y)~=1);
nn=max(size(ii));

switch lower(strType)
    case 'uniform'
        xx=linspace(min(x(ii)),max(x(ii)),nn*20);
        yy=spline(x(ii),y(ii),xx);
        
        for jj=[2:nn*20-1]
            dyydxx(jj) = (yy(jj+1)-yy(jj-1))/(xx(jj+1)-xx(jj-1));
        end;
        
        dyydxx(1) = (yy(2)-yy(1))/(xx(2)-xx(1));
        dyydxx(nn*20) = (yy(nn*20)-yy(nn*20-1))/(xx(nn*20)-xx(nn*20-1));
        
        dydx = ones(size(y))*nan;
        dydx(ii) = interp1(xx,dyydxx,x(ii));
        
    case 'nonuniform'
        xx = x;
        yy = y;

        for jj=[2:nn-1]
            dyydxx(jj) = (yy(jj+1)-yy(jj-1))/(xx(jj+1)-xx(jj-1));
        end;
        
        dyydxx(1) = (yy(2)-yy(1))/(xx(2)-xx(1));
        dyydxx(nn) = (yy(nn)-yy(nn-1))/(xx(nn)-xx(nn-1));
        
        dydx = ones(size(y))*nan;
        dydx(ii) = interp1(xx,dyydxx,x(ii));
    
    otherwise
        dydx = [];
        errstr = [mfnam '>> ERROR: ''' strType ...
            ''' is not a defined derivative type. See ' mlink ...
            ' for help. Returning null. '];
        error([mfnam 'class:file:Identifier'], errstr);
end

return;

end % << End of function ComputeDerivatives >>

%% REVISION HISTORY
% YYMMDD INI: note
% 120921 MWS: Rolled in content of ComputeDerivatives2
% 101021 JPG: Copied over information from the old function.
% 101021 CNF: Function template created using CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ng.com    : sufanmi
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720

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
