% SS2MKSYS function to convert form ss to a mksys type...
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ss2mksys:
%     function to convert form ss to a mksys type 
% *************************************************************************
% * #NOTE: To future COSMO'er, this warning appeared using CreateNewFunc
% * CreateNewFunc>>WARNING: Selected Input argument name: "type" is a 
% * function name!
% * -JPG
% *************************************************************************
% 
% SYNTAX:
%	[tss, outstruct] = ss2mksys(sys, IOcell, type)
%	[tss, outstruct] = ss2mksys(sys, IOcell)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	sys 	    <size>		<units>		sys in ssform
%	IOcell	   {indist_str,             indist_str sting index of b matrix 
%               inCtrl_str,             to take as disturbance inputs....
%               outCost_str, 
%               outSens_str}		
%	type	    string		<units>		(see help mksys) default is
%                                       'tss'
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	tss 	    <size>		<units>		<Description> 
%	outstruct	<size>		<units>		<Description> 
%
% NOTES:
%plant  xd=  A(x) +  b1(dist) +  b2(ctrl)
%cost    z= C1(x) + d11(dist) + d12(ctrl)
%sensor  y= C2(x) + d21(dist) + d22(ctrl)
%
%	VARARGIN PROPERTIES:
%	PropertyName		PropertyValue	Default		Description
%	<PropertyName>		<units>			<Default>	<Description>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[tss, outstruct] = ss2mksys(sys, IOcell, type, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[tss, outstruct] = ss2mksys(sys, IOcell, type)
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
%	Source function: <a href="matlab:edit ss2mksys.m">ss2mksys.m</a>
%	  Driver script: <a href="matlab:edit Driver_ss2mksys.m">Driver_ss2mksys.m</a>
%	  Documentation: <a href="matlab:pptOpen('ss2mksys_Function_Documentation.pptx');">ss2mksys_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/35
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ss2mksys.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [tss, outstruct] = ss2mksys(sys, IOcell, type)

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
% tss= -1;
% outstruct= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        type= ''; IOcell= ''; sys= ''; 
%       case 1
%        type= ''; IOcell= ''; 
%       case 2
%        type= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(type))
%		type = -1;
%  end
%% Main Function:
if nargin~=3
    disp('wrong number of arguments')
    tss='error'; outstruct=[];
    return;
end
%get plant
outstruct.a=sys.a;

%get b's
eval(['outstruct.b1=sys.b(:,' char(IOcell(1)) ');']);
eval(['outstruct.d11=sys.d(' char(IOcell(3)) ',' char(IOcell(1)) ');']); %Get d11
if isempty(IOcell{2})
    eval(['outstruct.b2 = [];']);
    eval(['outstruct.d12= [];']); %set d12
else
    eval(['outstruct.b2=sys.b(:,' char(IOcell(2)) ');']);
    eval(['outstruct.d12=sys.d(' char(IOcell(3)) ',' char(IOcell(2)) ');']);%set d12
end;

%get C's
eval(['outstruct.c1=sys.c(' char(IOcell(3)) ',:);']);
if isempty(IOcell{4});
    eval(['outstruct.c2 = [];']);
    eval(['outstruct.d21= [];']);
else 
    eval(['outstruct.c2=sys.c(' char(IOcell(4)) ',:);']);
    eval(['outstruct.d21=sys.d(' char(IOcell(4)) ',' char(IOcell(1)) ');']);
end;

%get D's
if isempty(IOcell{2}) || isempty(IOcell{2})
    eval(['outstruct.d22 = [];']);
else 
    eval(['outstruct.d22=sys.d(' char(IOcell(4)) ',' char(IOcell(2)) ');']);
end;

%build mksys mode
tss=mksys(outstruct.a,outstruct.b1,outstruct.b2,outstruct.c1,outstruct.c2,outstruct.d11,outstruct.d12,outstruct.d21,outstruct.d22,type);


%% Compile Outputs:
%	tss= -1;
%	outstruct= -1;

end % << End of function ss2mksys >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101025 JPG: Copied over information from the old function.
% 101025 CNF: Function template created using CreateNewFunc
% 040101 TKV: Created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720  
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
