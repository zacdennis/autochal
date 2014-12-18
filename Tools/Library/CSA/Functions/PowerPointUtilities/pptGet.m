% PPTGET used to set parameters of pptObjects including figures
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% pptGet:
%       Returns the value of the property selected based on the type of
%       the selected item.f
%
% Inputs - pptSelObj: {'gc' => Get Currently selected object
%                      'sel' => prompts to select an object
%                      <pptSelectionObject> => used directly
%		 - Prop(s): a character list of desired properties
%		 
% Output - Value: {Value of Property (1 requested)
%                  Struct of PropValues Requested
%        - pptObj: Reduced ppt ActiveX object
%        - pptSelObj: ppt ActiveX Selection object
%
% SYNTAX:
%	[Value, pptObj, pptSelObj] = pptGet(pptSelObj, varargin, 'PropertyName', PropertyValue)
%	[Value, pptObj, pptSelObj] = pptGet(pptSelObj, varargin)
%	[Value, pptObj, pptSelObj] = pptGet(pptSelObj)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	pptSelObj	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	Value	    <size>		<units>		<Description> 
%	pptObj	   <size>		<units>		<Description> 
%	pptSelObj	<size>		<units>		<Description> 
%
% NOTES:
% When called with no property value or 'get' returns all 
% properties to retreive
% PPTWRITEFIG - set Prop = 'figStruct' to return a figStruct!
%    returns an error if theobject is not a shape object.  
% This function can grow significantly as deisred. Templates
% are included in the code to show a user how to extend the
% available properties to the ones they need.  PLEASE DO SO!
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	[value] = pptGet('sel','Name'); %prompts user to select object 
%               if possible returns the name of that object
%   [value,pptObj,pptSelObj] = pptGet('sel','Name'); Prompt user
%         to select an object and returns the 'Name' value.
%   [value] = pptGet(pptSelObj,'Position'); Returns the 'Position' 
%         property data associated with the PowerPoint Selection
%         object already saved. 
%   [value] = pptGet('gc') same as pptGet('gc','get'); Returns a 
%         struct with all available properties
%
%	% <Enter Description of Example #1>
%	[Value, pptObj, pptSelObj] = pptGet(pptSelObj, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Value, pptObj, pptSelObj] = pptGet(pptSelObj)
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
%	Source function: <a href="matlab:edit pptGet.m">pptGet.m</a>
%	  Driver script: <a href="matlab:edit Driver_pptGet.m">Driver_pptGet.m</a>
%	  Documentation: <a href="matlab:pptOpen('pptGet_Function_Documentation.pptx');">pptGet_Function_Documentation.pptx</a>
%
% See also pptSet pptWriteFig pptSelectShape
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/60
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/pptGet.m $
% $Rev: 1726 $
% $Date: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Value, pptObj, pptSelObj] = pptGet(pptSelObj, varargin)

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
% Value= -1;
% pptObj= -1;
% pptSelObj= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        pptSelObj= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
switch nargin
    case 0
        pptSelObj = 'sel';
        Prop = {'get'};
    case 1
        Prop = {'get'};
    otherwise
        Prop = varargin;
end

ppt = actxserver('PowerPoint.Application'); % Get ppt object. 

Value = struct([]); 
% recover selected object if you dont' have it already... 
if ~isempty(strfind(class(pptSelObj),'Interface.Microsoft_PowerPoint_')) %is it a pptSelObj already?
    WrkSelection = pptSelObj;
elseif ischar(pptSelObj) %is it a command on how to get the object
    switch pptSelObj(1:2)
        case {'gc','GC','Gc','gC'} %force GetCurrentSelection(Don't Prompt ever)
            WrkSelection = ppt.ActiveWindow.Selection;
        case {'se','SE','Se','sE'} %Propmts, but an enter gets previously selected
            while ~exist('KeepSelecting','var') || KeepSelecting %#ok<NODEF> Protected on Left side
                try
                    t = input([mfnam '>> Please select a Powerpoint object (Enter = continue, q=quit): '],'s');
                    if isempty(t)
                        WrkSelection = ppt.ActiveWindow.Selection; 
                        KeepSelecting = 0; 
                    else
                        disp([mfspc '>> quiting...']);
                        pptSelObj = -1;  
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
%% Determine Class Property set: 
% There are many "Shape" types -> we need to determine which one... 
classtype = WrkSelection.Type;

%% Class Propertie Sel/Setup
KeepGoing = 1;
PropIdx = 0; 
while KeepGoing 
    PropIdx = PropIdx+1;
    KeepGoing = (PropIdx < length(Prop)); %When PropIdx = l
    switch classtype %available properties based on what you selected
        %% Shape Selected
        case 'ppSelectionShapes'
            pptObj = WrkSelection.Shape;
            pptObjPar = pptObj.Parent;
            ShapeType = pptObj.Type; 
            switch ShapeType
                case 'msoPicture'
                    switch Prop{PropIdx}
                        case 'get' %all available Properties
                            Prop = sort({'Name','Position','Slide','SlideIndex','SlideNumber','Type','Zorder'}); 
                            Prop{1,end+1} = 'figStruct'; %#ok<AGROW> (only read once) %Wanted this last. 
                            PropIdx = 0; %Control loop
                            KeepGoing = 1; %restart loop
                            WasGet = 1; %#ok<NASGU> % Flag saying it was from a get call (rarely used)
                        case 'figStruct' %SpecialCase
                            Prop = {'Slide','Name','Position'};
                            PropIdx = 0;
                            KeepGoing = 1; %restart loop
                            %initialize Value structur to the pptWriteRequirement
                            if exist('WasGet','var')
                                Value(1).figStruct = struct('Slide',-1,'Name',-1,'Position',-1,'ForcePos',0,'KeepOld',0);
                            else
                                Value = struct('Slide',-1,'Name',-1,'Position',-1,'ForcePos',0,'KeepOld',0);
                            end
                        case 'Name'
                            Value(1).Name = pptObj.Name;     
                        case 'Position'
                            Value(1).Position(1) = pptObj.Top;
                            Value(1).Position(2) = pptObj.Left;
                            Value(1).Position(3) = pptObj.Height;
                            Value(1).Position(4) = pptObj.Width;
                        case 'Slide'
                            Value(1).Slide = WrkSelection.Slide.Name;
                        case 'SlideIndex'
                            Value(1).SlideIndex = WrkSelection.Slide.SlideIndex;
                        case 'SlideNumber'
                            Value(1).SlideNumber = WrkSelection.Slide.SlideNumber;
                        case 'Type'
                            Value(1).Type = ShapeType;
                        case 'Zorder'
                            Value(1).Zorder = pptObj.Zorder;
                        case 'Debug'
                            dbstop if error
                            disp([endl endl 'WARNING: You must run "dbclear if error" from the cmd line' endl]);
                            This is an error but now you can see what is here % a variable
                        otherwise
                            try
                                Value(1).(Prop{PropIdx}) = pptObj.(Prop{PropIdx});
                                disp([mfnam '>> Dynamic Properties worked!, Please enter: ' Prop{PropIdx} ' into the function' endl ...
                                      mfspc '>> for ShapeTypes: ' ShapeType ' of ClassTypes: ' classtype]);
                            catch UnfoundProperty
                            disp([mfnam '>> ERROR: Can''t currently get "' Prop{PropIdx} '" on Shape Objets']);
                            disp([mfspc '>> If it is possible then you shoudl add it! '])
                            error([mfnam '>> Can''t get "' Prop{PropIdx} '" property on ' ShapeType ' of ' classtype ' object']);
                            end
                    end
                case {'msoTextBox','msoPlaceholder'} 
                    %TODO: Little nervous about the placeholder!
                    switch Prop{PropIdx}
                        case 'get'
                            Prop = sort({'Name','Slide','SlideIndex','SlideNumber','Text','Type','Zorder'});
                            PropIdx = 0; %Control loop
                            KeepGoing = 1; %restart loop
                        case 'Name'
                            Value(1).Name = pptObj.Name; 
                        case 'Slide'
                            Value(1).Slide = pptObjPar.Name;
                        case 'SlideIndex'
                            Value(1).SlideIndex = pptObjPar.SlideIndex;
                        case 'SlideNumber' 
                            Value(1).SlideNumber = pptObjPar.SlideNumber; 
                        case 'Text'
                            Value(1).Text = pptObj.TextFrame.TextRange.Text; 
                        case 'Type'
                            Value(1).Type = ShapeType;
                        case 'Zorder'
                            Value(1).Zorder = pptObj.Zorder;
                        case 'Debug'
                              dbstop if error
                              disp([endl endl 'WARNING: You must run "dbclear if error" from the cmd line' endl]);
                              This is an error but now you can see what is here % a variable
                        otherwise
                            try
                                Value(1).(Prop{PropIdx}) = pptObj.(Prop{PropIdx});
                                disp([mfnam '>> Dynamic Properties worked!, Please enter: ' Prop{PropIdx} ' into the function' endl ...
                                      mfspc '>> for ShapeTypes: ' ShapeType ' of ClassTypes: ' classtype]);
                            catch UnfoundProperty
                                disp([mfnam '>> ERROR: Can''t currently set "' Prop{PropIdx} '" on Text Objets']);
                                disp([mfspc '>> If it is possible then you shoudl add it! '])
                                error([mfnam '>> Can''t get "' Prop{PropIdx} '" property on ' ShapeType ' of ' classtype ' object']);  
                            end %Otherwise
                    end %Prop{PropIdx}
                otherwise
                    error('Please determine and enter this subtype!');     
            end %Shape Type
        %% Slide Selected
        case 'ppSelectionSlides'
            pptObj = WrkSelection.Slide;
            switch Prop{PropIdx}
                case 'get'
                    Prop = sort({'Name','SlideIndex','SlideNumber'});
                    PropIdx = 0; %Restart Property loop
                    KeepGoing = 1; % Restart Loop
                case 'Name'
                    Value(1).Name = pptObj.Name;
                case 'SlideIndex' % the actual number of the slide
                    Value(1).SlideIndex = pptObj.SlideIndex;
                case 'SlideNumber'  % The number (page number)
                    Value(1).SlideNumber = pptObj.SlideNumber;
                case 'Title'
                    if strcmp(pptObj.Layout,'ppLayoutBlank')
                        error('Layout does not allow title');
                    elseif strcmp(pptObj.Shapes.HasTitle,'msoTrue')
                        Value(1).Title = pptObj.Shapes.Title.TextFrame.TextRange.Text;
                    else
                        error('Slide contains no title');
                    end
                case 'Debug'
                    dbstop if error
                    disp([endl endl 'WARNING: You must run "dbclear if error" from the cmd line' endl]);
                    This is an error but now you can see what is here % a variable
                otherwise
                    try
                        Value(1).(Prop{PropIdx}) = pptObj.(Prop{PropIdx});
                        disp([mfnam '>> Dynamic Properties worked!, Please enter: ' Prop{PropIdx} ' into the function' endl ...
                              mfspc '>> for ' classtype ' object']);
                    catch UnfoundProperty
                        disp([mfnam '>> ERROR: Can''t currently get "' Prop{PropIdx} '" on Slide Objets']);
                        disp([mfspc '>> If it is possible then you should add it! '])
                        error([mfnam '>> Can''t get "' Prop{PropIdx} '" property on ' classtype ' object']);
                    end
            end  
        %% Text Selected
        case 'ppSelectionText'
            pptObj = WrkSelection.TextRange; 
            switch Prop{PropIdx}
                case 'get'
                    Prop = sort({'Position','Slide','SlideIndex','SlideNumber','Text','Zorder'});
                    PropIdx = 0; %Control loop
                    KeepGoing = 1; %Restart Loop with New Proplist
                case 'Position'
                    Value(1).Position(1) = pptObj.Top;
                    Value(1).Position(2) = pptObj.Left;
                    Value(1).Position(3) = pptObj.Height;
                    Value(1).Position(4) = pptObj.Width;    
                case 'Slide'
                    Value(1).Slide = WrkSelection.Slide;
                case 'SlideIndex'
                    Value(1).SlideIndex = WrkSelection.SlideIndex;
                case 'SlideNumber'
                    Value(1).SlideNumber = WrkSelection.SlideNumber;
                case 'Text'
                    Value(1).Text = pptObj.Text;
                case 'Zorder'
                    Value(1).Zorder = pptObj.Zorder;
                case 'Debug'
                    dbstop if error
                    disp([endl endl 'WARNING: You must run "dbclear if error" from the cmd line' endl]);
                    This is an error but now you can see what is here % a variable
                otherwise
                    disp([mfnam '>> ERROR: Can''t currently set "' Prop{PropIdx} '" on Text Objets']);
                    disp([mfspc '>> If it is possible then you shoudl add it! '])
                    error([mfnam '>> Can''t get "' Prop{PropIdx} '" property on ' classtype ' object']);
            end
    %% Example new class
    %   case <newclass>
    %       switch Prop{PropIdx}
    %           case 'get'
    %               Prop = sort({'<list of props>'});
    %               PropIdx = 0; %Control loop
    %               KeepGoing = 1; %restart loop
    %           case <propname1>
    %               Value(1).<propname> = stuff;
    %           case <propname2>
    %           case 'Debug'
    %                   dbstop if error
    %                   disp([endl endl 'WARNING: You must run "dbclear if error" from the cmd line' endl]);
    %                   This is an error but now you can see what is here % a variable
    %               end
    %           otherwise
    %               disp([mfnam '>> ERROR: Can''t currently set "' Prop{PropIdx} '" on Text Objets']);
    %               disp([mfspc '>> If it is possible then you shoudl add it! '])
    %               error([mfnam '>> Can''t get "' Prop{PropIdx} '" property on ' classtype ' object']);
    %       end  
        otherwise
            disp([mfnam '>> No property setting allowed for type "' classtype '"' ]);
            disp([mfspc '>> Go to this part of code and add it! Community Service!']);
            disp([mfspc '>> in the meantime... ']);
            error('Can''t figure out what name type to write');
    end %switch between class of the object
end %forloop through props
% Example of Display formats ...
% errstr = [mfname >>ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Output
pptSelObj = WrkSelection;  %copy to better name
fldnames= fieldnames(Value);
if length(fldnames) == 1
    Value=Value.(fldnames{1});
end

%% Compile Outputs:
%	Value= -1;
%	pptObj= -1;
%	pptSelObj= -1;

end % << End of function pptGet >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101101 JPG: Copied over information from the old function.
% 101101 CNF: Function template created using CreateNewFunc
% 090908 TKV: Big update to new types and subtypes... Added Dynamic Names
% 080917 TKV: Wrote in spirit of the new pptSet and i like it... 
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
