% BLANK_LEGEND Generates a Blank Figure with a specified legend in it
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% blank_legend:
%     Generates a Blank Figure with a specified legend in it
% *************************************************************************
% * #NOTE: To future COSMO'er, the following warning occured when running
% * CreateNewFunc.
% * CreateNewFunc>>WARNING: Selected Input argument name: "location" is a
% * function name!
% * -JPG
% *************************************************************************
% 
% SYNTAX:
%	[h] = blank_legend(legend_info, fontsize, location)
%	[h] = blank_legend(legend_info, fontsize)
%	[h] = blank_legend(legend_info)
%
% INPUTS: 
%	Name       	Size		Units		Description
%   legend_info {cell}
%   legend_info{:,1}:                   Legend String
%   legend_info{:,2}:                   Line Color
%   legend_info{:,3}:                   Line Marker
%   legend_info{:,4}:                   Marker Size
%                                       Optional: Default is 1,
%                                       e.g. no marker
%   legend_info{:,5}:                   Line Width
%                                       Optional: Default is 1
%   legend_info{:,6}:                   Line Style
%                                       Optional: Default solid line ('-')
%	fontsize	   <size>		<units>		<Description>
%	location	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	h   	          <size>		<units>		<Description> 
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
%   legend_info = {...
%     'January'     'r'    'x'    [1.00]    [1.00];
%     'February'    'g'    'o'    [1.00]    [1.00];
%     'March'       'b'    'v'    [1.00]    [1.00] };
%   blank_legend( legend_info )
%
%	% <Enter Description of Example #1>
%	[h] = blank_legend(legend_info, fontsize, location, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[h] = blank_legend(legend_info, fontsize, location)
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
%	Source function: <a href="matlab:edit blank_legend.m">blank_legend.m</a>
%	  Driver script: <a href="matlab:edit Driver_blank_legend.m">Driver_blank_legend.m</a>
%	  Documentation: <a href="matlab:pptOpen('blank_legend_Function_Documentation.pptx');">blank_legend_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/475
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/blank_legend.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [h] = blank_legend(legend_info, fontsize, location, varargin)

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
% h= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        location= ''; fontsize= ''; legend_info= ''; 
%       case 1
%        location= ''; fontsize= ''; 
%       case 2
%        location= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(location))
%		location = -1;
%  end
%% Main Function:
if(nargin < 3)
    location = 'NorthWest';
end

if(nargin < 2)
    fontsize = 12;
end
    
if(nargin < 1)
    legend_info = evalin('base', 'legend_info');
end

numLines = size(legend_info, 1);
numCols = size(legend_info, 2);

% figure()

for iLine = 1:numLines
    cur_legend  = legend_info{iLine, 1};
    cur_color   = legend_info{iLine, 2};
    cur_marker  = legend_info{iLine, 3};

    % Marker Size:
    if(numCols > 3)
        cur_ms      = legend_info{iLine, 4};
    else
        cur_ms = [];
    end
    
    if(isempty(cur_ms))
        cur_ms = 1;
    end
    
    % Line Width:
    if(numCols > 4)
        cur_lw = legend_info{iLine, 5};
    else
        cur_lw = [];
    end
    
    if(isempty(cur_lw))
        cur_lw = 1;
    end
    
    % Line Style:
    
    if(numCols > 5)
        cur_ls = legend_info{iLine, 6};
    else
        cur_ls = '';
    end
    
    if(isempty(cur_ls))
        cur_ls = '-';
    end
    
    % Build Legend:
    arr_legend{iLine, 1} = cur_legend;
    
    h(iLine) = plotd([0 0.01]', [0 0]', [], ...
        'Color', cur_color, 'Marker', cur_marker, 'MarkerSize', cur_ms, ...
        'LineStyle', cur_ls, 'LineWidth', cur_lw*1.5);
end

axis off;
xlim([1 2]);
legend(h, arr_legend, 'FontWeight', 'bold', 'FontSize', fontsize, ...
    'Location', location)

%% Compile Outputs:
%	h= -1;

end % << End of function blank_legend >>

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
