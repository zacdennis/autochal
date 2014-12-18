% SYSSORT modifies states/outputs/inputs of SS models per a vector or list
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% SysSort:
%     <Function Description>
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "info" is a 
% * function name!
% * -JPG
% *************************************************************************
% 
% SYNTAX:
%	[outsys, info] = SysSort(Sys, varargin, 'PropertyName', PropertyValue)
%	[outsys, info] = SysSort(Sys, varargin)
%	[outsys, info] = SysSort(Sys)
%
% INPUTS: 
%	Name    	Size		Units		Description
%   Sys                                 A state-space LTI object
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	outsys                              A ss with all element corrected for 
%                                       new I/O/States 
%	info                                A structure with information about 
%                                       removed states/input/outputs or 
%                                       errors warnings.
%
% NOTES:
%		-Unnamed elements are named before modification x#/y#/u#
%		-Input pairs to the left of what you want must be included
%		-Omited Trailing pairs keep all.. 
%		-If you don't want to change something use 'r',[] or 'k',-1,
%		-[1:3 21:23 4:20 24 -1] = [1:3 21:23 4:20 24:end] 
%  Limitations:
%		-Can't handel "e" matrices... 
%
%	VARARGIN PROPERTIES:
%	PropertyName	PropertyValue	Default		Description
%	Sinst(opt)      {[S(ort)],K(eep),R(em)}     Sort/Keep/Remove the states 
%                                               listed in the next vector
%	States                                      Vector of state indices to 
%                                               sort/keep/remove
%	Oinst(opt)      {[S(ort)],K(eep),R(em)}     Sort/Keep/Remove the output
%                                               listed in the next vector
%	Outputs(opt)                                Vector of output indices to 
%                                               sort/keep/remove
%	Iinst(opt)      {[S(ort)],K(eep),R(em)}     Sort/Keep/Remove the inputs
%                                               listed in the next vector
%	Inputs(opt)                                 Vector of input indices to 
%                                               sort/keep/remove
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[outsys, info] = SysSort(Sys, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[outsys, info] = SysSort(Sys)
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
%	Source function: <a href="matlab:edit SysSort.m">SysSort.m</a>
%	  Driver script: <a href="matlab:edit Driver_SysSort.m">Driver_SysSort.m</a>
%	  Documentation: <a href="matlab:pptOpen('SysSort_Function_Documentation.pptx');">SysSort_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/27
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/SysSort.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [outsys, info] = SysSort(Sys, varargin)

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
%default output
outsys = [];
info.status{1} = [mfnam '>> Running...'];
% Check for ss type on input... 

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Sys= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
if ~isa(Sys,'SS')
	info.status{end+1,1} = ['>>ERROR: Input is not a State-Space!'];
	disp([mfnam info.status{end}]);
	return;
end;
%Create empty cells
ArgIn	= {-1,-1,-1,-1,-1,-1}; %sets up default read all
ArgSrt= cell(6,1);
%write what we have to a holding cell
for i=1:length(varargin)
	ArgIn(i) = varargin(i);
end;

InArgIdx = 1; %start with first argument and go through pairs...
for i=1:3
	%Get Instruction
	if ischar(ArgIn{InArgIdx}) 
		ArgSrt{2*i-1} = ArgIn{InArgIdx};
		InArgIdx = InArgIdx+1;
	else
		ArgSrt{2*i-1} = 'Sort'; %default;
	end;
	%get vector or name 
	if iscell(ArgIn{InArgIdx}) || isnumeric(ArgIn{InArgIdx})
		ArgSrt{2*i} = ArgIn{InArgIdx};
		InArgIdx = InArgIdx+1;
	else
		info.status{end+1,1} = [ '>>ERROR: Problem interpreting inputs,  i=' ...
										num2str(i) '; InputArg= ' num2str(InArgIdx+1)];
		disp([mfnam info.status{end}]);
		return;
	end;
end;

Sinst = ArgSrt{1};
States = ArgSrt{2};
Oinst = ArgSrt{3};
Outputs = ArgSrt{4};
Iinst = ArgSrt{5};
Inputs = ArgSrt{6};
%Error Checking
%ArgSrt 

%Check for valid input size / members
if iscell(States) &&  ~all(ismember(States,Sys.StateName))
		info.status{end+1,1} = [ '>>WARNING: Can not find all States Named:'];
		disp([mfnam info.status{end}]);
end
%Check output name list
if iscell(Outputs) && ~all(ismember(Outputs,Sys.OutputName))
		info.status{end+1,1} = [ '>>WARNING: Can not find all Outputs Named.'];
		disp([mfnam info.status{end}]);
end;
%Check input name list
if iscell(Inputs) && ~all(ismember(Inputs,Sys.InputName))
		info.status{end+1,1} = [ '>>WARNING: Can not find all Inputs Named.'];
		disp([mfnam info.status{end}]);
end;

%% Get Sizes of StateSpace
n=size(Sys,'order'); %n=number of states
[l,m] =size(Sys); % l = number of outputs; m = number of inputs

%% use current names on any empty name vectors.. 
%state vector
for i=1:n
	if isempty(Sys.StateName{i})
		Sys.StateName{i} = ['x' num2str(i)];
	end;
end;
%output vector
for i=1:l
	if isempty(Sys.OutputName{i})
		Sys.OutputName{i} = ['y' num2str(i)];
	end;
end;
%input vector
for i=1:m
	if isempty(Sys.InputName{i})
		Sys.InputName{i} = ['u' num2str(i)];
	end;
end;	

%% Determine State KeepSet 
if isnumeric(States) && States(end) == -1
	if length(States)==1
		States = [1:n]; 
	else
		info.status{end+1,1} = ['>>CAUTION:State:  Using a untested aspect of function'];
		disp([mfnam info.status{end}]);
		States = [States(1:end-2) States(end-1):n];
	end;
end;
if strcmpi(Sinst(1),'r')
	if iscell(States)
		[KeepStNames,KeepStIdx ]= setdiff(Sys.StateName,States);
	elseif isnumeric(States)
		KeepStIdx = setdiff(1:n,States);	KeepStNames = Sys.StateName(KeepStIdx);
		if length(States) == n;
			info.status{end+1,1} = ...
			 ['>>WARNING: Removing all the States! (k,-1 or r,[] to keep all)'];
			disp([mfnam info.status{end}]);
		end;
	else
		info.status{end+1} = ['>>ERROR: Could not remove 3rd arg: States'];
		disp([mfnam info.status{end}]);
		return;
	end
elseif strcmpi(Sinst(1),'k')
	if iscell(States)
		[KeepStNames,KeepStIdx] = intersect(Sys.StateName,States);			
	elseif isnumeric(States)
		KeepStIdx = sort(States); KeepStNames = Sys.StateName(KeepStIdx);
	else
		info.status{end+1,1} = ['>>ERROR: Could not Keep 3rd arg: States'];
		disp([mfnam info.status{end}]);
		return;
	end;
elseif any(strcmpi(Sinst(1),{'s','o'}));
	if iscell(States)
		[tr,KeepStIdx] = ismember(States,Sys.StateName);
		KeepStNames = Sys.StateName(KeepStIdx);
	elseif isnumeric(States)
		KeepStIdx = States; KeepStNames = Sys.StateName(KeepStIdx);
	else
		info.status{end+1,1} = ['>>ERROR: Could not Sort 3rd arg: States'];
		disp([mfnam info.status{end}]);
		return;
	end;
else
	info.status{end+1,1} = ...
				['>>ERROR: Could not interperet State manipulation istruction'];
	disp([mfnam info.status{end}]);
	return;
end;
%% Determine Output KeepSet
%Determin Keep Outputs
if isnumeric(Outputs) && Outputs(end) == -1
	if length(Outputs)==1
		Outputs = [1:l]; 
	else
		info.status{end+1,1} = ['>>CAUTION:Output:  Using a untested aspect of function'];
		disp([mfnam info.status{end}]);
		Outputs = [Outputs(1:end-2) Outputs(end-1):l];
	end;
end;
if strcmpi(Oinst(1),'r') %you want to remove the outputs listed
	if iscell(Outputs)
		KeepOutIdx = setdiff(Sys.OutputName,Outputs)
	elseif isnumeric (Outputs)
		KeepOutIdx = setdiff([1:l],Outputs);
		if length(Outputs) == l;
			info.status{end+1,1} = ...
				['>>WARNING: Removing all the outputs! (k,-1 or r,[] to keep all)'];
			disp([mfnam info.status{end}]);
		end;
	else
		info.status{end+1} = [ '>>ERROR: Can not understand 5th arg: Outputs. '];
		disp([mfnam info.status{end}]);
		return;
	end;	
elseif strcmpi(Oinst(1),'k')
	if iscell(Outputs); 
		KeepOutIdx = intersect(Sys.OutputName,Outputs);
	elseif isnumeric(Outputs)
		KeepOutIdx = sort(Outputs);
	else
		info.status{end+1,1} = [ '>> Could not understand "output"'];
		disp([mfnam info.status{end}]);
		return;
	end
elseif any(strcmpi(Oinst(1),{'s','o'}))
	KeepOutIdx = Outputs; %can be either a cell vector or a numeric vector
else
	info.status{end+1,1} = ...
		[ '>>Could not instructions for keep/rem output...:' Oinst];
	disp([mfnam info.status{end}]);
	return;
end;
%% Determine Input KeepSet
if isnumeric(Inputs) && Inputs(end) == -1
	if length(Inputs)==1
		Inputs = [1:m]; 
	else
		info.status{end+1,1} = ['>>CAUTION:Output:  Using a untested aspect of function'];
		disp([mfnam info.status{end}]);
		Inputs = [Inputs(1:end-2) Inputs(end-1):m];
	end;
end;
if strcmpi(Iinst(1),'r') 
	if iscell(Inputs) 
		KeepInIdx = setdiff(Sys.InputName,Inputs);
	elseif isnumeric(Inputs)
		KeepInIdx = setdiff([1:m],Inputs);
		if length(Inputs) == m ;	
			info.status{end+1,1} = ...
				['>>WARNING: Removing all the inputs! (k,-1 or r,[] to keep all)'];
			disp([mfnam info.status{end}]);
		end;
	else
		info.status{end+1,1} = [ '>>ERROR: Can not understand 7th arg: Input '];
		disp([mfnam info.status{end}]);
		return;
	end
elseif strcmpi(Iinst(1),'k')
	if iscell(Inputs);
		KeepInIdx = intersect(Sys.InputName,Inputs);
	elseif isnumeric(Inputs) ; 
		KeepInIdx = sort(Inputs);
	else
		info.status{end+1,1} = [ '>> Could not understand arg7,"Input" ...'];
		disp([mfnam info.status{end}])
		return;
	end
elseif any(strcmpi(Iinst(1),{'s','o'}));
	KeepInIdx = Inputs;
else
	info.status{end+1,1} = ...
		[ '>>Could not understand instructions for keep/rem input...:' Iinst];
	disp([mfnam info.status{end}]);
	return;
end;

%% Build new statespace
outsys = Sys(KeepOutIdx,KeepInIdx); %Trims I/O to Specified Names/Values
%transfers most of the information, GROUPS etc..but not notes or UserData...

%now correct number of states... 
a = outsys.a(KeepStIdx, KeepStIdx);
b = outsys.b(KeepStIdx,:);
c = outsys.c(:,KeepStIdx);
StateName = outsys.StateName(KeepStIdx);
set(outsys,'a',a,'b',b,'c',c,'StateName',StateName);

if ~isempty(Sys.notes);
	outsys.Notes = ['SysSort: ' Sys.notes];
end
outsys.UserData = Sys.UserData;

%% Finish Info Variable
if length(info.status) == 1 %NO extra notes generated... 
	info.status{1} = [mfnam '>> Completed With No Exceptions.'];
else
	info.status{end+1,1} = [mfnam '>> Finished...'];
end;
	info.KeepStIdx = KeepStIdx;
	info.KeepStNames = KeepStNames;
	info.KeepInIdx = KeepInIdx;
	info.KeepOutIdx= KeepOutIdx;

%% Compile Outputs:
%	outsys= -1;
%	info= -1;

return %end % << End of function SysSort >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
% 060509 TKV: (1.9) Added Check on input to verify it is a state space
%           model Moved this list to the bottom of the file
% 060310 TKV: (1.81) Correcte notes and a few non functional differences
% 060103 TKV: (1.8) Corrected bug with KeepStNames if 'R',vector used;
%               Corrected all previous comments to the proper Year...
% 051216 TKV: (1.7) Corrected N -1] error in vector generation 
% 051215 TKV: (1.6) Allowed a suffix input of -1 for "end" when numeric
%               vecotors used
% 051213 TKV: Modified to accept named inputs for removal/keep
% 051213 TKV: Modified 'k' to be in same order and added 's' option for
%               accepting your order
% 051206 TKV: Made Default behavior for unincluded inputs... 
% 051206 TKV: Made a k,-1 use all of that one...
% 051206 TKV: First working version
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             : Email                 : NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  : g61720 
% TKV: Travis Vetter

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
