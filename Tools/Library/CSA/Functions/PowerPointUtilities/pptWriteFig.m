%% PPTWRITEFIG writes/updates figures for a PowerPoint presentation
% -------------------------- UNCLASSIFIED ---------------------------
% --------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% pptWriteFig:
%     writes/updates figures in a powerpoint presentation, if figure/presentation 
%     does not exist, will create a new figure/presentation 
% 
% Inputs - h: figure handle
%        - pptfilename: filename of PowerPoint presentation to modify/create
%		 - figStruct: structure containing information about how to manage figure
%               .Slide - numeric { -1 - Search for slide using shape name 
%                                  n<=nslides - select existing slide n
%                                  n>nslides - create n-nslides and select slide n
%                                  inf - append slide".Name" the number/name of slide to put figure on
%                        char [AppInstr <Slide Name>] 
%                                                          
%               .Name - char [AppInstr <figName>] The append instruction and 
%                           desired name for the figure         
%                       numeric (-1 only!) - create default name
%               .Title - char [<Text for title>] The desired title of the slide 
%               .Position - 3vect [rows, cols, num] (as Subplot) 
%                         - 4vect [Top Left Height Width] as ppt's meaning
%               .ForcePos - if true, uses size specified (instead of the
%                               current size) 
%               .KeepOld - <NOT IMPLEMENTED>
%		 
% Output - pptWriteStruct
%               .filename
%               .figurehandles
%               .figStruct (as performed)
%        - WrkShape: Returns the pptShape Object written
%       
% Append Instruction { '+'  -  append (does not exist)
%                     ['*'] -  append if necc (unknown state)[Default]
%                      '-'  -  do not append (already exists)} 
%
% !NOTE!: to recover a figStruct suitible for this program use 
% [figStruct] = pptGet('sel','pptFigStruct'); if a proper shape is selected
%   it will return a valide figStruct for use in this function! 
%
% Examples:
%   [pptStruct] = pptWriteFig(figHandle,pptFilename); %Easy Form
%        -[Above] Appends to end full size (backward compatible to pptsave.  
%	[pptStruct] = pptWriteFig(figHandle,pptfilename,figStruct);
%   [pptStruct] = pptWriteFig(figHandle,pptfilename,pptGet('sel','pptFigStruct'));
%
% See also pptGet pptSet  
% 
% Copyright Northrop Grumman Corp 2008

% Subversion Revsion Informaton At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/PowerPointUtilities/pptWriteFig.m $
% $Rev:: 1811                                                 $
% $Date:: 2011-05-25 11:06:50 -0500 (Wed, 25 May 2011)        $

function [pptWriteStruct,WrkShape] = pptWriteFig(h,filename,figStruct)

%% General Header 
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
mfnam = mfilename;
mfspc = char(ones(1,length(mfnam))*spc);

%% Arg conditioning
DefaultFigStruct = struct('Slide', inf, 'Name', -1, 'Position', -1, 'ForcePos',0,...
                            'KeepOld',0);
title_percentage = 0.15;
footer_percentage = 0.05;

switch nargin
    case 1; 
        [fname, fpath] = uiputfile('*.ppt');
        if fpath == 0; return; end
        filename = fullfile(fpath,fname);
        figStruct = DefaultFigStruct;
    case 2; 
        figStruct = DefaultFigStruct;
    case 3; 
        
end; %switch

lenh = length(h); %length of h
if lenh > 1 && length(figStruct)==1
    figStruct(2:lenh) = figStruct; %replicate 
end

%% Setup PPT File
ppt = actxserver('PowerPoint.Application'); % Start an ActiveX session with PowerPoint
pptVer = floor(str2double(ppt.Version));
ppt.Visible = 1;

%Get full filename
[fpath,fname,fext] = fileparts(filename);
if isempty(fpath); % must have full path
    fpath = pwd; 
end
if isempty(fext); % check for ppt extension
    if pptVer == 12
        fext = '.pptx';
    else
        fext = '.ppt';
    end
elseif strcmp(fext,'.ppt') && pptVer == 12
    disp(['WARNING: If using Office 2007 with ".ppt" file extensions' endl ...
          'SlideNames will be overwritten upon closing file.' endl ...
          'Next run of pptWriteFig() will not update plots.' endl ...
          'Use ".pptx" file extension for update-able plotting features.']);
elseif strcmp(fext,'.pptx') && (pptVer == 10 || pptVer == 11)
    error('ERROR: Attempting to use Power Point 2003 to save presentation as a .pptx file.');
elseif ~strcmp(fext,'.ppt') && ~strcmp(fext,'.pptx')
    error(['ERROR: Unrecognized Power Point file format: "' fext '"']);
end
filename = fullfile(fpath,[fname,fext]); %update filename

% open/create/grab file
if ~exist(filename,'file');
    % Create new presentation:
    op = invoke(ppt.Presentations,'Add');
    op.SaveAs(filename); % Saveas to move to this directory and create empty ppt.
    wasopen= 0; 
else
    try
        op = ppt.Presentations.Item(filename); %is it open?
        wasopen = 1; 
        op.Save; 
    catch WasOpenError
        % Open existing presentation:
        op = invoke(ppt.Presentations,'Open',filename);
        wasopen = 0;
    end
end

%% LOOP Through figures; 
for hidx = 1:length(h)
    % Check and setup Defaults at current figStruct.
    warnstate = warning('QUERY','catstruct:DupFieldnames');
    warning('OFF','catstruct:DupFieldnames');    
    %     figStruct(hidx) = catstruct(DefaultFigStruct,figStruct(hidx)); %use default values -> over right with values from input 
    % TODO I really want to use this line, but it errors out... it
    % hink because the fields get reorganized... so WORKAROUND 
    % after first one, all teh fields unpopulated are empty... argh... have
    % to be even more brutal... 
    LocFigStruct = catstruct(DefaultFigStruct,figStruct(hidx)); %use default values -> over write with values from input
    warning(warnstate.state,'catstruct:DupFieldnames');
    %workaround
    if isempty(LocFigStruct.Slide); figStruct(hidx).Slide= DefaultFigStruct.Slide;
    else figStruct(hidx).Slide = LocFigStruct.Slide;
    end
    if isempty(LocFigStruct.Name); figStruct(hidx).Name = DefaultFigStruct.Name ;
    else figStruct(hidx).Name = LocFigStruct.Name ; 
    end
    if isempty(LocFigStruct.Position); figStruct(hidx).Position = DefaultFigStruct.Position ;
    else figStruct(hidx).Position = LocFigStruct.Position ; 
    end
    if isempty(LocFigStruct.ForcePos); figStruct(hidx).ForcePos = DefaultFigStruct.ForcePos ;
    else figStruct(hidx).ForcePos = LocFigStruct.ForcePos ; 
    end
    if isempty(LocFigStruct.KeepOld); figStruct(hidx).KeepOld = DefaultFigStruct.KeepOld ;
    else figStruct(hidx).KeepOld = LocFigStruct.KeepOld ; 
    end
    %end workaround 
    
   
    %% LOOP: Make New Slide/s as neccesary
    slide_count = int32(double(get(op.Slides,'Count')));
    
    if isnumeric(figStruct(hidx).Slide) && (figStruct(hidx).Slide == -1); % -1 == Search for figname
        %TODO Loop throught slides to find a figure wiht the right name
        if any(strcmp(figStruct(hidx).Name(1), {'+','*','-'}))
            figStruct(hidx).Slide = FindSlide_Shape(op,figStruct(hidx).Name(2:end));
        else
            figStruct(hidx).Slide = FindSlide_Shape(op,figStruct(hidx).Name);
        end %if instruction included
    end %if search for slide
    % set Slide to any number greater then slide_count to append to end
    % (INF works)
    if isnumeric(figStruct(hidx).Slide) 
        if figStruct(hidx).Slide > slide_count; %need to append slides 
            % numeric case with num>slidecount
            Nslides2Add = figStruct(hidx).Slide - slide_count;
            if Nslides2Add >= 1000; %inf threshold
                Nslides2Add = 1; 
            end; %nominal append case. 
            if Nslides2Add > 5; disp([mfnam '>> Caution: creating ' num2str(Nslides2Add) ' new slides!']);end
            for i=1:Nslides2Add % loop till we get to the number specified.
                slide_count = int32(double(slide_count)+1); %just appends to end
                switch pptVer
                    case {10,11}
                        WrkSlide = invoke(op.Slides,'Add',slide_count,'ppLayoutText'); % PowerPoint2003
                    case 12
                        layout = op.SlideMaster.CustomLayouts.Item(2); 
                        WrkSlide = op.Slides.AddSlide(slide_count,layout); %PowerPoint2007
                    otherwise
                        error('Unknown PowerpointVersion!'); 
                end
                %TODO: I used ppLayoutText because it is the default by
                %hand... but where shoudl we get this? 
                figStruct(hidx).Slide = WrkSlide.Name; %prefered to use names
            end
        else %slide number is within range of existing slides
            WrkSlide = op.Slides.Item(figStruct(hidx).Slide);  %set WrkSlide to designated slide
            figStruct(hidx).Slide = WrkSlide.Name; %prefered 
        end
    elseif ischar(figStruct(hidx).Slide) %Slide was specified as a character string
        % follow instructions for the SlideName
        if ~any(strcmp(figStruct(hidx).Slide(1), {'+','*','-'}))
            figStruct(hidx).Slide = ['*' figStruct(hidx).Slide]; %default case
        elseif length(figStruct(hidx).Slide) == 1
            error('only a instruction but no name givin?  what is that?'); 
        end
        switch figStruct(hidx).Slide(1); % get first character instruction
            case '+' % error if exists
                %TODO: -> error if name is zero length
                try %try to create slide and call.. 
                    slide_count = int32(double(slide_count)+1); %just appends to end
                    WrkSlide = invoke(op.Slides,'Add',slide_count,12); %TODO: what is 12? 
                    WrkSlide.Name = figStruct(hidx).Slide(2:end); 
                    WrkSlide = op.Slides.Item(figStruct(hidx).Slide(2:end)); 
                    %this line will error if slide with this name exists
                catch ER1 % This is teh deisred path (append a slide)
                    % Removed already added slide
                    WrkSlide.Delete; 
                    %TODO: improve error message
                    error(['found preexisting slide named: ' figStruct(hidx).Slide(2:end) ' can''t append with that name']);
                end
            case '*' %unknown case append if necc
                %TODO: -> error if name is zero length
                try %this will work if slide exists
                    WrkSlide = op.Slides.Item(figStruct(hidx).Slide(2:end));
                catch ER2 %or create new one...
                    slide_count = int32(double(slide_count)+1); %just appends to end
                    WrkSlide = invoke(op.Slides,'Add',slide_count,12); %TODO: what is 12? 
                    WrkSlide.Name = figStruct(hidx).Slide(2:end); 
                end
            case '-' % exists (error if ~exist)
                WrkSlide = op.Slides.Item(figStruct(hidx).Slide(2:end)); %call slide (error if not found)
                %this will generate it's own error
            otherwise %default '/' Same code again... 
                %TODO: -> error "how did you get here?
                error('how did you get here? SlideName'); 
        end %switch
    else % not numeric (and readable) or character 
        error('Can''t undersatnd ''.Slide'' instruction/name/number');
    end

    %% LOOP: Prepare Shape Sizes 
    % get Default Position / Working area (Currently the whole slide for
    % backwards compatibility with previous versions
    
    def_pos(1) = op.PageSetup.SlideHeight*title_percentage; %From Top
    def_pos(2) = 0; %From Left
    def_pos(3) = op.PageSetup.SlideHeight*(1-title_percentage-footer_percentage); %Height
    def_pos(4) = op.PageSetup.SlideWidth; %Width
 
    %read input: set to -1 to get defaults. 
    switch length(figStruct(hidx).Position)
        case 1
            %not even going to check, but it had better equal -1! 
            figStruct(hidx).Position = [-1 -1 -1 -1]; 
        case 3
            figStruct(hidx).Position = GetShapePosition(figStruct(hidx).Position,def_pos);
        case 4 %Size Specified or determined above
            %noop
        otherwise
            error('Position must be -1, a 3vect or 4vector');
    end
    
%     if figStruct(hidx).Position == -1
    if figStruct(hidx).Position(1) == -1; figStruct(hidx).Position(1) = def_pos(1); end
    if figStruct(hidx).Position(2) == -1; figStruct(hidx).Position(2) = def_pos(2); end
    if figStruct(hidx).Position(3) == -1; figStruct(hidx).Position(3) = def_pos(3); end
    if figStruct(hidx).Position(4) == -1; figStruct(hidx).Position(4) = def_pos(4); end
      

    %% LOOP: Prepare Fig for clipboard 
    % Take Care of Docked figures / put back
    docked = get(h(hidx),'WindowStyle');
    set(h(hidx),'WindowStyle','normal');
    Position = get(h(hidx),'Position');
    PaperPositionMode = get(h(hidx),'PaperPositionMode');
    InvertHardCopy = get(h(hidx), 'InvertHardCopy');
    Color = get(h(hidx),'color'); 
    
    set(h(hidx),'PaperPositionMode','auto'); %to use screen size
    set(h(hidx),'InvertHardCopy','off');
    set(h(hidx),'color','none');
%     set(h(hidx),'Position',[0    0   figStruct(hidx).Position(4)   figStruct(hidx).Position(3)]);
    %Note TMW uses Left,Bottom,Width,Height
    %  -> ppt and this file use Top,Left,Height Width
    % do not carry position (that will be applied later)
     %print to clipboard
%     print(h(hidx),'-dmeta');
    figName = get(h(hidx),'Name'); %get Name

    
    %% LOOP: Parse Shape Name and command / Create Shape
    % setup Default Name if needed
    if (isnumeric(figStruct(hidx).Name) && figStruct(hidx).Name == -1) || isempty(figStruct(hidx).Name); 
        if ~isempty(figName)
            figStruct(hidx).Name = ['*pptWriteFigSL_' WrkSlide.Name '_SH_' figName];
        else
            numShapes = WrkSlide.Shapes.Count; 
            figStruct(hidx).Name = ...
                ['*pptWriteFigSL_' WrkSlide.Name 'SH_' num2str(numShapes+1)]; 
        end
    end
    % follow instructions for the ShapeName
    if ~any(strcmp(figStruct(hidx).Name(1), {'+','*','-'}))
        figStruct(hidx).Name = ['*' figStruct(hidx).Name]; %default case
    elseif length(figStruct(hidx).Name) == 1
        error('only a instruction but no name givin?  what is that?'); 
    end
    % follow instruction for name
    switch figStruct(hidx).Name(1)
        case '+' %ONLY append (error if exists
            for i=1:WrkSlide.Shapes.Count %sucks but i can't find a better positive check... 
                if strcmp(WrkSlide.Shapes.Item(1).Name,figStruct(hidx).Name(2:end))
                    error([mfspc '>> ERROR: a shape with the name ' figStruct(hidx).Name(2:end) ' already exists on Slide ' num2str(WrkSlide.Number) ' named: ' WrkSlide.Name]);
                end
            end
        case '*' %default case
            try % if shape is already on slide
                WrkShape = WrkSlide.Shapes.Item(figStruct(hidx).Name(2:end)); 
                FigZpos = WrkShape.ZOrderPosition;
                if ~figStruct(hidx).ForcePos
                    figStruct(hidx).Position = [WrkShape.Top WrkShape.Left WrkShape.Height WrkShape.Width]; 
                end
                % Delete old figure
                WrkShape.Delete;
            catch  %doesn't exist so create below
                % 
            end
                
        case '-' %better exist already
            WrkShape = WrkSlide.Shapes.Item(figStruct(hidx).Name(2:end)); 
            FigZpos = WrkShape.ZOrderPosition;
            if ~figStruct(hidx).ForcePos
                figStruct(hidx).Position = [WrkShape.Top WrkShape.Left WrkShape.Height WrkShape.Width]; 
            end
            % Delete old figure
            WrkShape.Delete;
        otherwise
            error('How did you get here? (figName)');
    end
    %% LOOP: Write new Figure
    try 
        set(h(hidx),'Position',[0    0   figStruct(hidx).Position(4)   figStruct(hidx).Position(3)]);
        print(h(hidx),'-dmeta'); %print to clipboard
        WrkShape = invoke(WrkSlide.Shapes,'Paste'); %paste into slide
        WrkShape.Name = figStruct(hidx).Name(2:end); %assign name
        if exist('FigZpos','var') % if we read a figZpos write it, otherwise ignore..
            WrkShape.ZOrder(1);  % send to back
            for ii = 1:(FigZpos-1) % bring fwd FigZpos times
                WrkShape.ZOrder('msoBringForward');  
            end
        end
    catch FailedWrite
        disp([mfnam '>> ERROR: couldn''t write new figure... '])
        disp([mfspc '>> Close file without saving to not loose data']);
        error([mfnam '>>ERROR: invalid write'])
    end
    %Perform Reshaping on curent WrkShape.
    WrkShape.Top = figStruct(hidx).Position(1); %position and resize
    WrkShape.Left = figStruct(hidx).Position(2);
    WrkShape.Height = figStruct(hidx).Position(3);
    WrkShape.Width = figStruct(hidx).Position(4);
    
    %% Add/Modify Text of Title
    if isfield(figStruct(hidx),'Title') && pptVer == 12
        if strcmp(WrkSlide.Shapes.HasTitle,'msoTrue')
            WrkSlide.Shapes.Title.TextFrame.TextRange.Text = figStruct(hidx).Title;
        elseif strcmp(WrkSlide.Layout,'ppLayoutBlank')
            WrkSlide.Layout = 'ppLayoutTitleOnly';
            WrkSlide.Shapes.Title.TextFrame.TextRange.Text = figStruct(hidx).Title;
        else
            WrkSlide.Shapes.AddTitle;
            WrkSlide.Shapes.Title.TextFrame.TextRange.Text = figStruct(hidx).Title;
        end
    end
    
    %% LOOP: Return Fig Properties
    %Put back how it was.
    set(h(hidx), 'PaperPositionMode', PaperPositionMode); %replace
    set(h(hidx), 'Position', Position); %replace position
    set(h(hidx), 'WindowStyle', docked); %put back to what it was.
    set(h(hidx), 'InvertHardCopy', InvertHardCopy);
    set(h(hidx), 'Color', Color); 
    
    %% LOOP: Save File
    op.Save; % save file
    
end% h loop
if ~wasopen
    op.Close;  % Close file
end
if ppt.Presentations.Count == 0;
    ppt.Quit; 
end
delete(ppt); %close link;


%% Outputs 

pptWriteStruct=struct('pptFileName', filename,...
                      'figHandles', h,...
                      'figStruct', figStruct);

%% Return 
end %pptWriteFig 


%% Subroutine FindSlide_Shape
function [Slide] = FindSlide_Shape(op,ShapeNames)
% Function returns the slide name/number thta contains a shape of name
% 'name'

if nargin ~= 2
    error('must have two args');
end
%TODO test op to be a presentation...
if ischar(ShapeNames)
    ShapeNames = cellstr(ShapeNames); %create cell array of strings
end
if ~iscellstr(ShapeNames)
    error('improper name input charater array or cellstring array');
end
%default value (Can't find -> append)
Slide = cell(length(ShapeNames)); 
for i=1:length(ShapeNames)
    Slide{i} = Inf;
end

for i=1:op.Slides.Count %TODO: Read from back to front so that returns FIRST instance
    for j=1:op.Slides.Item(i).Shapes.Count %TODO: Read from last to first to return FIRST instance
        TF = strcmp(op.Slides.Item(i).Shapes.Item(j).Name,ShapeNames);
        TFidx = find(TF); %Returns index of Name that was found
        if ~isempty(TFidx) 
            if isempty(op.Slides.Item(i).Name)
                Slide{TFidx} = i;
            else
                Slide{TFidx} = op.Slides.Item(i).Name;
            end
        end %if ~isempty
    end %loop through shapes
end % loop through slides

if length(Slide) == 1
    Slide = Slide{1};
end


end %FindSlideShape
%% Subroutine: GetShapePosition
%TODO Perhaps this shoudl be a subroutine (called by pptSet too) 
%
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
    row = fix((thisPlot-1)/ncols) ; %zero indexed
    col = rem (thisPlot-1, ncols); %zero indexed
  
    % compute outerposition and insets relative to figure bounds
    width = def_pos(4)/(ncols);
    height = def_pos(3)/(nrows);
    Position = [def_pos(1) + row*height,...
                def_pos(2) + col*width, ...
                height,  width];
end %Function GetShapePosition!

%% Revision History
% YYMMDD INI: note
% TODO: Groups are going to be brutal... 
% TODO: Title Field for Slides (overwrite existing ? ) - I think maybe this
% should be done in the pptSet function? Perhaps if the figstruct has a
% field 'Title' then just call pptSet(SlideObject,'Title',arg)? after a
% successful shape write? 
% TODO: SubTitleField ? 

% 091207 HCP: added simple functionality to rewrite slide Title text.
% 091028 HCP: made default file format dependent on what version of
%             PowerPoint is being used. Added error statements for when
%             user defines a bad file extension for their current version
%             of PowerPoint.
% 091026 HCP: made ".pptx" default file format. Overwriting issue does not
%        occur if files are saved as ".pptx" Still not sure why it
%        overwrites for .ppt though.
% 090908 TKV: Make PowerPoint 2007 compatible... (still backwards compatible i think) 
%   http://www.mathworks.com/support/solutions/en/data/1-8KUNW3/?solution=1-8KUNW3
% 090122 TKV: Changed default layout to ppLayoutText (same as by hand)
%       More cleanup and making notes... 
%       -Fixed bug using "==" for string compare... replaced with 'strcmp'
% 080925 REB: Fixed ZOrder bug -- now puts shape in correct Zposition
% 080917 TKV: Small cleanup to help / incorporated pptGet note. 
% 080915 TKV: cleaned up and fixed -> debugging... made Position a vector
% added abiliyt to leave file open and grab open presentation
% 080914 TKV: was printing hidx, instead of h(hidx)! Corrected transfer of
% size properties
% 080913 TKV: updated to allow vector forms, backwards compatibility, match
% Z order, improvd program flow.  
% 080912 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  PhoneNum 
% HCP: Hien C. Pham : hien.c.pham@ngc.com
% TKV: Travis K. Vetter : travis.vetter@ngc.com

%% Footer
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.

% --------------- Nothrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------

