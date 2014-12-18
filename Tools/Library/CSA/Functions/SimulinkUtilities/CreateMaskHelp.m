% CREATEMASKHELP creates a .html help file for masked systems
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CreateMaskHelp:
%     Creates a basic .html help file for masked subsystems containing both
%     inputs and outputs.  HTML file is created in current directory.
% 
% Inputs - h_block: handle of masked system to create help document for
%		 
% Output - MaskInfo: structure containing sections used to build up
%                    .html file for Mask
%        %
% <any additional informaton>
%
% Example:
%	[MaskHTML MaskInfo] = CreateMaskHelp(h_block,destination);
%            [MaskHTML] = CreateMaskHelp(h_block,destination);
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/67
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Informaton At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/SimulinkUtilities/CreateMaskHelp.m $
% $Rev:: 1726                                                 $
% $Date:: 2011-05-11 19:02:15 -0500 (Wed, 11 May 2011)        $

function [MaskInfo] = CreateMaskHelp(h_block)

%% General Header 
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
mfnam = mfilename;
mfspc = char(ones(1,length(mfnam))*spc);

%% Arg conditioning
MaskOnOff = get_param(h_block,'Mask');
if strcmp(MaskOnOff,'on')
    %nop
else
    error('Selected block does not contain a mask');
end
MaskInfo.FromBlock.MaskParams = get_param(h_block,'MaskPrompts');
MaskInfo.FromBlock.BlockName  = get_param(h_block,'Name');
ports = get_param(h_block,'Ports');
MaskInfo.FromBlock.Inputs     = ports(1);
MaskInfo.FromBlock.Outputs    = ports(2);

%% Build HTML header
%  Defines font style for titles and subtitles
%  Places block name into header
MaskInfo.Header = ['<HTML>' endl endl '<HEAD>' endl...
'<STYLE TYPE="text/css">' endl...
'<!--' endl...
'BODY' endl...
'   {' endl...
'   font-family:arial;' endl...
'   }' endl...
'-->' endl...
'</STYLE>' endl...
'<STYLE TYPE="text/css">' endl...
'<!--' endl...
'H1' endl...
'   {' endl...
'   font-family:arial;' endl...
'   color:#990000;' endl...
'   font-size:150%;' endl...
'   font-style:bold;' endl...
'   }' endl...
'-->' endl...
'</STYLE>' endl...
'<STYLE TYPE="text/css">' endl...
'<!--' endl...
'H2' endl...
'   {' endl...
'   font-family:arial;' endl...
'   color:#990000;' endl...
'   font-size:125%;' endl...
'   font-style:bold;' endl...
'   }' endl...
'-->' endl...
'</STYLE>' endl...
'<H1>' MaskInfo.FromBlock.BlockName '</H1>' endl...
'</HEAD>' endl endl endl '<BODY>' endl endl];

%% Setup Description
MaskInfo.Description.Title = ['<H2>Description</H2>' endl];
MaskInfo.Description.Endline = ['<BR>' endl endl];

%% Setup Parameters
MaskInfo.Parameters.Title = ['<DL><H2>Mask Parameters</H2>' endl];
for paramIdx = 1:length(MaskInfo.FromBlock.MaskParams)
    MaskInfo.Parameters.Names{paramIdx} = ['<DT><B>' MaskInfo.FromBlock.MaskParams{paramIdx} '</B>' endl]; 
end
MaskInfo.Parameters.Endline = ['</DL>' endl endl];

%% Setup Inputs
MaskInfo.Inputs.Title = ['<DL><H2>Inputs</H2>' endl];
for inputIdx = 1:MaskInfo.FromBlock.Inputs
    MaskInfo.Inputs.Names{inputIdx} = ['<DT><B>Input Port ' num2str(inputIdx) '</B>' endl]; 
end
MaskInfo.Inputs.Endline = ['</DL>' endl endl];

%% Setup Outputs
MaskInfo.Outputs.Title = ['<DL><H2>Outputs</H2>' endl];
for outputIdx = 1:MaskInfo.FromBlock.Outputs
    MaskInfo.Outputs.Names{outputIdx} = ['<DT><B>Output Port ' num2str(outputIdx) '</B>' endl]; 
end
MaskInfo.Outputs.Endline = ['</DL>' endl endl];

%% Setup Authors
MaskInfo.Author.Title = ['<H2>Authors</H2>' endl 'Block created/updated by: <BR>' endl];
MaskInfo.Author.Endline = ['<BR><BR>' endl endl];

%% Build Footer
today = date;
MaskInfo.Foot.Title = ['&copy; Northrop Grumman Corp ' today(end-3:end) endl];
MaskInfo.Foot.Endline = ['</BODY>' endl '</HTML>'];

