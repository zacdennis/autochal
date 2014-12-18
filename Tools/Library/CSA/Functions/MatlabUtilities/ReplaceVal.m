% REPLACEVAL Replace Values in  a matrix(eg, NaN,inf,val) with other val
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ReplaceVal:
%     Replace a values in an ND array with new values.
% 
% Inputs - Val: Initial Matrix/data
%		 - RepMe: What to find/replace
%		 - NewVal: What to put in its spot
%		 
% Output - Val: Corrected Matrix/Data 
%        - NodeList: List of corrected values
%
% Example:
%	[Val,NodeList] = ReplaceVal(Val,NaN,0);
%
% See also <add relevant funcions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/58
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Informaton At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MatlabUtilities/ReplaceVal.m $
% $Rev:: 1718                                                 $
% $Date:: 2011-05-11 18:07:49 -0500 (Wed, 11 May 2011)        $

function [Val,NodeList] = ReplaceVal(Val,RepMe,NewVal)

%% General Header 
spc  = sprintf(' ');
tab  = sprintf('\t');
endl = sprintf('\n');
mfnam = mfilename;
mfspc = char(ones(1,length(mfnam))*spc);

%% Arg conditioning
if nargin ~=3 
    error('improper number of args'); 
end
if ~isnumeric(Val) && ~isnumeric(RepMe) && ~isnumeric(NewVal)
    error('All values must be numeric');
end

%% Find
if isnan(RepMe)
    idx = find(isnan(Val));
elseif isinf(RepMe);
    idx = find(isinf(Val));
else
    idx = find(Val == RepMe);
end

%% Replace
Val(idx) = NewVal; 

%% Get NodeList
NodeList = idx; %TODO, this is going to use the linear index,
%                 so (3,2) will be (5) i think, this should be switched
%               to a normal index the dimension of the matrix. 
% Example of Display formats ...
% disp([mfnam '>> Output with filename included...' ]);
% disp([mfspc '>> further outputs will be justified the same']);
% disp([mfspc '>>CAUTION: or mfnam: note lack of space after">>"']);
% disp([mfnam '>>WARNING: <- Very important warning (does not terminate)']);
% disp([mfnam '>>ERROR: <-if followed by "return" used if continued exit desired']);
% errstr = [mfname >>ERROR: <define error here> ]; will term with error; "doc Error" ';
% error([mfnam 'class:file:Identifier'],errstr);

%% Return 
return 

%% Revision History
% YYMMDD INI: note
% 090706 TKV: initial Functionality
% 090715 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% TKV: Travis Vetter : travis.vetter@ngc.com :

%% Footer

% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
