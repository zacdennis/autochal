% LTIVARNOTES list all LTI systems in workspace and their memo filed
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% LTIVarNotes:
%     Function lists all Lti Systems in workspace with there memo field IO
%   names
% SYNTAX:
%	[WsLtiInfo] = LTIVarNotes(displayme)
%
% INPUTS: 
%	Name     	Size            Units		Description
%	displayme	[1]             [boolean]	0 or 1 to display shortened 
%                                           form.
%
% OUTPUTS: 
%	Name     	Size            Units		Description
%	WsLtiInfo	{cell array}	<units>		{varnam, memo, innames,
%                                           outnames}
%
% NOTES:
%	<Any Additional Information>
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[WsLtiInfo] = LTIVarNotes(displayme, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[WsLtiInfo] = LTIVarNotes(displayme)
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
%	Source function: <a href="matlab:edit LTIVarNotes.m">LTIVarNotes.m</a>
%	  Driver script: <a href="matlab:edit Driver_LTIVarNotes.m">Driver_LTIVarNotes.m</a>
%	  Documentation: <a href="matlab:pptOpen('LTIVarNotes_Function_Documentation.pptx');">LTIVarNotes_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/56
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/LinearModel/LTIVarNotes.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [WsLtiInfo] = LTIVarNotes(displayme)

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
WsLtiInfo= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        displayme= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:

NAME=1;
NOTES=2;
INPUTS=3;
OUTPUTS=4;

 if nargin==0;
     displayme=1;
 end

 
var=evalin('base','who;');

nvar=length(var);

outi=0;
for i=1:nvar
    islti=evalin('base',['isa(' var{i} ',''lti'');']);
    if islti==1
        outi=outi + 1; %increment outi
        WsLtiInfo{outi,NAME}=var{i};
%         var{i}
%         i
        WsLtiInfo{outi,NOTES}=evalin('base',[var{i} '.Notes;']);
        WsLtiInfo{outi,NOTES}=char(WsLtiInfo{outi,NOTES});
        %WsLtiInfo{outi,INPUTS}=evalin('base',[var{i} '.InputName;']);
        %WsLtiInfo{outi,OUTPUTS}=evalin('base',[var{i} '.OutputName;']);
    end;
end;

if outi==0; %if there are not lti variables
    disp([mfilename '>> No LTI objects found in workspace.']);
    WsLtiInfo=cell(0);
    return;
end;    
    
if displayme~=0;
     disp([mfilename '>> Your LTI objects in the workspace are: ']);
     disp('    LTI Vars            NotesField');
     disp('------------------------------------------------------');
     for i=1:size(WsLtiInfo,1)
%           if length(WsLtiInfo(i,2))==0
              
         s=sprintf('\t%-13s\t\t%s',(WsLtiInfo{i,1}),(WsLtiInfo{i,2}));
         disp(s);
%           disp(['    ' char(WsLtiInfo(i,1)) '    ' char(WsLtiInfo(i,2))]);
     end;
 end;
%% Compile Outputs:
%	WsLtiInfo= -1;

end % << End of function LTIVarNotes >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
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
