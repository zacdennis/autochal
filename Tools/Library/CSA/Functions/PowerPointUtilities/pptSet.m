% PPTSET used to set parameters of pptObjects including figures
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% pptSet:
%     <Function Description> 
%
% Inputs - pptObject: if omited, or set to 'gcs', gets current gcs objecteither a pptObject 
%		 - varargin: {0,[1]}: <explain {options, [Default]}> 
%		 
% Output - pptObject: <Explanation> 
%        - figStruct: <Explanation> 
%
% SYNTAX:
%	[WrkSelection, figStruct] = pptSet(pptObject, varargin, 'PropertyName', PropertyValue)
%	[WrkSelection, figStruct] = pptSet(pptObject, varargin)
%	[WrkSelection, figStruct] = pptSet(pptObject)
%
% INPUTS: 
%	Name        	Size		Units		Description
%	pptObject	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name        	Size		Units		Description
%	WrkSelection	<size>		<units>		<Description> 
%	figStruct	   <size>		<units>		<Description> 
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
%   [pptObject,figStruct] = pptSet('Name','MYFig'); %prompts to select!
%	[pptObject,figStruct] = pptSet(pptObject,varargin);
%
%	% <Enter Description of Example #1>
%	[WrkSelection, figStruct] = pptSet(pptObject, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[WrkSelection, figStruct] = pptSet(pptObject)
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
%	Source function: <a href="matlab:edit pptSet.m">pptSet.m</a>
%	  Driver script: <a href="matlab:edit Driver_pptSet.m">Driver_pptSet.m</a>
%	  Documentation: <a href="matlab:pptOpen('pptSet_Function_Documentation.pptx');">pptSet_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/59
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/pptSet.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [WrkSelection, figStruct] = pptSet(pptObject, varargin)

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
% WrkSelection= -1;
% figStruct= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        pptObject= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
ppt = actxserver('PowerPoint.Application'); % Get ppt object. 
switch nargin
    case 0
        pptObject = 'sel';
end

% recover selected object if you dont' have it in the first argument already... 
if ~isempty(strfind(class(pptObject),'Interface.Microsoft_PowerPoint_')) %is it a pptObject already?
    WrkSelection = pptObject; % it's already an object
elseif ischar(pptObject) %is it a command on how to get teh object
    switch pptObject(1:2)
        case {'gc','GC','Gc','gC'}
            WrkSelection = ppt.ActiveWindow.Selection;
        case {'se','SE','Se','sE'}
            while ~exist('KeepSelecting','var') || KeepSelecting
                try
                    t = input([mfnam '>> Please select a Powerpoint object (Enter = continue, q=quit): '],'s');
                    if isempty(t)
                        WrkSelection = ppt.ActiveWindow.Selection; 
                        KeepSelecting = 0; 
                    else
                        disp([mfspc '>> quiting...']);
                        pptObject = -1; figStruct = -1; 
                        return
                    end
                catch me
                    disp(me.message)
                end %end of try to get input
            end %end of while prompting loop
        otherwise
            disp([mfnam '>>ERROR: Can''t parse first input']);
    end %of switch
end %of input type
%% Main Function:
%% Get Class Type
%determin if this is an object or a selection object
if any(strcmp(fieldnames(WrkSelection),'Type'))
    classtype = WrkSelection.Type;
else %We need to make it a selection (so we can deal with it consistently)
    pptObject.Select;
    WrkSelection = ppt.ActiveWindow.Selection;
    classtype = WrkSelection.Type;
end

%% Parse through all the properties...
% see if we have an even number of items (proper,val) pairs
if rem(length(varargin),2)==1;
    disp([mfnam '>> WARNING: lastProperty has no value and is being ignored']);
end
% Loop through pairs... 
for i = 1:floor(length(varargin)/2) %read in pairs... 
    Prop = varargin{(i-1)*2+1};
    Val  = varargin{(i-1)*2+2};
    % Parse specific Tags ahead of time (check values)
    % This section is used to parse any pptSet specific formats of data
    switch Prop
        case 'Position'
            if ~isnumeric(Val)
                error([mfnam '>> Value must be a numeric vector']);
            end
            switch length(Val) %based on 3 input or 4 input form
                case 3
                    op = WrkSelection; 
                    LookCount =0; 
                    while LookCount < 100 %LookingForPresentation && 
                        LookCount = LookCount + 1; %Emergency out... 
                        classOP = class(op);
                        if strcmp(classOP,'Interface.Microsoft_PowerPoint_11.0_Object_Library._Presentation')
                            title_percentage = 0.15;
                            footer_percentage = 0.05;
                            def_pos(1) = op.PageSetup.SlideHeight*title_percentage; %From Top
                            def_pos(2) = 0; %From Left
                            def_pos(3) = op.PageSetup.SlideHeight*(1-title_percentage-footer_percentage); %Height
                            def_pos(4) = op.PageSetup.SlideWidth; %Width
                            continue
                        elseif strcmp(classOP,'Interface.Microsoft_PowerPoint_11.0_Object_Library._Application')
                            def_pos  = [81  0  432  720];
                            disp([mfnam '>> CAUTION: Can''t fidn slide size default: using: ' num2str(def_pos) ]);
                        else
                            op = op.parent;
                        end
                    end
                    Position = GetShapePosition(Val,def_pos);
                case 4
                    Position = Val; 
                otherwise
                    error('wrong size position vector');
            end %sortint out which position format...
        case {'Name','Title'}
            if ~ischar(Val)
                error([mfnam '>> Value with this property (Pairnum: ' num2str(i) ') must be a string']);
            end
    end %Value testing

    %% Class Propertie Sel/Setup

    switch classtype %available properties based on what you selected
        case 'ppSelectionShapes'
            switch Prop
                case 'Name'
                    WrkSelection.Shape.Name = Val;
                case 'Position'
                    WrkSelection.Shape.Top  = Position(1);
                    WrkSelection.Shape.Left = Position(2);
                    WrkSelection.Shape.Height = Position(3);
                    WrkSelection.Shape.Width  = Position(4);
                case 'SlideTitle'
                    dbstop if error; %TODO Remove when this works...
                    disp('WARNING: You must run "dbclear if error" from the cmd line');
                    WrkSelection.Parent.SlideRange.Shapes.Title.TextFrame.TextRange.Text = Val; 
                case 'Debug'
                    dbstop if error
                    disp('WARNING: You must run "dbclear if error" from the cmd line');
                    This is an error but now you can see what is here % a variable
                otherwise
                    disp([mfnam '>> ERROR: Can''t currently set "' Prop '" on Shape Objets']);
                    disp([mfspc '>> If it is possible then you shoudl add it! '])
                    error([mfnam '>> Can''t set "' Prop '" property on Shape object']);
            end
        case 'ppSelectionSlides'
            switch Prop
                case 'Name'
                    WrkSelection.Slide.Name = Val;
                case {'Position','SlideIndex','MoveTo'}
                    WrkSelection.Slide.MoveTo(Prop);
                case 'Title'
                    WrkSelection.SlideRange.Shapes.Title.TextFrame.TextRange.Text = Val;
                case 'Debug'
                    dbstop if error
                    disp('WARNING: You must run "dbclear if error" from the cmd line');
                    This is an error but now you can see what is here % a variable
                otherwise
                    disp([mfnam '>> ERROR: Can''t currently set "' Prop '" on Slide Objets']);
                    disp([mfspc '>> If it is possible then you shoudl add it! '])
                    error([mfnam '>> Can''t set "' Prop '" property on Slide object']);
            end                
        case 'ppSelectionText'
            switch Prop
                case 'Debug'
                    dbstop if error
                    disp('WARNING: You must run "dbclear if error" from the cmd line');
                    This is an error but now you can see what is here % a variable
                otherwise
                    disp([mfnam '>> ERROR: Can''t currently set "' Prop '" on Text Objets']);
                    disp([mfspc '>> If it is possible then you shoudl add it! '])
                    error([mfnam '>> Can''t set "' Prop '" property on Text object']);
            end
%         %Example new class
%       case <newclass>
%           switch Prop
%               case <propname1>
%               case <propname2>
%               otherwise
%                   disp([mfnam '>> ERROR: Can''t currently set "' Prop '" on Text Objets']);
%                   disp([mfspc '>> If it is possible then you shoudl add it! '])
%                   error([mfnam '>> Can''t set "' Prop '" property on <newclass> object']);
%           end  
        otherwise
            disp([mfnam '>> No property setting allowed for type "' classtype '"' ]);
            disp([mfspc '>> Go to this part of code and add it! Community Service!']);
            disp([mfspc '>> in the meantime... ']);
            error('Can''t figure out what name type to write');
    end %switch between class of the object
end %for loop throuth parameter pairs

%% Compile Outputs:
%	WrkSelection= -1;
%	figStruct= -1;

end % << End of function pptSet >>

%% Subroutine: GetShapePosition
%this is a direct copy out of the pptWriteFig function (i'm not sure i want
%this simple routine to have a whole other file that it calls... 
% TODO: decide if placing this here is a bad thing... 
function [Position] = GetShapePosition(PosCmd,def_pos,inset)
    % Stuff is a three vector mnp like subplot 
    % def_pos is currently required and specifies working area to parse.
    %[Top Left Hieght Width]
    % any inset into def_pos should be calculated prior to call... 
    switch(nargin)
        case 2
%             inset = [0.2 0.18 0.04 0.1]; % [left bottom right top]; 
            inset = [0.1 0.2 0.18 0.04]; %#ok<NASGU> % [top Left bottom right].
%             inset = [
            %TODO : implement Inset
    end
                
    nrows = PosCmd(1); 
    ncols = PosCmd(2); 
    thisPlot = PosCmd(3); 
    %check to see that we aren't asking for a plot off the grid. 
    if thisPlot > ncols*nrows
        error('Plot Index exceeds number of created spots, p>m*n');
    end

    % get current row and column
    row = fix((thisPlot+1)/ncols) - (nrows-1); %zero indexed
    col = rem (thisPlot-1, ncols); %zero indexed
  
    % compute outerposition and insets relative to figure bounds
    width = def_pos(4)/(ncols);
    height = def_pos(3)/(nrows);
    Position = [def_pos(1) + row*height,...
                def_pos(2) + col*width, ...
                height,  width];
end

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
% 080917 TKV: this version is much cleaner (and editable...) 
% 080917 TKV: the last version was messy... 
% 080917 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% TKV: Travis Vetter        :  travis.vetter@ngc.com:  vettetr

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
