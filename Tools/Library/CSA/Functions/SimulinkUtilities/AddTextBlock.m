% ADDTEXTBLOCK Adds a text block to a subsystem
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AddTextBlock:
%     Adds a Text Block to a Simulink subsystem with plugs for modifying
%     the block's font, font size, font weight, location, click function
%     callback, and content
%
% SYNTAX:
%	[text_pos_NW, text_pos_SW] = AddTextBlock(BlockPath, TextToAdd, 'PropertyName', PropertyValue)
%	[text_pos_NW, text_pos_SW] = AddTextBlock(BlockPath, TextToAdd, varargin)
%	[text_pos_NW, text_pos_SW] = AddTextBlock(BlockPath, TextToAdd)
%	[text_pos_NW, text_pos_SW] = AddTextBlock(BlockPath)
%
% INPUTS:
%	Name            Size        Units	Description
%	 BlockPath      [string]	N/A     Full Path to Block
%	 TextToAdd      [string]    N/A     Text to Add to Text Block
%                                        Default: TortoiseSVN keywords for
%                                        URL, Rev, Date, and Author
%    varargin       N/A         N/A     Coupled Inputs with additional
%                                        text properties that can be
%                                        specified in any order
%       Property Name       Property Values
%       'Font'              'string'    Name of Font to Use (e.g. 'Arial')
%                                        Default: MATLAB's default
%       'FontSize'          [int]       Font Size (e.g. 10 or 14)
%                                        Default: MATLAB's default
%       'FontWeight'        'string'    Type of formatting, either:
%                                        'regular', 'bold', 'italic', or
%                                        'bolditalic'
%                                        Default: MATLAB's default
%       'Location'          [left top]  Upper left corner of text box in pixels
%                                         Default: [50 10]
%       'ClickFcn'          'string'    If provided, this is what will be
%                                        executed when text is clicked on
%                                        Default: '' (none)
%       'OpenBlock'         [bool]      Open Block after Addition?
%                                        Default: 'true'
%
% OUTPUTS:
%  Name             Size        Units	Description None
%  text_pos_NW      [left top]  pixels  Upper left location of text block
%  text_pos_SW      [left top]  pixels  Lower left location of text block
%                                        
% NOTES:
%
% EXAMPLE:
%   % Adds a string to the f14 model
%   txt = 'This is the documentation to add';
%   AddTextBlock('f14', txt)
%
%   % Sets the same text to be bold italic with 14 point font
%   AddTextBlock('f14', txt, 'FontSize', 14, 'FontWeight', 'bolditalic')
%
%   % Adds a cell array of strings to the f14 model
%   txt = {'This is line1', 'Line2'};
%   AddTextBlock('f14', txt)
%
%   % Adds a string to the lower left area of the f14 model with a clickable callback
%   txt = 'Click on me to edit MATLAB''s ''plot'' function!';
%   AddTextBlock('f14', txt, 'ClickFcn', 'edit(''plot'');', 'Location', [20 350])
%
% See also cell2str, format_varargin
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/681
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/AddTextBlock.m $
% $Rev: 3242 $
% $Date: 2014-09-02 17:30:56 -0500 (Tue, 02 Sep 2014) $
% $Author: sufanmi $

function [text_pos_NW, text_pos_SW] = AddTextBlock(BlockPath, varargin)

%% Debugging & Display Utilities 
spc  = sprintf(' ');                                % One Single Space
tab  = sprintf('\t');                               % One Tab
endl = sprintf('\n');                               % Line Return
[mfpath,mfnam] = fileparts(mfilename('fullpath'));  % Full Path to Function, Name of Function
mfspc = char(ones(1,length(mfnam))*spc);            % String of Spaces the length of the function name
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>> CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>> WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>> ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >> ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Input Argument Conditioning
[Location, varargin]            = format_varargin('Location', [50 10], 2, varargin);
[ClickFcn, varargin]            = format_varargin('ClickFcn', '', 2, varargin);
[Font, varargin]                = format_varargin('Font', '', 2, varargin);
[FontSize, varargin]            = format_varargin('FontSize', '', 2, varargin);
[FontWeight, varargin]          = format_varargin('FontWeight', '', 2, varargin);
[OpenBlock, varargin]           = format_varargin('OpenBlock', true, 2, varargin);
[UseDisplayTextAsClickCallback, varargin]  = format_varargin('UseDisplayTextAsClickCallback', 'off', 2, varargin);
[DropShadow, varargin]          = format_varargin('DropShadow', 'off', 2, varargin);
[HorizontalAlignment, varargin] = format_varargin('HorizontalAlignment', 'left', 2, varargin);

