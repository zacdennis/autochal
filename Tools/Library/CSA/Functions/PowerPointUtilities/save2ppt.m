% SAVE2PPT Saves Plots to Microsoft Powerpoint.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% save2ppt:
%   Saves Plots to Microsoft Powerpoint.  Figures are adjusted and placed
%   for best use with Northrop Grumman's Powerpoint template.
% 
% SYNTAX:
%	save2ppt(filespec, fig_ids, titletext, flgDisableResize, flgClosePPT, strTemplate, slide_number_to_add)
%	save2ppt(filespec, fig_ids, titletext, flgDisableResize, flgClosePPT, strTemplate)
%	save2ppt(filespec, fig_ids, titletext, flgDisableResize, flgClosePPT)
%   save2ppt(filespec, fig_ids, titletext, flgDisableResize)
%   save2ppt(filespec, fig_ids, titletext)
%   save2ppt(filespec, fig_ids)
%   save2ppt(filespec)
%   save2ppt()
%
% INPUTS: 
%	Name        Size            Units		Description
%   filespec    'string'        [char]      Powerpoint Presentation to 
%                                           add figure to.  If undefined, 
%                                           propts user for valid filename.
%   fig_ids     [1] or [2]      [int]       Figure number(s) to save.  If 
%                                           one figure is specified, the 
%                                           figure is centered.  If two
%                                           figures are specified, the 
%                                           figures are scaled to fit a  
%                                           side-by-side [1x2] arrangement.
%                                           If undefined, uses the current 
%                                           figure (gcf).
%  titletext    'string'        [char]      Optional title to add to 
%                                           Powerpoint chart.
%  flgDisableResize [1]         [bool]      Allow function to scale figures
%                                           to fit within plot box?
%                                           Default: 0 (Allow Resize)
%  flgClosePPT      [1]         [bool]      Close PowerPoint after saving 
%                                           figure?  Batch scripts calling
%                                           this function often should set
%                                           to true to avoid multiple open
%                                           PPTs
%  strTemplate  'string'        [char]      Filename of PPT template to use
%                                           Default: 'NGCTemplate.pptx'
%  slide_number_to_add [1]      [int]       Slide number to insert
%                                           Default: Add new slide to end
%                                                    of presentation
%                                           See Trick #2 for more info.
%
% OUTPUTS: 
%	Name         	Size		Units		Description
%   None
%
% NOTES:
%	COOL TRICKS
%   Trick #1:
%   If you are adding just one figure to powerpoint but you don't want it
%   centered, you can set the figure to the left or the right position by
%   specifying the fig_id to be either:
%    For left position: [gcf 0]
%    For right position: [0 gcf]
%
%   Trick #2:
%   If you are using a PowerPoint template which has trailing slides, you
%   can specify a negative 'slide_number_to_add'.  When adding a new slide,
%   this function will first go to the end of the presentation and count
%   backwards the user specified number of slides.  For example, if the
%   current presentation has 10 slides and 'slide_number_to_add' is -1,
%   this will place the new slide one slide in front of the very last slide
%   in the presentation.
%
% EXAMPLES:
%   % Example #1: Show save2ppt in action:
%   % Create a few figures to save to PowerPoint:
%   t = 0:0.01:10;
%   y = sin(t);
%   t2 = 0:.1:10;
%   y2 = cos(t2);
% 
%   clear ts;
%   ts = timeseries(y', t');
%   ts.Name = 'ElevatorPos';
%   ts.DataInfo.Units = '[deg]';
%   SampleResults.Elevator = ts;
% 
%   ts2 = timeseries(y2', t2');
%   ts2.Name = 'RudderPos';
%   ts2.DataInfo.Units = '[deg]';
%   SampleResults.Rudder = ts2;
% 
%   ts3 = timeseries([y' -2*y' -3*y'], t');
%   ts3.Name = 'PQRb';
%   ts3.DataInfo.Units = '[deg/sec]';
%   SampleResults.PQRb = ts3;
%
%   % Now Create Figure #1:
%   close all;  % Housekeeping
%   figure();
%   h(1) = plotts(SampleResults.Elevator);
%   hold on;
%   h(2) = plotts(SampleResults.Rudder);
%   legend(h, {'Elevator (100 Hz)';'Rudder (50 Hz)'});
%
%   % Now Create Figure #2:
%   figure();
%   plotts(SampleResults.PQRb);
%
%   % Now Let's Save the figures to File in various formats:
%   %% Method 1: Save the active figure (in this case #2) to file
%   %            'junk.pptx'
%   filename = 'junk.pptx';
%   save2ppt(filename)
%
%   %% Method 2: Explicitly save figure #1 to the file and give it a title
%   %            string of 'Testing Save of just 1 figure'
%   save2ppt(filename,[1], 'Testing Save of just 1 figure')
%
%   %% Method 3: Save Figure #1 & #2 to the same slide in a side-by-side
%   %            arrangement
%   save2ppt(filename, [1 2], 'Testing Save of 2 figures')
%
%   %% Method 4: Save an Oversized Figure #1 to PowerPoint allowing resizing
%   set(1, 'Position', [1000         360        1224        1138]);
%   save2ppt(filename,[1], 'Oversized Testing: This should scale to fit')
%
%   %% Method 5: Save an Oversized Figure #1 to PowerPoint and disable resizing
%   set(1, 'Position', [1000         360        1224        1138]);
%   save2ppt(filename,[1], 'Oversized Testing: This should be larger than slide', 1)
%
%   %% Method 6: Save a single figure off twice in a 1x2 arrangement, first
%   %            leaving the left side blank (e.g. right justify) and then
%   %            leaving the right side blank (e.g. left justify)
%   save2ppt(filename, [0 2], 'Right Justify')
%   save2ppt(filename, [2 0], 'Left Justify')
%
% SOURCE DOCUMENTATION:
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit save2ppt.m">save2ppt.m</a>
%	  Driver script: <a href="matlab:edit Driver_save2ppt.m">Driver_save2ppt.m</a>
%	  Documentation: <a href="matlab:pptOpen('save2ppt_Function_Documentation.pptx');">save2ppt_Function_Documentation.pptx</a>
%
% See also SaveOpenFigures2PPT 
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/505
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://trac.ngst.northgrum.com/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/save2ppt.m $
% $Rev: 2472 $
% $Date: 2012-09-05 18:44:04 -0500 (Wed, 05 Sep 2012) $
% $Author: sufanmi $

function [] = save2ppt(filespec, fig_ids, titletext, flgDisableResize, flgClosePPT, strTemplate, slide_number_to_add)

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

%% Input Argument Conditioning:
if nargin<1 | isempty(filespec);
    [fname, fpath] = uiputfile({'*.ppt;*.pptx'});
    if fpath == 0; return; end
    filespec = fullfile(fpath,fname);
else
    [fpath,fname,fext] = fileparts(filespec);
    if isempty(fpath); fpath = pwd; end
    if isempty(fext); fext = '.ppt'; end
    filespec = fullfile(fpath,[fname,fext]);
end

if( (nargin < 2) | isempty(fig_ids))
    fig_ids = gcf;
end

if( (nargin < 3) | isempty(titletext))
    titletext = '';
end

if( (nargin < 4) | isempty(flgDisableResize) )
    flgDisableResize = 0;
end

if( (nargin < 5) | isempty(flgClosePPT) )
    flgClosePPT = 0;
end

if( (nargin < 6) | isempty(strTemplate) )
    strTemplate = 'NGCTemplate.pptx';
end

if( (nargin < 7) )
    slide_number_to_add = [];
end

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
    
    copyfile(which(strTemplate), filespec);
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

if(isempty(slide_number_to_add))
    slide_number_to_add = slide_count + 1;
end

slide_number_to_add = round(slide_number_to_add);

if(slide_number_to_add < 0)
    slide_number_to_add = slide_count + 1 + slide_number_to_add;
end
slide_number_to_add = max(slide_number_to_add, 1);
slide_number_to_add = min(slide_number_to_add, slide_count + 1);
new_slide = invoke(op.Slides, 'Add', slide_number_to_add, 11);

if(ischar(titletext))
    titletext = { titletext };
end

set(new_slide.Shapes.Title.TextFrame.TextRange,'Text', cell2str(titletext, char(13)));

% Get height and width of slide:
slide_H = op.PageSetup.SlideHeight;
slide_W = op.PageSetup.SlideWidth;

% Add the figures:
numFigs = length(fig_ids);

for iFig = 1:numFigs
    curFig = fig_ids(iFig);

    if(curFig > 0)
        figure(curFig);

        % Capture current figure/model into clipboard:
        eval(sprintf('print -dmeta -f%d', curFig));

        % Paste the contents of the Clipboard:
        pic1 = invoke(new_slide.Shapes,'Paste');

        % Get height and width of picture:
        pic_H = get(pic1,'Height');
        pic_W = get(pic1,'Width');

        inch2pixel = 72;

        switch numFigs
            case 1
                % Place as Standalone
                max_pic_h = 5.4 * inch2pixel;
                max_pic_w = 9.4 * inch2pixel;
        
                pic_center_l = 5.0 * inch2pixel;
                pic_center_t = 4.4 * inch2pixel;

            case 2
                
                % Place as Standalone
                max_pic_h = 5.4 * inch2pixel;
                max_pic_w = 4.7 * inch2pixel;
                
                if(iFig == 1) 
                    pic_center_l = 2.65 * inch2pixel;
                    pic_center_t = 4.4 * inch2pixel;
                else
                    pic_center_l = 7.35 * inch2pixel;
                    pic_center_t = 4.4 * inch2pixel;
                end

            otherwise
        end

        if(~flgDisableResize)
            hScale = max_pic_h / pic_H;
            wScale = max_pic_w / pic_W;
            
            if(hScale <= wScale)
                pic_scale = hScale;
            else
                pic_scale = wScale;
            end
            
            pic_H = pic_H * pic_scale;
            pic_W = pic_W * pic_scale;
            
            set(pic1,'Height', pic_H);
            set(pic1,'Width', pic_W);
        end
        
        set(pic1, 'Left', pic_center_l - pic_W/2);
        set(pic1, 'Top', pic_center_t - pic_H/2);

    end
end

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
if(~flgClosePPT)
    invoke(ppt, 'Activate');
    invoke(ppt.Presentations, 'Open', filespec);
    last_slide = invoke(ppt.ActivePresentation.Slides, 'Item', slide_number_to_add);
    invoke(last_slide, 'Select');
end

end % << End of function save2ppt >>

%% REVISION HISTORY
% YYMMDD INI: note
% 110525 MWS: Overhauled internal code responsible for resizing the images.
%             Now an image box is used to scale the figures up or down to
%             fix (if desired, assuming flgDisableResize == 0).  Removed
%             ability use a larger box size for slides without the bottom
%             disclaimer line (e.g. Private/Proprietary)
% 101026 JPG: Copied over information from the old function.
% 101026 CNF: Function template created using CreateNewFunc
% 050101 MWB: Based on the MATLAB file exchange function SAVEPPT
%               (Copyright 2005 MWB)
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username
% MWS: Mike Sufana          : mike.sufana@ngc.com   : sufanmi
% JPG: James Patrick Gray   : james.gray2@ngc.com   : g61720 
% MWB: Mark W. Brown        : mwbrown@ieee.org

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
