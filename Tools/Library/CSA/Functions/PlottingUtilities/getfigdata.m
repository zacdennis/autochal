% GETFIGDATA Retrieved figure data from a MATLAB .fig file
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% getfigdata:
%     Retrieved figure data from a MATLAB .fig file
% 
% SYNTAX:
%	[figData] = getfigdata(fignum)
%	[figData] = getfigdata()
%
% INPUTS: 
%	Name    	Size		Units		Description
%   fignum      [1]                     Figure Handle (uses current figure 
%                                        if not provided)
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%   figData     {cell}                  Figure Information broken down by 
%                                        subplot 
%
% NOTES:
%	This function uses the VSI_LIB function 'cell2str'
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%  t = 0:0.01:10;  y = sin(t); y2 = cos(t);
%
%  figure(1)
%  subplot(211);
%  h1(1) = plot(t,y,'b'); hold on;
%  h1(2) = plot(t,y2,'r:');
%  legend(h1, {'y'; 'y2'});
%  xlabel('211');
%  ylabel('Y Label [units]');
%  title('Title String');
%
%  subplot(212);
%  h2 = plot(t,y2+y,'c--');
%  legend(h2, 'y2+y');
%  xlabel('212');
%  ylabel('Y Label [units]');
%
%  figData = getfigdata(1)
%
% RETURNS....
%
% figData =
% 1x2 struct array with fields:
%     handle
%     hdl
%     xlabel
%     ylabel
%     title
%     line
%
% figData(1)
%     handle: 5.0881e+004
%        hdl: [2 1 1]
%     xlabel: '211'
%     ylabel: 'Y Label [units]'
%      title: 'Title String'
%       line: [1x2 struct]
%
% figData(1).line(1)
%        handle: 5.0887e+004
%        legend: 'y'
%             x: [1x1001 double]
%             y: [1x1001 double]
%     colorname: 'blue'
%     LineStyle: '-'
%        Marker: 'none'
%      LineWidth: 0.5000
%         Marker: 'none'
%     MarkerSize: 6
%
% figData(1).line(2)
%        handle: 5.0888e+004
%        legend: 'y2'
%             x: [1x1001 double]
%             y: [1x1001 double]
%     colorname: 'red'
%     LineStyle: ':'
%        Marker: 'none'
%      LineWidth: 0.5000
%         Marker: 'none'
%     MarkerSize: 6
%
%	% <Enter Description of Example #1>
%	[figData] = getfigdata(fignum, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[figData] = getfigdata(fignum)
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
%	Source function: <a href="matlab:edit getfigdata.m">getfigdata.m</a>
%	  Driver script: <a href="matlab:edit Driver_getfigdata.m">Driver_getfigdata.m</a>
%	  Documentation: <a href="matlab:pptOpen('getfigdata_Function_Documentation.pptx');">getfigdata_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/488
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/getfigdata.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [figData] = getfigdata(fignum, varargin)

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
% figData= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        fignum= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
if nargin < 1
    fignum = gcf;
end

%% Retrieve Subplot Information:
ctr_line = 0;
ctr_legend = 0;

% Legend Default:
legend_info.String      = {};
legend_info.hdl         = [];
legend_info.Location    = 'NorthEast';
legend_info.Visible     = 'off';
legend_info.Interpreter = 'txt';
default_legend = legend_info; clear legend_info;

% Loop Through Each Figure Child:
figChildren = get(fignum,'Children');
for figChild = figChildren'
    child_info = get(figChild);
    
    % Determine if Child is a Legend:
    if(isfield(child_info, 'String'))
        
        % It's a legend, record it:
        leg_mem = {};
        ileg = 0;
        for hdl_leg_child = child_info.Children'
            leg_child = get(hdl_leg_child);
            if(~isempty(leg_child.Tag))
                ileg = ileg + 1;
                leg_mem{ileg,1} = leg_child.Tag;
                leg_mem_hdl(ileg) = hdl_leg_child;
            end
        end
        
        clear legend_info;
        legend_info.String      = flipud(leg_mem);
        legend_info.hdl         = fliplr(leg_mem_hdl);
        legend_info.Location    = child_info.Location;
        legend_info.Visible     = child_info.Visible;
        legend_info.Interpreter = child_info.Interpreter;
        
        ctr_legend = ctr_legend + 1;
        lstLegend(ctr_legend) = legend_info;
        
    else
        
        % Get all the lines on the axis:
        dataline = findobj(figChild,'Type','line');
        
        for j = dataline'
            ctr_line = ctr_line + 1;
            hdl_subplot = get(j, 'Parent');
            subplot_pos = get(hdl_subplot, 'Position');
            matPos(ctr_line,:) = subplot_pos;
            
            arrSubplots(ctr_line) = hdl_subplot;
        end
    end
end

[lstSubplotPos, ptrSubplots] = unique(matPos, 'rows');
hdl_subplots = arrSubplots(ptrSubplots);

arrX = unique(lstSubplotPos(:,1));
arrY = flipud(unique(lstSubplotPos(:,2)));

numCol = length(arrX);
numRow = length(arrY);
numSubplots = length(hdl_subplots);

idxMatrix = reshape([1:numSubplots], numCol, numRow)';

for iSubplot = 1:numSubplots
    hdl_subplot = hdl_subplots(iSubplot);
    
    figinfo = get(hdl_subplot);
    ptrX = find(arrX == figinfo.Position(1));
    ptrY = find(arrY == figinfo.Position(2));
    idx = idxMatrix(ptrY, ptrX);
    
    clear subplotinfo;
    subplotinfo.handle = hdl_subplot;
    subplotinfo.hdl    = [numRow numCol idx];
    subplotinfo.xlabel = get(figinfo.XLabel, 'String');
    subplotinfo.ylabel = get(figinfo.YLabel, 'String');
    subplotinfo.title  = get(figinfo.Title, 'String');
    subplotinfo.legend_info = default_legend;
    
    hdl_children = sort(figinfo.Children);
    num_children = length(hdl_children);
    
    strLegend = {''};
    arrHandles = [];
    
    % Loop Through Each Subplot Line:
    i_legend = 0;
    i_child = 0;
    for i_child_raw = 1:num_children
        hdl_line = hdl_children(i_child_raw);
        
        line_data = get(hdl_line);
        
        if(isfield(line_data, 'XData'))
            i_child = i_child + 1;
            
            ld.handle   = hdl_line;
            ld.legend   = line_data.DisplayName;
            
            if(~isempty(ld.legend))
                i_legend = i_legend + 1;
                strLegend{i_legend,:} = line_data.DisplayName;
                arrHandles(i_legend) = hdl_line;
            end
            
            ld.x        = line_data.XData;
            ld.y        = line_data.YData;
            
            colordata   = num2str(line_data.Color);
            if ~isnumeric(Mgetcolorname(colordata))
                ld.colorname = Mgetcolorname(colordata);
            else
                ld.Color = line_data.Color;
            end
            
            ld.LineStyle    = line_data.LineStyle;
            ld.LineWidth    = line_data.LineWidth;
            ld.Marker       = line_data.Marker;
            ld.MarkerSize   = line_data.MarkerSize;
            
            subplotinfo.line(i_child) = ld;
        end
    end
    
    % Now go back and find the associated legend:
    if(isempty(cell2str(strLegend)))
        
        % Create legend info if none exists:
        subplotinfo.legend_info         = default_legend;
        
    else
        
        numLegends = size(lstLegend,2);
        for iLegend = 1:numLegends
            legend_info = lstLegend(iLegend);
            refLegend = cell2str(strLegend);
            posMatch = cell2str(legend_info.String);
            
            if(strmatch(refLegend, posMatch))
                subplotinfo.legend_info = legend_info;
                break;
            end
        end
        
        subplotinfo.legend_info.hdl = arrHandles;
        
    end
    
    figData(idx) = subplotinfo;
    
end

end

function lname = Mgetcolorname(ctriple)
% Mgetcolor returns the long name for the common MATLAB colors.
% LNAME = MGETCOLORNAME(CTRIPLE)

namearray = {
    '1  1  0','y';
    '1  0  1','m';
    '0  1  1','c';
    '1  0  0','r';
    '0  1  0','g';
    '0  0  1','b';
    '1  1  1','w';
    '0  0  0','k';
    };

lname = 0;
for i = 1:length(namearray)
    if strcmp(ctriple,namearray{i,1})
        lname = namearray{i,2};
    end
end


%% Compile Outputs:
%	figData= -1;

end % << End of function getfigdata >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 081217 MAH: Modified 'getfigdata' by MAH from MATLAB file exchange
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 
% MAH: M.A. Hopcroft

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
