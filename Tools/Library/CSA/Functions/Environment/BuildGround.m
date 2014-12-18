% BUILDGROUND creates the ground for use in simulations.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildGround:
%     <Function Description> 
% *************************************************************************
% * #NOTE: To future COSMO'er, the one line description can be improved
% * -JPG
% *************************************************************************
% 
% SYNTAX:
%	[GroundNew] = BuildGround(Grounds)
%
% INPUTS: 
%	Name     	Size		Units		Description
%	Grounds	  <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name     	Size		Units		Description
%	GroundNew	<size>		<units>		<Description> 
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
%	[GroundNew] = BuildGround(Grounds, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[GroundNew] = BuildGround(Grounds)
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
%	Source function: <a href="matlab:edit BuildGround.m">BuildGround.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildGround.m">Driver_BuildGround.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildGround_Function_Documentation.pptx');">BuildGround_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/647
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/BuildGround.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [GroundNew] = BuildGround(Grounds)

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
% GroundNew= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        Grounds= ''; 
%       case 1
%        
%       case 2
%        
%  end
%
%% Main Function:
numGrounds = length(Grounds);

for iLoop = 1:(numGrounds-1)
    if (iLoop == 1)
        Ground = Grounds(1).Ground;
    else
        Ground = GroundNew;
    end
    
    Ground2 = Grounds(iLoop + 1).Ground;

    GroundNew.arrPn = unique([Ground.arrPn Ground2.arrPn]);
    GroundNew.arrPe = unique([Ground.arrPe Ground2.arrPe]);

    % Loop Through Pn
    for iPn = 1:length(GroundNew.arrPn)
        curPn = GroundNew.arrPn(iPn);

        % Loop Through Each Pe
        for iPe = 1:length(GroundNew.arrPe)
            curPe = GroundNew.arrPe(iPe);

            surf1max = 0;      
            if curPn < Ground.arrPn(1)
                curPn1 = Ground.arrPn(1);
                surf1max = 1;
            elseif curPn > Ground.arrPn(end)
                curPn1 = Ground.arrPn(end);
                surf1max = 1;
            else
                curPn1 = curPn;
            end

            if curPe < Ground.arrPe(1)
                curPe1 = Ground.arrPe(1);
                surf1max = 1;
            elseif curPe > Ground.arrPe(end)
                curPe1 = Ground.arrPe(end);
                surf1max = 1;
            else
                curPe1 = curPe;
            end

            surf2max = 0;
            if curPn < Ground2.arrPn(1)
                curPn2 = Ground2.arrPn(1);
                surf2max = 1;
            elseif curPn > Ground2.arrPn(end)
                curPn2 = Ground2.arrPn(end);
                surf2max = 1;
            else
                curPn2 = curPn;
            end

            if curPe < Ground2.arrPe(1)
                curPe2 = Ground2.arrPe(1);
                surf2max = 1;
            elseif curPe > Ground2.arrPe(end)
                curPe2 = Ground2.arrPe(end);
                surf2max = 1;
            else
                curPe2 = curPe;
            end

            curPd1 = interp2(Ground.arrPn, ...
                Ground.arrPe, Ground.tablePd', curPn1, curPe1);
            
            curPd2 = interp2(Ground2.arrPn, ...
                Ground2.arrPe, Ground2.tablePd', curPn2, curPe2);
            
            if ((surf1max == 0) && (surf2max == 1))
                GroundNew.tablePd(iPn, iPe) = curPd1;

            elseif ((surf2max == 1) && (surf2max == 0))
                GroundNew.tablePd(iPn, iPe) = curPd2;
                GroundNew.tableSurfCond(iPn, iPe) = curSurfCond2;
            else
                % Use the Most Current Altitude Given:
                GroundNew.tablePd(iPn, iPe) = curPd2;
%                 GroundNew.tablePd(iPn, iPe) = min(curPd1, curPd2);

            end            
        end
    end
% 
% curPt = 0;
% for iPn = 1:length(Ground.arrPn)
%     curPn = Ground.arrPn(iPn);
%     for iPe = 1:length(Ground.arrPe)
%         curPe = Ground.arrPe(iPe);
% 
%         curPd = Ground.tablePd(iPn, iPe);
%         curPt = curPt + 1;
%         matGround(:, curPt) = [curPn; curPe; curPd];
%     end
% end
% 
% GroundNew.matGround = matGround;

%% Compile Outputs:
%	GroundNew= -1;

end % << End of function BuildGround >>

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
