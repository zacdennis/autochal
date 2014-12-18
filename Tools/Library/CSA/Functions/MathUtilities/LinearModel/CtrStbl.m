% CTRSTBL Calculate controllability and stabilizability using modes
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% CtrStbl:
%     <Function Description> 
% 
% SYNTAX:
%	[CtrStblFlag, outcell] = CtrStbl(A, B)
%
% INPUTS: 
%	Name       	Size		Units		Description
%	A   	    <size>		<units>		<Description>
%	B   	    <size>		<units>		<Description>
%
% OUTPUTS: 
%	Name       	Size		Units		Description
%	CtrStblFlag	[1x2]		<units>		Flag if system is detectable for
%                                       all w 
%                                       [ControllableFlag StabilizableFlag]
%	outcell	    <size>		<units>		A cell array listing modes of the 
%                                       systems.
%                                       {Mode{i}, ConditionNumber{i},
%                                       CtrlFlag{i}, StblFlag{i}} 
%
% NOTES:
%	<Any Additional Information>
%
% EXAMPLES:
%	% <Enter Description of Example #1>
%	[CtrStblFlag, outcell] = CtrStbl(A, B, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[CtrStblFlag, outcell] = CtrStbl(A, B)
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
%	Source function: <a href="matlab:edit CtrStbl.m">CtrStbl.m</a>
%	  Driver script: <a href="matlab:edit Driver_CtrStbl.m">Driver_CtrStbl.m</a>
%	  Documentation: <a href="matlab:pptOpen('CtrStbl_Function_Documentation.pptx');">CtrStbl_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/41
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/LinearModel/CtrStbl.m $
% $Rev: 1715 $
% $Date: 2011-05-11 16:30:05 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [CtrStblFlag, outcell] = CtrStbl(A, B)

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
CtrStblFlag= -1;
outcell= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        B= ''; A= ''; 
%       case 1
%        B= ''; 
%       case 2
%        
%       case 3
%        
%  end
%
%  if(isempty(B))
%		B = -1;
%  end
%% Main Function:

[vectors,modes,cond]=condeig(A);
nm=length(modes);
n=size(A);
j=sqrt(-1);

disp('Working');linewidth=get(0,'CommandWindowSize');

for i=1:nm
	 
	%Subcode to print dots...
	 disp(sprintf('\b%s','.')); % or fprintf('.');
	 if 0==mod(i,linewidth(1)-8)
		disp(' '); %add line break for kicks... fprintf('\n')
	 end;
	 
    w=modes(i,i);
    outcell{i,1}=w;
    mat=j*w*eye(n)-A;
    mat=[mat B];
    %The next 5 line replicate the Cond function and Rank function but only
    %performs the SVD once.. 
    SingValues=svd(mat);
    %Modified from Cond Function	 
	 if any(SingValues == 0)   % Handle singular matrix
		outcell{i,2} = Inf(class(mat));
	 else
		outcell{i,2} = max(SingValues)./min(SingValues);
	 end
    tol = max(size(mat))*eps(max(SingValues));
    rn = sum(SingValues > tol);   %this is the matlab Rank function 
        
    outcell{i,4}=0;
    if rn==n
        outcell{i,3}=1; %Controllable at this mode
        outcell{i,4}=1; %if Controllable then stabilizable
    else
        outcell{i,3}=0; %not Controllable at this mode
        if w<0; %mode is stable
            outcell{i,4}=1; %it is stabilizable
        else 
            outcell{i,4}=0; %it is UNstabilizable
        end;
    end;
   
end%for
CtrStblFlag(1)=floor(sum(cell2mat(outcell(:,3)))/length(outcell));
CtrStblFlag(2)=floor(sum(cell2mat(outcell(:,4)))/length(outcell));

%% Compile Outputs:
%	CtrStblFlag= -1;
%	outcell= -1;

end % << End of function CtrStbl >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101022 JPG: Copied over information from the old function.
% 101022 CNF: Function template created using CreateNewFunc
% Created by Travis Vetter.
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
