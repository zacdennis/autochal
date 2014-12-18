% SCALEFIGURE scales a figure by a desired factor
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ScaleFigure:
%     <Function Description> 
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "scale" is a
% * function name!
% * -JPG
% ************************************************************************* 
% SYNTAX:
%	[hout] = ScaleFigure(scale, h)
%	[hout] = ScaleFigure(scale)
%
% INPUTS: 
%	Name    	Size	Units	Description
%   scale       [1]     [%]     Desired zoom level
%   h           [n]     [N/A]   Figure handle (uses 'gcf' if not specified)
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	hout	    <size>		<units>		<Description> 
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
% EXAMPLE
%   Enlarge current image by 10% (e.g. scale to 110%)
%       ScaleFigure(110);
%
%	% <Enter Description of Example #1>
%	[hout] = ScaleFigure(scale, h, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[hout] = ScaleFigure(scale, h)
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
%	Source function: <a href="matlab:edit ScaleFigure.m">ScaleFigure.m</a>
%	  Driver script: <a href="matlab:edit Driver_ScaleFigure.m">Driver_ScaleFigure.m</a>
%	  Documentation: <a href="matlab:pptOpen('ScaleFigure_Function_Documentation.pptx');">ScaleFigure_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/509
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/ScaleFigure.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [hout] = ScaleFigure(scale, h, varargin)

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
% hout= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        h= ''; scale= ''; 
%       case 1
%        h= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(h))
%		h = -1;
%  end
%% Main Function:
if(nargin < 2)
    h = gcf;
end

numFigs = length(h);

for iFig = 1:numFigs
    curFig = h(iFig);
    
    ratio = scale / 100;
    
    pos = get(curFig, 'Position');
    
    newx = (ratio - 1) * pos(3);
    newy = (ratio - 1) * pos(4);
    
    pos(1) = pos(1) - newx/2;
    pos(2) = pos(2) - newy/2;
    
    pos(3) = pos(3) * ratio;
    pos(4) = pos(4) * ratio;
    set(curFig, 'Position', pos);
    
end

%% Compile Outputs:
%	hout= -1;

end % << End of function ScaleFigure >>

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
