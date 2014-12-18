% PLOTEVENT Plots a vertical line on every subplot indicating an event.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% PlotEvent:
%  Plots a vertical line on every subplot indicating an event.  Appends
%  legend with event string.
% 
% SYNTAX:
%	[] = PlotEvent(lstfig, timeEvent, strEvent, varargin, 'PropertyName', PropertyValue)
%	[] = PlotEvent(lstfig, timeEvent, strEvent, varargin)
%	[] = PlotEvent(lstfig, timeEvent, strEvent)
%	[] = PlotEvent(lstfig, timeEvent)
%
% INPUTS: 
%	Name     	Size		Units		Description
%  lstfig       [1xN]                   List of Figures to apply event to.
%                                       Note: '-1' will apply event to all 
%                                       figures
%  timeEvent    [1]                     Time at which to plot event
%  strEvent     [string]                Legend string of event
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	    	         <size>		<units>		<Description> 
%
% NOTES:
%  This function uses the VSI_LIB functions 'getfigdata' & 'isfig'
%  See also getfigdata, isfig
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%  'LastOnly'           {0} or 1                    Add Event to Last Subplot Only
%  'FirstOnly'          {0} or 1                    Add Event to First Subplot Only
%
% EXAMPLES:
%
%   Ex1: Plots a red dashed line at x=2 with a bold legend entry 
%    'Event Start_{t=2}'
%
%   PlotEvent(1, 2, '\bfEvent Start_{t=2}', 'r--');
%
%   Ex2: Plots a blue dotted line with no legend entry at x=4 for all
%   open figures with a line width of 1.5
% 
%   PlotEvent(-1, 6, '', 'b:','LineWidth', 1.5);
%
%
%	% <Enter Description of Example #1>
%	[] = PlotEvent(lstfig, timeEvent, strEvent, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = PlotEvent(lstfig, timeEvent, strEvent)
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
%	Source function: <a href="matlab:edit PlotEvent.m">PlotEvent.m</a>
%	  Driver script: <a href="matlab:edit Driver_PlotEvent.m">Driver_PlotEvent.m</a>
%	  Documentation: <a href="matlab:pptOpen('PlotEvent_Function_Documentation.pptx');">PlotEvent_Function_Documentation.pptx</a>
%
% See also getfigdata, isfig
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/497
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PlottingUtilities/PlotEvent.m $
% $Rev: 1724 $
% $Date: 2011-05-11 18:34:55 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = PlotEvent(lstfig, timeEvent, strEvent, varargin)

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
%        strEvent= ''; timeEvent= ''; lstfig= ''; 
%       case 1
%        strEvent= ''; timeEvent= ''; 
%       case 2
%        strEvent= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(strEvent))
%		strEvent = -1;
%  end
%% Main Function:
if(nargin < 4)
    strEvent = '';
end

if(isempty(lstfig))
    lstfig = gcf;
end

if(lstfig == -1)
    lstfig = sort(allchild(0));
end

numFigs = length(lstfig);
for ifig = 1:numFigs
    curFig = lstfig(ifig);
    
    flgRealFigure = isfig(curFig);
    if(flgRealFigure)
        figData = getfigdata(curFig);
        
        numSubplots = size(figData,2);
        arrSubplots = [1:numSubplots];
        
        [flgLastOnly, varargin] = format_varargin('LastOnly', 0, 2, varargin);
        if(flgLastOnly)
            arrSubplots = [numSubplots];
        end
        
        [flgFirstOnly, varargin] = format_varargin('FirstOnly', 0, 2, varargin);
        if(flgFirstOnly)
            arrSubplots = [1];
        end
        
        for isubplot = arrSubplots
            
            hdl = figData(isubplot).handle;
            legend_info = figData(isubplot).legend_info;
            
            xlimits = get(hdl, 'XLim');
            ylimits = get(hdl, 'YLim');
            
            figure(curFig);
            subplot(hdl);
            hold on;
            
            xb = [timeEvent timeEvent];
            yb = ylimits;
            
            clear lh h_new strLegend;
            lh = plot(xb, yb, varargin{:});
            
            
            if(isempty(legend_info.String))
                % No Legend:
                
                if(~isempty(strEvent))
                    % Event String Exists:
                    legend(lh, strEvent);
                end
                
            else
                
                % Legend Exists, Add to it:
                if(~isempty(strEvent))
                    strLegend = legend_info.String;
                    
                    numLines = size(legend_info.String, 1);
                    h_new = legend_info.hdl;
                    h_new(numLines+1) = lh;
                    
                    strLegend{numLines+1,:} = strEvent;
                    
                    legend(h_new, strLegend, ...
                        'Location', legend_info.Location, ...
                        'Interpreter', legend_info.Interpreter);
                end
            end
            
            xlim(xlimits);
            ylim(ylimits);
        end
    end
end


%% Compile Outputs:
%	= -1;

end % << End of function PlotEvent >>

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
