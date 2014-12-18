% SHOWDEPENDENCE generates figure showing dependence between functions
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% showDependence:
%   generates and displays a postscript figure showing the dependence
%   between the functions called by FUN
%
%  A good calling syntax is just 
%   >> showDependence FUN
% SYNTAX:
%	[out] = showDependence(In1, varargin, 'PropertyName', PropertyValue)
%	[out] = showDependence(In1, varargin)
%	[out] = showDependence(In1)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	In1 	     <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	out 	     <size>		<units>		<Description> 
%
% NOTES:
%
%  Known problems: 
%   1. some variables can be mistaken as functions
%      This is a limitation of Matlab function depfun. For example, 
%      depfun seems to treat arg1 and arg2 in a function call
%      func(arg1, arg2) as functions, which they can be. So, in the
%      reported used function list and the diagram, there could be more
%      functions than actually used. One way to reduce such errors is to
%      avoid using names for variables that could also be a script name.
% 
%   2. Sometimes the EPS file does not exist when gv is called. In such
%      cases, gv needs to be called manually.
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[out] = showDependence(In1, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[out] = showDependence(In1)
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
%	Source function: <a href="matlab:edit showDependence.m">showDependence.m</a>
%	  Driver script: <a href="matlab:edit Driver_showDependence.m">Driver_showDependence.m</a>
%	  Documentation: <a href="matlab:pptOpen('showDependence_Function_Documentation.pptx');">showDependence_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/466
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/showDependence.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [out] = showDependence(In1, varargin)

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
% out= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        In1= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:

[trace_list, BUILTINS, CLASS_NAMES, PROB_FILES, PROB_SYMBOLS,...
	EVAL_STRINGS, called_from, JAVA_CLASSES] = depfun(varargin{:},...
	'-quiet');

% the matlab root directory -- used to distinguish system functions
matlabRootDir = matlabroot;

for i=1:length(trace_list)
	name=trace_list{i};
	if ~isempty(strmatch(matlabRootDir, name))
		% trace_list{i}='system functions';
		isUserFunc(i)=0; % not a user function
	else
		[path basename ext]=fileparts(name);
		trace_list{i}=[basename ext];
		isUserFunc(i)=1; % is a user function
	end
end

% prepare the .dot source file
filecontent=''; 
used=zeros(1, length(trace_list));

% first line of the dot file
filecontent=sprintf('digraph dependence {\n');

%make sure there is at least one node. also make the top function a box
filecontent=sprintf('%s\t"%s" [shape=box];\n', filecontent, trace_list{1});
used(1)=1; 

for i=2:length(trace_list)
	if isUserFunc(i)
		name=trace_list{i};
		callers=called_from{i};
		for j=1:length(callers)
			if isUserFunc(callers(j))
				if callers(j) == 0
					caller=trace_list{1}; % the top function name
				else
					caller=trace_list{callers(j)};
				end

				% write the link if not written before
				newedge=sprintf('\t"%s" -> "%s";', caller, name);
				if isempty(strfind(filecontent, newedge))
					filecontent=sprintf('%s%s\n', filecontent, newedge);
					used(i)=1; 
					used(callers(j))=1; 
				end
			end
		end
	end
end

filecontent=sprintf('%s}\n', filecontent); % end of .dot file content

% write the dot file
tempdotfile = [tempname '.dot'];
file = fopen(tempdotfile, 'w');
fprintf(file, '%s', filecontent); 
fclose(file);

% print a list of used files
num_mex = 0;  % first count the number of mex functions
for i=1:length(trace_list)
	if used(i)
		num_mex=num_mex+~isempty(findstr(trace_list{i}, mexext)); 
	end
end

if num_mex==0
	fprintf('\n\nThe following files are used:\n'); 
else
	fprintf('\n\nThe following files are used (including %d mex files):\n',...
		num_mex); 
end
for i=1:length(trace_list)
	if used(i)
		name=which(trace_list{i});
		fprintf('%s\n', name); 
	end
end

% generate the figure
tempfig = [tempname '.eps'];
eval(['!dot -Tps ' tempdotfile ' -o ' tempfig]);
% eval(['!rm ' tempdotfile]);

pause(2); % wait two seconds for the file to be written 

if exist(tempfig, 'file')>0
	eval(['!gv ' tempfig]); 
	eval(['delete ' tempfig]);
else
	fprintf('\nRun the command "!gv %s" to see the resulting eps file',...
		tempfig); 
end

fprintf('\nThe temparary .dot file is %s\n\n', tempdotfile); 


%% Compile Outputs:
%	out= -1;

end % << End of function showDependence >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
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
