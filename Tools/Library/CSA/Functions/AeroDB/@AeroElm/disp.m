% DISP_AEROTBL <one line description>
% -------------------------- UNCLASSIFIED ---------------------------
% --------------- Nothrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% Disp_AeroTbl:
%     Display AeroTbl Class  
% 
% Inputs - Obj: a AeroTbl Class object
%          Full: Flag for everything
%		 
% Output - DispStr: The output as a string      
%
% <any additional informaton>
%
% Example:
%	[DispStr,info] = Disp_AeroTbl(Obj,Full);
%
% See also class disp 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/616
%
% Copyright Northrop Grumman Corp 2011

% Subversion Revsion Informaton At Last Commit
% $URL $
% $Rev:: 1713                                                 $
% $Date:: 2011-05-11 15:12:26 -0500 (Wed, 11 May 2011)        $

function disp(obj)

%% General Header 
spc  = sprintf(' ');
tab  = sprintf('\t');
% endl = sprintf('\n');
mfnam = mfilename;
% mfspc = char(ones(1,length(mfnam))*spc);

%% Arg conditioning

%% < Function Sections >

% Independent Variables
strIVs = '';
nIVs = length(obj.IndepVars);
for i=1:nIVs
    strIV = obj.IndepVars{i};
    strIVUnits = obj.IndepVarsUnits{i};
    if(~isempty(strIVUnits))
        strIVUnits = [' ' strIVUnits];
    end
    
    strIVs = [strIVs obj.IndepVars{i} strIVUnits ', '];
end
if nIVs > 0, strIVs = strIVs(1:end-2); end

% Dependent Variables
strDVs = '';
nDVs = length(obj.DepVars);
for i=1:nDVs
    strDV = obj.DepVars{i};
    strDVUnits = obj.DepVarsUnits{i};
    if(~isempty(strDVUnits))
        strDVUnits = [' ' strDVUnits];
    end
    
    strDVs = [strDVs obj.DepVars{i} strDVUnits ', '];
end
if nDVs > 0, strDVs = strDVs(1:end-2); end

% Display 
numLines = size(obj.Name, 1);
for iLine = 1:numLines
    if(iLine == 1)
        disp([tab 'Name      : ' obj.Name{iLine}]);
    else
        disp([tab '          : ' obj.Name{iLine}]);
    end
end
disp([tab 'Source    : ' obj.Source]);
disp([tab 'Version   : ' obj.Version]);
% disp([tab 'Caveat    : ' 'This isn''t ready yet']);
disp([tab 'IndepVars : ( ' strIVs ' )']);

for i=1:nIVs
    strIV = obj.IndepVars{i};
    strIV_Data = mat2str(obj.IndepData{i});
    strSpaces = spaces(max((10-length(strIV)), 0));
    disp([tab strIV strSpaces ': ' strIV_Data]);
end
disp([tab 'DepVars   : ( ' strDVs ' )']);
disp([tab 'Prototype : obj.eval( ''DepVar'', ' strIVs ' )']);
disp([tab '          :  Note ''[ ]'' and '':'' can be used to eval all IndepVar breakpoints']);
disp([tab 'Modified  : ' num2str(obj.Modified) ]);
disp([tab 'Locked    : ' num2str(obj.Locked) ]); 

% Return from function
end 

%% Revision History

% 100305 TKV: Updated the disp function to mix with new AeroTbl objects
% 080429 TKV: copied from base class instatiation... 
% 080429 CNF: File Created by CreateNewFunc
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% TKV: Travis Vetter : travis.vetter@ngc.com : vettetr

%% Footer
% -------------------------- UNCLASSIFIED ---------------------------
% --------------- Nothrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