%% Ask for descriptions
fh = figure();
set(fh,'Name','HTML Help Builder; Do not close manually.');
% Block Description Panel
dph = uipanel('Parent',fh,'Title','Block Description','Position',[0 .75 1 .25]);
MaskInfo.Description.dh = uicontrol('Parent',dph,'Style','edit',...
                                    'HorizontalAlignment','left','String','{BLOCK DESCRIPTION HERE}',...
                                    'Units','normalized','Position',[0 0 1 1],'Max',2,'Min',0);
% Parameter Description Panel
pph = uipanel('Parent',fh,'Title','Parameter Descriptions','Position',[0 .25 1/3 .5]);
for paramIdx = 1:length(MaskInfo.FromBlock.MaskParams)
    ppph(paramIdx)=uipanel('Parent',pph,'Title',MaskInfo.FromBlock.MaskParams{paramIdx},...
                           'Position',[0 1-(paramIdx)/length(MaskInfo.FromBlock.MaskParams) 1 1/length(MaskInfo.FromBlock.MaskParams)]); %#ok<AGROW>
    MaskInfo.Parameters.ph(paramIdx)=uicontrol('Parent',ppph(paramIdx),'Style','edit',...
                                               'HorizontalAlignment','left','String','{PARAMETER DESCRIPTION HERE}',...
                                               'Units','normalized','Position',[0 0 1 1],'Max',2,'Min',0);
end
% Input Description Panel
iph = uipanel('Parent',fh,'Title','Input Descriptions','Position',[1/3 .25 1/3 .5]);
for inputIdx = 1:MaskInfo.FromBlock.Inputs
    ipph(inputIdx)=uipanel('Parent',iph,'Title',['Input Port ' num2str(inputIdx)],...
                           'Position',[0 1-(inputIdx)/MaskInfo.FromBlock.Inputs 1 1/MaskInfo.FromBlock.Inputs]); %#ok<AGROW>
    MaskInfo.Inputs.ih(inputIdx)=uicontrol('Parent',ipph(inputIdx),'Style','edit',...
                                           'HorizontalAlignment','left','String','{INPUT DESCRIPTION HERE}',...
                                           'Units','normalized','Position',[0 0 1 1],'Max',2,'Min',0);
end
% Output Description Panel
oph = uipanel('Parent',fh,'Title','Output Descriptions','Position',[2/3 .25 1/3 .5]);
for outputIdx = 1:MaskInfo.FromBlock.Outputs
    opph(outputIdx)=uipanel('Parent',oph,'Title',['Output Port ' num2str(outputIdx)],...
                           'Position',[0 1-(outputIdx)/MaskInfo.FromBlock.Outputs 1 1/MaskInfo.FromBlock.Outputs]); %#ok<AGROW>
    MaskInfo.Outputs.oh(outputIdx)=uicontrol('Parent',opph(outputIdx),'Style','edit',...
                                             'HorizontalAlignment','left','String','{OUTPUT DESCRIPTION HERE}',...
                                             'Units','normalized','Position',[0 0 1 1],'Max',2,'Min',0);
end
% Author Description Panel
aph = uipanel('Parent',fh,'Title','Author','Position',[0 0 .5 .25]);
anph = uipanel('Parent',aph,'Title','Name','Position',[0 2/3 1 1/3]);
MaskInfo.Author.anh  = uicontrol('Parent',anph,'Style','edit','Units','normalized',...
                                  'Position',[0 0 1 1],'HorizontalAlignment','left','String','First Last');
aeph = uipanel('Parent',aph,'Title','Email','Position',[0 1/3 1 1/3]);
MaskInfo.Author.aeh  = uicontrol('Parent',aeph,'Style','edit','Units','normalized',...
                                  'Position',[0 0 1 1],'HorizontalAlignment','left','String','email@something.com');
apph = uipanel('Parent',aph,'Title','Phone','Position',[0 0 1 1/3]);
MaskInfo.Author.afh  = uicontrol('Parent',apph,'Style','edit','Units','normalized',...
                                  'Position',[0 0 1 1],'HorizontalAlignment','left','String','123-456-7890');

% Create HTML
hph = uipanel('Parent',fh,'Position',[.5 0 .5 .25]);
hh  = uicontrol('Parent',hph,'String','Create Help','Units','normalized','Position',[0 0 1 1],'Callback',{@buildHTML, MaskInfo});
user_entry = menu(['close HTML Help Builder?' endl 'Do not close manually.'],'Close');
if user_entry
    MaskInfo = get(hh,'UserData');
    close(fh);
end

