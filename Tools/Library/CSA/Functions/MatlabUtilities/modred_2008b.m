% MODRED_2008B State elimination and order reduction from MATLAB 2008b
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% modred_2008b:
%   NOTE:  This function was copied from MATLAB 2008b to help facilitate
%           the reduction of linearized models.
%          This is to be used as a workaround for a bug discovered in
%          2009b.
%           Error Message:  "??? Error using ==> ss.modred at 71"
%                           "Input to SVD must not contain NaN or Inf."
%
%   This file was copied from:
%    C:\Program Files\MATLAB\R2008b\toolbox\control\control\@ss\modred.m
%   This file calls a support file, also called modred.m, found in the
%   ltipack folder.  That function has been renamed 'modred_2008b_B.m'.
%
%   RSYS = MODRED(SYS,ELIM) reduces the order of the state-space model 
%   SYS by eliminating the states specified in vector ELIM.  The full 
%   state vector X is partitioned as X = [X1;X2] where X2 is to be 
%   discarded, and the reduced state is set to Xr = X1+T*X2 where T is 
%   chosen to enforce matching DC gains (steady-state response) between 
%   SYS and RSYS.
%
%   ELIM can be a vector of indices or a logical vector commensurate
%   with X where TRUE values mark states to be discarded.  If SYS has 
%   been balanced with BALREAL and the vector G of Hankel singular 
%   values has small entries, you can use MODRED to eliminate the 
%   corresponding states:
%      [sys,g] = balreal(sys)   % compute balanced realization
%      elim = (g<1e-8)          % small entries of g -> negligible states
%      rsys = modred(sys,elim)  % remove negligible states
%   Note: For more accurate results, use BALRED rather than BALREAL+MODRED.
%
%   RSYS = MODRED(SYS,ELIM,METHOD) also specifies the state elimination
%   method.  Available choices for METHOD include
%      'MatchDC' :  Enforce matching DC gains (default)
%      'Truncate':  Simply delete X2 and sets Xr = X1.
%   The 'Truncate' option tends to produces a better approximation in the
%   frequency domain, but the DC gains are not guaranteed to match.
% 
% SYNTAX:
%	[rsys] = modred_2008b(sys, elim, method, varargin, 'PropertyName', PropertyValue)
%	[rsys] = modred_2008b(sys, elim, method, varargin)
%	[rsys] = modred_2008b(sys, elim, method)
%	[rsys] = modred_2008b(sys, elim)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	sys 	     <size>		<units>		<Description>
%	elim	    <size>		<units>		<Description>
%	method	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	rsys	    <size>		<units>		<Description> 
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
%	[rsys] = modred_2008b(sys, elim, method, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[rsys] = modred_2008b(sys, elim, method)
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
%	Source function: <a href="matlab:edit modred_2008b.m">modred_2008b.m</a>
%	  Driver script: <a href="matlab:edit Driver_modred_2008b.m">Driver_modred_2008b.m</a>
%	  Documentation: <a href="matlab:pptOpen('modred_2008b_Function_Documentation.pptx');">modred_2008b_Function_Documentation.pptx</a>
%
% See also BALREAL, SS
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/459
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/modred_2008b.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [rsys] = modred_2008b(sys, elim, method, varargin)

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
% rsys= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        method= ''; elim= ''; sys= ''; 
%       case 1
%        method= ''; elim= ''; 
%       case 2
%        method= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(method))
%		method = -1;
%  end
%% Main Function:
ni = nargin;
if ni<2
    ctrlMsgUtils.error('Control:general:TwoOrMoreInputsRequired','modred','modred')
elseif ni==3 && any(strncmpi(method,{'m','d','t'},1))
   % Make sure to trap old keywords 'mdc' and 'del'
   if strncmpi(method,'m',1)
      method = 'MatchDC';
   else
      method = 'Truncate';
   end
else
   method = 'MatchDC';  % default
end

% Get data
Data = getPrivateData(sys); % UDDREVISIT
if ~isscalar(Data)
    ctrlMsgUtils.error('Control:general:RequiresSingleModel','modred')
end

% Get order and check ELIM
ns = order(Data);
if isa(elim,'logical')
   elim = find(elim);
end
elim = elim(:);
if any(diff(sort(elim))==0) 
    ctrlMsgUtils.error('Control:general:IndexRepeated','modred(SYS,ELIM)','ELIM')
elseif any(elim<0) || any(elim>ns)
    ctrlMsgUtils.error('Control:general:IndexOutOfRange','modred(SYS,ELIM)','ELIM')
end

% Compute reduced model
rsys = utClearUserData(sys);
try
   rData = modred_2008b_B(Data,method,elim);
catch E
   throw(E)
end
rsys = setPrivateData(rsys,rData);

%% Compile Outputs:
%	rsys= -1;

end % << End of function modred_2008b >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101102 JPG: Copied over information from the old function.
% 101102 CNF: Function template created using CreateNewFunc
% 961030 PG : Revised
% 860904 JNL: Created (Copyright 1986-2007 The MathWorks, Inc.)
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username
% JNL: J.N. Little
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% PG : P. Gahinet

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
