% OUTVARCLEAN Reassigns simulation variables
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% OutVarClean:
% this function is used to clean simulations.  
% It Checks to be sure the variable is there and then writes it to a
% defined structure
% INPUTS; 
%       toVar: the full name of the variable to write to as a string
%       frVar:    teh full name of the variable to be written as a string
%       DeleteFlag: a 1 or 0 which identifies whether the original variable
%       should be deleted from teh base workspace
% OUTPUT;
%       Flag: (-2 -1 0 1 2) 0: No problems, write performed as expected (Base
%       Variable exists
%                      1: No source found No Previous Value Found
%                      0: Source found,  Parent object found
%                     -1: Source Found New Parent Created.(Warning) 
%                     -2: No Source Found Previous Value at new Var Exists
% 
% SYNTAX:
%	[OutFlag] = OutVarClean(toVar, frVar, DeleteFlag, varargin, 'PropertyName', PropertyValue)
%	[OutFlag] = OutVarClean(toVar, frVar, DeleteFlag, varargin)
%	[OutFlag] = OutVarClean(toVar, frVar, DeleteFlag)
%	[OutFlag] = OutVarClean(toVar, frVar)
%
% INPUTS: 
%	Name      	Size		Units		Description
%	toVar	     <size>		<units>		<Description>
%	frVar	     <size>		<units>		<Description>
%	DeleteFlag	<size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name      	Size		Units		Description
%	OutFlag	   <size>		<units>		<Description> 
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
%	[OutFlag] = OutVarClean(toVar, frVar, DeleteFlag, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[OutFlag] = OutVarClean(toVar, frVar, DeleteFlag)
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
%	Source function: <a href="matlab:edit OutVarClean.m">OutVarClean.m</a>
%	  Driver script: <a href="matlab:edit Driver_OutVarClean.m">Driver_OutVarClean.m</a>
%	  Documentation: <a href="matlab:pptOpen('OutVarClean_Function_Documentation.pptx');">OutVarClean_Function_Documentation.pptx</a>
%
% See also ReportOutVarClean
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/39
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/OutVarClean.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [OutFlag] = OutVarClean(toVar, frVar, DeleteFlag, varargin)

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
% OutFlag= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        DeleteFlag= ''; frVar= ''; toVar= ''; 
%       case 1
%        DeleteFlag= ''; frVar= ''; 
%       case 2
%        DeleteFlag= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(DeleteFlag))
%		DeleteFlag = -1;
%  end
%% Main Function:
% Test for existance of frVar in base workspace
frVarExists=1; %assume frVarExists
%get frVar without parens
[frVarMP,parens]=stripParens(frVar);
evalin('base',[frVarMP ';'] ,'frVarExists = 0;');

% Test for existance of structure in toVar
s=strfind(toVar,'.');
Ndots=length(s);
if Ndots == 0 %toVar is not a structure
    ParentName{1}='';
    [ParentNameMP{1},parens]=stripParens(toVar);
elseif Ndots >=1 %toVar is in a deeper level
    ParentName{1}=toVar(1:s(1)-1);
    [ParentNameMP{1},parens]=stripParens(toVar(1:s(1)-1));
    for i=2:Ndots
        ParentName{i}=toVar(s(i-1)+1:s(i)-1); %Get Parent object strings (field names)
        [ParentNameMP{i},parens]=stripParens(toVar(s(i-1)+1:s(i)-1));
    end %for
else
    disp('Error in OutVarClean-293478')
end %if
    %ParentName=toVar(1:lastdot);
%now that we have teh parent names see if the master parent exists, then
%check the field names
%First Check master Parent
toVarParentExists=1; %assume it exists
toVarParentExists=evalin('base',['exist(''' ParentNameMP{1} ''');'],'toVarParentExists=0;');
NewStructName=ParentName{1};
NewStructNameMP=ParentNameMP{1}; %same as above
i=1;
while toVarParentExists==1 && i<= length(ParentName)-1
    toVarParentExists=evalin('base',['isfield(' NewStructNameMP ',''' ParentNameMP{i+1} ''');']);
    NewStructNameMP=[NewStructName '.' ParentNameMP{i+1}];
    NewStructName  =[NewStructName '.' ParentName{i+1}];
    i=i+1;
end %while

%now check to see if there is a previous value in the exact toVar place
if toVarParentExists==1
    %now check to see if the actuall variable already exists
    toVarExists=1; %assume toVarExists
    [toVarMP,parens]=stripParens(toVar);
    evalin('base',[toVarMP ';'] ,'toVarExists = 0;');
else 
    toVarExists=0;
end%if 



%set error flags and write variables.  
if      frVarExists &&  toVarParentExists %nominal no problem case
    OutFlag = 0;
    evalin('base',[toVar '=' frVar ';']);
elseif  frVarExists && ~toVarParentExists %Create New Parent
    OutFlag = -1;
    evalin('base',[toVar '=' frVar ';']);
elseif ~frVarExists &&  toVarExists %Can't find From variable, previous value exists
    OutFlag = -2;
    return ;
elseif ~frVarExists && ~toVarExists %can't find FromvVaribl, no previous value
    OutFlag = 1;
    return ;
else 
    OutFlag=-9; %%What happened?
end %if

% Delete frVar if requested 
if DeleteFlag==1
    evalin('base',['clear  ' frVarMP ';']);
end %if

%% Compile Outputs:
%	OutFlag= -1;

end % << End of function OutVarClean >>

function [outstr,parens]=stripParens(instr)
%removes parens from string
if nargin~=1 || isstr(instr)~=1
    routstr=''; parens='';
    return;
end

po=strfind(instr,'(');
pc=strfind(instr,')');
if length(po)==0 && length(pc)==0;
    outstr=instr;
    parens='';
    return;
end %if
if length(po)==length(pc)
    Balenced = 1;
    %find most outer set
    outstr=instr(1:po(1)-1);
    parens=instr(po(1):pc(end));
    return;
else
    outstr=instr
    parens='';
    disp('unbalenced parenthesis found')
    return;
end%if
disp('Problem number 23234');
end
%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
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