% Add link to HTML file to help field in block mask
set_param(h_block,'MaskHelp',['web(' '''' cd '\' MaskInfo.FromBlock.BlockName '.html' ''', ''-helpbrowser'''  ')']);

%% Return
return;

% PushButton callback on GUI that builds HTML document
function buildHTML(hObject,eventInfo,MaskInfo)
%% Header
endl = sprintf('\n');

%% Read GUI
% reads block description
MaskInfo.Description.Description = [];
Dstring = get(MaskInfo.Description.dh,'String');
for line = 1:size(Dstring,1)
    MaskInfo.Description.Description = [MaskInfo.Description.Description Dstring(line,:) '<BR>' endl];
end
MaskHTML = MaskInfo.Header;
MaskHTML = [MaskHTML MaskInfo.Description.Title...
            MaskInfo.Description.Description...
            MaskInfo.Description.Endline];
        
% reads parameters
if size(MaskInfo.FromBlock.MaskParams,1) > 0
    MaskHTML = [MaskHTML MaskInfo.Parameters.Title];
    for paramIdx = 1:length(MaskInfo.FromBlock.MaskParams)
        MaskInfo.Parameters.Descriptions{paramIdx} = '<DD>';
        Pstring = get(MaskInfo.Parameters.ph(paramIdx),'String');
        for line = 1:size(Pstring,1)
            MaskInfo.Parameters.Descriptions{paramIdx} = [MaskInfo.Parameters.Descriptions{paramIdx} Pstring(line,:) '<BR>'  endl];
        end
        MaskHTML = [MaskHTML MaskInfo.Parameters.Names{paramIdx}...
            MaskInfo.Parameters.Descriptions{paramIdx}]; %#ok<AGROW>
    end
    MaskHTML = [MaskHTML MaskInfo.Parameters.Endline];
else
    %nop
end

%reads inputs
if MaskInfo.FromBlock.Inputs > 0
    MaskHTML = [MaskHTML MaskInfo.Inputs.Title];
    for inputIdx = 1:MaskInfo.FromBlock.Inputs
        MaskInfo.Inputs.Descriptions{inputIdx} = '<DD>';
        Istring = get(MaskInfo.Inputs.ih(inputIdx),'String');
        for line = 1:size(Istring,1)
            MaskInfo.Inputs.Descriptions{inputIdx} = [MaskInfo.Inputs.Descriptions{inputIdx} Istring(line,:) '<BR>'  endl];
        end
        MaskHTML = [MaskHTML MaskInfo.Inputs.Names{inputIdx}...
            MaskInfo.Inputs.Descriptions{inputIdx}]; %#ok<AGROW>
    end
    MaskHTML = [MaskHTML MaskInfo.Inputs.Endline];
else
    %nop
end

%reads outputs %TODO: make compatible with carriages return
if MaskInfo.FromBlock.Outputs >0
    MaskHTML = [MaskHTML MaskInfo.Outputs.Title];
    for outputIdx = 1:MaskInfo.FromBlock.Outputs
        MaskInfo.Outputs.Descriptions{outputIdx} = '<DD>';
        Ostring = get(MaskInfo.Outputs.oh(outputIdx),'String');
        for line = 1:size(Ostring,1)
            MaskInfo.Outputs.Descriptions{outputIdx} = [MaskInfo.Outputs.Descriptions{outputIdx} Ostring(line,:) '<BR>' endl];
        end
        MaskHTML = [MaskHTML MaskInfo.Outputs.Names{outputIdx}...
            MaskInfo.Outputs.Descriptions{outputIdx}]; %#ok<AGROW>
    end
    MaskHTML = [MaskHTML MaskInfo.Outputs.Endline];
else
    %nop
end

%reads authors
MaskHTML = [MaskHTML MaskInfo.Author.Title];
MaskInfo.Author.Name=[get(MaskInfo.Author.anh,'String') '<BR>' endl];
MaskInfo.Author.Email=[get(MaskInfo.Author.aeh,'String') '<BR>' endl];
MaskInfo.Author.Phone=[get(MaskInfo.Author.afh,'String') '<BR>' endl];
MaskHTML = [MaskHTML MaskInfo.Author.Name...
            MaskInfo.Author.Email...
            MaskInfo.Author.Phone];
MaskHTML = [MaskHTML MaskInfo.Author.Endline];
MaskHTML = [MaskHTML MaskInfo.Foot.Title...
            MaskInfo.Foot.Endline];
MaskInfo.MaskHTML = MaskHTML;
set(hObject,'UserData', MaskInfo);

%% Write to file
fid = fopen([MaskInfo.FromBlock.BlockName '.html'],'w+');
if fid == -1
    error('Invalid Block Name');
end
fwrite(fid, MaskInfo.MaskHTML);
fclose(fid);

return
%% Revision History
% YYMMDD INI: note
% 081111 HCP: Original Author
% 081111 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% HCP: Hien Pham : hien.pham2 : phamhi2
% INI: FullName  :  Email  :  NGGN Username 
% <ini>: <Fullname> : <email> : <NGGN username> 

%% Footer
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------

