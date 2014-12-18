% FIXAXIS Adds commas to user designated axis on a plot. 
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% FixAxis:
%     Adds commas to user designated axis on a plot. 
% 
% SYNTAX:
%	[] = FixAxis(strAxis, flgAddCommas, varargin, 'PropertyName', PropertyValue)
%	[] = FixAxis(strAxis, flgAddCommas, varargin)
%	[] = FixAxis(strAxis, flgAddCommas)
%	[] = FixAxis(strAxis)
%
% INPUTS: 
%	Name        	Size	Units	Description
%   strAxis         [1x1]   [ND]    Axis to add commas to: ‘x’, ‘y’, or ‘z’
%   flgAddCommas    [1x1]   [ND]    Flag (1) to add commas
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	    	            <size>		<units>		<Description> 
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
%	[] = FixAxis(strAxis, flgAddCommas, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = FixAxis(strAxis, flgAddCommas)
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
%	Source function: <a href="matlab:edit FixAxis.m">FixAxis.m</a>
%	  Driver script: <a href="matlab:edit Driver_FixAxis.m">Driver_FixAxis.m</a>
%	  Documentation: <a href="matlab:pptOpen('FixAxis_Function_Documentation.pptx');">FixAxis_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/486
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/FixAxis.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = FixAxis(strAxis, flgAddCommas, varargin)

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
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        flgAddCommas= ''; strAxis= ''; 
%       case 1
%        flgAddCommas= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(flgAddCommas))
%		flgAddCommas = -1;
%  end
%% Main Function:
if(nargin < 2)
    flgAddCommas = 0;
end

str = lower(strAxis);

if( (~isempty(strfind(str, 'x'))) || strcmp(str, 'all') )
    % Clean the X axis:
    xticks = get(gca, 'XTick');
    xticksnew = vec2cell(xticks);
    xticksnew = AddCommasToCell(xticksnew, flgAddCommas);
    set(gca, 'XTickLabel', xticksnew);
end

if( (~isempty(strfind(str, 'y'))) || strcmp(str, 'all') )
    % Clean the Y axis:
    yticks = get(gca, 'YTick');
    yticksnew = vec2cell(yticks);
    yticksnew = AddCommasToCell(yticksnew, flgAddCommas);
    set(gca, 'YTickLabel', yticksnew);
end

if( (~isempty(strfind(str, 'z'))) || strcmp(str, 'all') )
    % Clean the Z axis:
    zticks = get(gca, 'ZTick');
    zticksnew = vec2cell(zticks);
    zticksnew = AddCommasToCell(zticksnew, flgAddCommas);
    set(gca, 'ZTickLabel', zticksnew);
end
end

function arrticksnew = AddCommasToCell(arrticks, flgAddCommas)

if(flgAddCommas)

    numticks = size(arrticks, 1);
    for itick = 1:numticks
        curtick = arrticks{itick};
        newtick = AddComma(curtick);
        arrticksnew{itick,:} = newtick;
    end

else
    arrticksnew = arrticks;
end


%% Compile Outputs:
%	= -1;

end % << End of function FixAxis >>

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
