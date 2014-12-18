% ZEROCROSS searches a 1D array for all zero crossings.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% zerocross:
% This function will inspect a 1-D array (ArrayX) looking for all the
% points where the array crosses zero (i.e. changes sign). Upon finding two
% indices where this takes place, it will linearly interpolate to find the
% corresponding values in Array Y.
%
% This is function is intended for finding trim points on a Cm vs.
% alpha curve. Therefore, it will identify crossing with a negative
% and positve slope.
%
% ArrayX and ArrayY must be 1-D arrays of the same length.
% This will not identify crossings at ArrayX(1).
% 
% SYNTAX:
%	[Y, CrossingsFound] = zerocross(ArrayX, ArrayY, DispErr, valcross)
%
% INPUTS: 
%	Name          	Size        Units           Description
%   ArrayX          [1xN]       [user defined]  Array to compare with   
%                                                ArrayY for sign chages.  
%                                                Must be the same length as
%                                                Array Y.
%   ArrayY          [1xN]       [user defined]  Array to compare with   
%                                                ArrayX for sign chages. 
%                                                Must be the same length as
%                                                Array X
%   DispErr         [1]         [boolean]       Boolean value that
%                                                determines if no-zero
%                                                crossing error displays.
%                                                0 = no display
%   valcross        [1]         [int]           Crossing value
%                                                Default: 0
%
% OUTPUTS: 
%	Name          	Size        Units           Description
%	Y   	        [Varies]    [User defined]  Values of ArrayY at the
%                                                zero crossing
%   CrossingFound   [1x1]       [ND]            Number of zero crosses 
%                                                found
%
% NOTES:
%	Y will be of dimension [Mx1] where M is the number of crossings found.
%
% EXAMPLES:
%
%   Example 1: Simple Array
%   arrX = [-1 0 1];
%   arrY = [ 1 2 3];
%   [xpts, numfound] = zerocross(arrX, arrY)
%   Results:
%   xpts = 2; numfound = 1;
%   
%   Also, this is useful for reverse 1-D interpolation
%   Example 2: Using a parabola (y = x^2), find where y crosses 4
%              By inspection, this should be at x = +2, -2
%   arrX = -5:5
%   arrY = arrX.^2
%   [xpts, numfound] = zerocross(arrY, arrX, 1, 4)
%   Results:
%   xpts = [-2; 2]; numfound = 2;
%
% SOURCE DOCUMENTATION:
%   None
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit zerocross.m">zerocross.m</a>
%	  Driver script: <a href="matlab:edit Driver_zerocross.m">Driver_zerocross.m</a>
%	  Documentation: <a href="matlab:pptOpen('zerocross_Function_Documentation.pptx');">zerocross_Function_Documentation.pptx</a>
%
% See also maxAll minAll
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/433
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/zerocross.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Y, CrossingsFound] = zerocross(ArrayX, ArrayY, DispErr, valcross)

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
% error([mfnam 'class:file:Identifier'], errstr);    % Call error function
% with error string

%% Input Arguement Conditioning
if(nargin < 4)
    valcross = 0;
end

if(nargin < 3)
    DispErr = 1;
end

% Initialize Outputs:
Y = [];

CrossingsFound = 0;

% Error check:
if (length(ArrayX) ~= length(ArrayY))
    error('Error - ArrayX and ArrayY must be 1-D arrays of the same length.');
end

%% Main Function:

ArrayX = ArrayX - valcross;

% Traverse the array:
for i = 1 : length(ArrayX)
    if (i > 1)
        if (sign(ArrayX(i)) ~= sign(ArrayX(i - 1)))
%         if (sign(ArrayX(i)) < sign(ArrayX(i - 1)))
            % Sign could potentially be different if one is zero:
            if (ArrayX(i) == 0)
                % Add this one to the list of indices which are zero:
                Y = cat(1, Y, ArrayY(i));
            elseif(ArrayX(i-1) ~= 0)
                % Interpolate between i and i-1 in Y (1-D case):
                y = - (ArrayX(i - 1) * (ArrayY(i) - ArrayY(i - 1))/...
                    (ArrayX(i) - ArrayX(i - 1))) + ArrayY(i - 1);
                Y = cat(1, Y, y);
            end
        end
    end
end

% Check 1st val
if(ArrayX(1) == 0)
    Y = cat(1, Y, ArrayY(1));
end

% Check last val
if(ArrayX(end) == 0)
    Y = cat(1, Y, ArrayY(end));
end

Y = unique(Y);
CrossingsFound = length(Y);

if(DispErr)
    if (CrossingsFound == 0)
        disp('Warning - zerocross() array does not cross zero');
    end
end

end % << End of function zerocross >>

%% REVISION HISTORY
% YYMMDD INI: note
% 111025 JPG: CoSMO'd the block
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
