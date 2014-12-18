% PPTADDSLIDE saves plots to Microsoft Powerpoint.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% pptAddSlide:
%   Saves Plots to Microsoft Powerpoint.  Figures are adjusted and placed
%   for best use with Northrop Grumman's Powerpoint template.
% 
% SYNTAX:
%	[] = pptAddSlide(filespec, titletext, varargin, 'PropertyName', PropertyValue)
%	[] = pptAddSlide(filespec, titletext, varargin)
%	[] = pptAddSlide(filespec, titletext)
%	[] = pptAddSlide(filespec)
%
% INPUTS: 
%	Name     	Size		Units		Description
%   filespec    [string]    Powerpoint Presentation to add figure to.
%                           If undefined, propts user for valid filename.
%   fig_ids     [1] or [2]  Figure number(s) to save.  If one figure is
%                           specified, the figure is centered.  If two
%                           figures are specified, the figures are shrunk
%                           down and arranged side-by-side [1x2].  If
%                           undefined, uses the current figure (gcf).
%  titletext    [string]    Optional title to add to Powerpoint chart.
%  flgDisclaimer [bool]     Allow room for disclaimer at bottom of slide?
%                            Only used for single plots; Default is 0
%  flgBatch      [bool]     Allows user to close PPT (for batch mode to
%                            avoid multiple open PPTs)
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
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%
%   save2ppt
%       Prompts user for valid filename and saves current figure
%   save2ppt('junk.ppt')
%       Saves current figure to PowerPoint file called junk.ppt
%   save2ppt('junk.ppt',[1 2], 'Testing')
%       Saves figures #1 & #2 to 'junk.ppt' in a side-by-side arrangement
%
%	% <Enter Description of Example #1>
%	[] = pptAddSlide(filespec, titletext, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[] = pptAddSlide(filespec, titletext)
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
%	Source function: <a href="matlab:edit pptAddSlide.m">pptAddSlide.m</a>
%	  Driver script: <a href="matlab:edit Driver_pptAddSlide.m">Driver_pptAddSlide.m</a>
%	  Documentation: <a href="matlab:pptOpen('pptAddSlide_Function_Documentation.pptx');">pptAddSlide_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/679
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/pptAddSlide.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [] = pptAddSlide(filespec, titletext, varargin)

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
%        titletext= ''; filespec= ''; 
%       case 1
%        titletext= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(titletext))
%		titletext = -1;
%  end
%% Main Function:
%% Check Inputs:
if nargin<1 | isempty(filespec);
    [fname, fpath] = uiputfile('*.pptx');
    if fpath == 0; return; end
    filespec = fullfile(fpath,fname);
else
    [fpath,fname,fext] = fileparts(filespec);
    if isempty(fpath); fpath = pwd; end
    if isempty(fext); fext = '.pptx'; end
    filespec = fullfile(fpath,[fname,fext]);
end

% if( (nargin < 2) | isempty(fig_ids))
%     fig_ids = gcf;
% end

if( (nargin < 2) | isempty(titletext))
    titletext = '';
end

% if( (nargin < 4) | isempty(flgDisclaimer) )
    flgDisclaimer = 0;
% end

% if( (nargin < 5) | isempty(flgBatch) )
    flgBatch = 0;
% end
%% Start an ActiveX session with PowerPoint:
ppt = actxserver('PowerPoint.Application');

% Check to see if the Presentation is already open:
numOpenPPTs = ppt.Presentations.Count;
for iOpenPPT = 1:numOpenPPTs
    try
        curPPT = invoke(ppt.Windows, 'Item', iOpenPPT);

        if( strcmp(curPPT.Presentation.FullName, filespec) )
            % Presentation is currently open.  Save and close it.
            invoke(curPPT.Presentation, 'Save');
            invoke(curPPT.Presentation, 'Close');
            break;
        end
    catch
    end
end

%% Open/Create the Presentation:
if ~exist(filespec, 'file')
    filedir = fileparts(filespec);
    if(~isdir(filedir))
        mkdir(filedir);
    end
    
    copyfile(which('NGCTemplate.pptx'), filespec);
end

% if ~exist(filespec,'file');
%     % Create new presentation:
%
%     op = invoke(ppt.Presentations,'Add');
% else
% Open existing presentation:
op = invoke(ppt.Presentations,'Open',filespec,[],[],0);
% end

% Add a new slide (with title object):
slide_count = get(op.Slides,'Count');
new_slide = invoke(op.Slides, 'Add', slide_count + 1, 11);
set(new_slide.Shapes.Title.TextFrame.TextRange,'Text', sprintf(cell2str(titletext, '\r\n')));

% Get height and width of slide:
slide_H = op.PageSetup.SlideHeight;
slide_W = op.PageSetup.SlideWidth;

%% Save the Presentation:
if ~exist(filespec,'file')
    % Save file as new:
    invoke(op,'SaveAs',filespec,1);
else
    % Save existing file:
    invoke(op,'Save');
end
invoke(op,'Close');

%% Open the Powerpoint Presentation and Make the Last Slide Active:
if(~flgBatch)
    invoke(ppt, 'Activate');
    invoke(ppt.Presentations, 'Open', filespec);
    last_slide = invoke(ppt.ActivePresentation.Slides, 'Item', (slide_count + 1));
    invoke(last_slide, 'Select');
end

%% Compile Outputs:
%	= -1;

end % << End of function pptAddSlide >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 050101 MWB: Based on the MATLAB File Exchange function SAVEPPT
%             (Copyright 2005 MWB)
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720 
% MWB: Mark W. Brown        :  mwbrown@ieee.org     

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