text_pos_NW = [0 0];
text_pos_SW = [0 0];

if(length(varargin) > 0)
    TextToAdd = varargin{1};
else
    TextToAdd=['Subversion Revision Information At Last Commit' endl '$' 'URL:' '$'  endl '$' 'Rev:' '$' endl '$' 'Date:' '$' endl '$' 'Author:' '$'];
end

%% < Function Sections >
if(iscell(TextToAdd))
    TextToAdd = cell2str(TextToAdd, char(10));
end
numRows = length(findstr(TextToAdd, char(10))) + 1;

try
    strBlockType = get_param(BlockPath, 'BlockType');
catch
%     lastmsg = lasterror;
    strBlockType = 'Root';
end

if(strcmp(strBlockType, 'S-Function'))
    disp([mfnam '>>WARNING: ' BlockPath ' is an S-Function.  Cannot add DocBlock inside subsystem.  Skipping DocBlock addition.']);
    text_pos_NW = [0 0];
    text_pos_SW = [0 0];
else
    
    ptr_slashes = findstr(BlockPath, '/');
    load_system('simulink');
    
    if(isempty(ptr_slashes))
        open_system(BlockPath, 'force');
    else
        open_system(BlockPath(1:ptr_slashes(1)-1), 'force');
    end
    
    curAnnotation= [BlockPath '/' TextToAdd];
    try
        h = add_block('built-in/Note',[BlockPath '/' TextToAdd], ...
            'HorizontalAlignment', HorizontalAlignment);

        set_param(curAnnotation, 'Position', Location);
        set_param(curAnnotation, 'ClickFcn', ClickFcn);
        
        set_param(curAnnotation, 'UseDisplayTextAsClickCallback', UseDisplayTextAsClickCallback);
        set_param(curAnnotation, 'DropShadow', DropShadow);
        
        if(~isempty(Font))
            set_param(curAnnotation, 'Font', Font);
        end
        if(~isempty(FontSize))
            set_param(curAnnotation, 'FontSize', FontSize);
        end
        if(~isempty(FontWeight))
            set_param(curAnnotation, 'FontWeight', FontWeight);
        end
        FontSizeCheck = get_param(curAnnotation, 'FontSize');
        if(FontSizeCheck == -1)
            FontSizeCheck = 10;
        end
        
        PixelPerRow = (15/10) * FontSizeCheck;
        
        text_pos_NW = get_param(curAnnotation, 'Position');
        text_pos_SW = text_pos_NW;
        text_pos_SW(2) = text_pos_SW(2) + PixelPerRow * numRows;
        
        if(OpenBlock)
            open_system(BlockPath, 'force');
        end
        
    catch
        [a, b] = lasterr;
        disp([mfnam '>>WARNING: Unable to add TextBlock to ''' BlockPath '''.  Ignoring addition command.']);
    end
    
    % Example of Display formats ...
    % disp([mfnam '>> Output with filename included...' ]);
    % disp([mfspc '>> further outputs will be justified the same']);
    % disp([mfspc '>>CAUTION: or mfnam: note lack of space after">>"']);
    % disp([mfnam '>>WARNING: <- Very important warning (does not terminate)']);
    % disp([mfnam '>>ERROR: <-if followed by "return" used if continued exit desired']);
    % errstr = [mfname >>ERROR: <define error here> ]; will term with error; "doc Error" ';
    % error([mfnam 'class:file:Identifier'],errstr);
end

%% Outputs

%% Return
end

%% REVISION HISTORY
% YYMMDD INI: note
% 100804 MWS: File Created
%**Add New Revision notes to TOP of list**

% Initials Identification:
% INI: FullName  :  Email  :  NGGN Username
% MWS: Mike Sufana : mike.sufana@ngc.com : sufanmi

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is
%   subject to severe civil and/or criminal penalties.

% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
