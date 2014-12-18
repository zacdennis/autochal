% PLOTBOUNDS determine the bounds of data to a user defined decimation.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotBounds:
%     <Function Description> 
% 
% SYNTAX:
%   Given an array of input data to plot, determine the bounds of data to a
%   user defined decimation.  Users can specify to give maximum and
%   minimum of data rounded to the nearest multiple of a positive real
%   number.
%
% INPUTS: 
%	Name    	Size	Units           Description
%   U           [MxN]   [user defined]  Array of Input Data
%   dec         [1x1]   [user defined]  Decimation to Round Bounds To
%   boundtype   [1x1]   [ND]            Return Bounds as 1-D vector 
%                                       (setting to 0 will return bounds of 
%                                       individual columns)
%	varargin	[N/A]	[varies]        Optional function inputs that
%	     		        				should be entered in pairs.
%	     		        				See the 'VARARGIN' section
%	     		        				below for more details
%
% OUTPUTS: 
%	Name    	Size	Units           Description
%   Y          [varies] [user defined]  Plot bounds:
%                                       If boundtype = 1, size is [1x2]
%                                       If boundtype = 0 AND M > N, size is [2xN]
%                                       If boundtype = 0 AND M < N,
%                                       size is [Mx2]
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
%	[Y] = PlotBounds(U, dec, return1D, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Y] = PlotBounds(U, dec, return1D)
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
%	Source function: <a href="matlab:edit PlotBounds.m">PlotBounds.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotBounds.m">Driver_PlotBounds.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotBounds_Function_Documentation.pptx');">PlotBounds_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/495
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/PlotBounds.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Y] = PlotBounds(U, dec, return1D, varargin)

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
% Y= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        return1D= ''; dec= ''; U= ''; 
%       case 1
%        return1D= ''; dec= ''; 
%       case 2
%        return1D= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(return1D))
%		return1D = -1;
%  end
%% Main Function:

if nargin < 2
    dec = 1.0;
end

if nargin < 3
    return1D = 1;
end

%% Determine the Maximum and Minimum of the Data
if(return1D)
    for i = 1:ndims( U )
        if i == 1
            minU = min( U );
            maxU = max( U );
        else
            minU = min( minU );
            maxU = max( maxU );
        end
    end

    Y(1) = floorDec( minU, dec );
    Y(2) = ceilDec( maxU, dec );

    %% Ensure that Bounds are Unique
    %   If the data is static, the upper and lower bounds may coincide.  If
    %   this is the case, increase/decrease the upper/lower bounds by the
    %   desired decimation.
    if ( abs(Y(1) - Y(2)) <= 1e-6 )
        Y(1) = Y(1) - dec;
        Y(2) = Y(2) + dec;
    end

else
    [nrows, ncols] = size(U);
    flipped = 0;
    if(nrows < ncols)
        U = U';
        flipped = 1;
    end

    minU = min( U );
    maxU = max( U );

    for i = 1:length(minU);
        Y(i,1) = floorDec( minU(i), dec );
        Y(i,2) = ceilDec( maxU(i), dec );

        %% Ensure that Bounds are Unique
        %   If the data is static, the upper and lower bounds may coincide.  If
        %   this is the case, increase/decrease the upper/lower bounds by the
        %   desired decimation.
        if ( abs(Y(i,1) - Y(i,2)) <= 1e-6 )
            Y(i,1) = Y(i,1) - dec;
            Y(i,2) = Y(i,2) + dec;
        end
    end
    
    if(flipped == 1)
    % Flip Data Back
        Y = Y';
    end    
end

%% Compile Outputs:
%	Y= -1;

end % << End of function PlotBounds >>

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
