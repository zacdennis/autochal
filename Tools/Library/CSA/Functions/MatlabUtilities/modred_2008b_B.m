% MODRED_2008B_B extracts reduced-order model, a workaround for a 2009b bug
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% modred_2008b_B:
%     Extracts reduced-order model.
%   This is a support function for using modred_2008b
%   This is to be used as a workaround for a bug discovered in
%   2009b.
%           Error Message:  "??? Error using ==> ss.modred at 71"
%                           "Input to SVD must not contain NaN or Inf."
%
%   This file was copied from:
%    C:\Program
%    Files\MATLAB\R2008b\toolbox\control\+ltipack\@ssdata\modred.m
% 
% SYNTAX:
%	[Dr] = modred_2008b_B(D, method, elim, varargin, 'PropertyName', PropertyValue)
%	[Dr] = modred_2008b_B(D, method, elim, varargin)
%	[Dr] = modred_2008b_B(D, method, elim)
%	[Dr] = modred_2008b_B(D, method)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	D   	       <size>		<units>		<Description>
%	method	  <size>		<units>		<Description>
%	elim	    <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	Dr  	      <size>		<units>		<Description> 
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
%	[Dr] = modred_2008b_B(D, method, elim, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Dr] = modred_2008b_B(D, method, elim)
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
%	Source function: <a href="matlab:edit modred_2008b_B.m">modred_2008b_B.m</a>
%	  Driver script: <a href="matlab:edit Driver_modred_2008b_B.m">Driver_modred_2008b_B.m</a>
%	  Documentation: <a href="matlab:pptOpen('modred_2008b_B_Function_Documentation.pptx');">modred_2008b_B_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/460
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/modred_2008b_B.m $
% $Rev: 1718 $
% $Date: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Dr] = modred_2008b_B(D, method, elim, varargin)

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
% Dr= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        elim= ''; method= ''; D= ''; 
%       case 1
%        elim= ''; method= ''; 
%       case 2
%        elim= ''; 
%       case 3
%        
%       case 4
%        
%  end
%
%  if(isempty(elim))
%		elim = -1;
%  end
%% Main Function:
ns = size(D.a,1);
if ns==0,
   Dr = D;  return
elseif hasInternalDelay(D)
   throw(ltipack.utNoDelaySupport('modred',D.Ts,'internal'))
end
keep = 1:ns;
keep(elim) = [];

try
   % REVISIT: generalize to descriptor
   [a,b,c,d] = getABCD(D);
catch %#ok<CTCH>
    ctrlMsgUtils.error('Control:general:NotSupportedImproperSys','modred')
end

switch method
   case 'MatchDC'
      % Matched DC gains: partition into x1, to be kept, and x2, to be eliminated:
      a11 = a(keep,keep);
      a12 = a(keep,elim);
      a21 = a(elim,keep);
      a22 = a(elim,elim);
      b1  = b(keep,:);
      b2  = b(elim,:);
      c1  = c(:,keep);
      c2  = c(:,elim);
      n2 = length(elim);
      
      % Form reduced matrices
      tolsing = eps^0.75;
      if D.Ts~=0,
         % Discrete-time system
         a22 = a22 - eye(n2);
      end
      [l,u,p] = lu(a22,'vector');
      norm11 = norm(a11,1);
      if norm(a22,1)>tolsing*norm11 && rcond(u)>tolsing,
         % Proceed
         A21 = u\(l\a21(p,:));
         B2 = u\(l\b2(p,:));
         ar = a11 - a12 * A21;
         br = b1 - a12 * B2;
         cr = c1 - c2 * A21;
         dr = d - c2 * B2;
      else
         % Use pseudo-inverse pinv(a22)
         [u,s,v] = svd(a22);
         s = diag(s(1:n2,1:n2));
         nnz = sum(s > tolsing * max([s;norm11]));
         u = u(:,1:nnz);
         v = v(:,1:nnz);
         s = s(1:nnz);
         A21 = diag(1./s) * u' * a21;
         B2 = diag(1./s) * u' * b2;
         A12 = a12 * v;
         C2 = c2 * v;
         ar = a11 - A12 * A21;
         br = b1 - A12 * B2;
         cr = c1 - C2 * A21;
         dr = d - C2 * B2;
      end
      
   case 'Truncate'
      % Simply delete specified states
      ar = a(keep,keep);
      br = b(keep,:);
      cr = c(:,keep);
      dr = d;    
end

% Build output
Dr = ltipack.ssdata(ar,br,cr,dr,[],D.Ts);
Dr.Delay = D.Delay;
% Dr.StateName = D.StateName(keep);

%% Compile Outputs:
%	Dr= -1;

end % << End of function modred_2008b_B >>

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
