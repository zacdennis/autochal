% BUILDGROUNDLATLON builds the ground at specified latitudes/longitudes.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% BuildGroundLatLon:
%     <Function Description> 
% *************************************************************************
% * #NOTE: To future COSMO'er, the one line description can be improved
% * -JPG
% *************************************************************************
%
% SYNTAX:
%	[GroundNew] = BuildGroundLatLon(Grounds, varargin, 'PropertyName', PropertyValue)
%	[GroundNew] = BuildGroundLatLon(Grounds, varargin)
%	[GroundNew] = BuildGroundLatLon(Grounds)
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
%	[GroundNew] = BuildGroundLatLon(Grounds, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[GroundNew] = BuildGroundLatLon(Grounds)
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
%	Source function: <a href="matlab:edit BuildGroundLatLon.m">BuildGroundLatLon.m</a>
%	  Driver script: <a href="matlab:edit Driver_BuildGroundLatLon.m">Driver_BuildGroundLatLon.m</a>
%	  Documentation: <a href="matlab:pptOpen('BuildGroundLatLon_Function_Documentation.pptx');">BuildGroundLatLon_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/648
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/Environment/BuildGroundLatLon.m $
% $Rev: 1716 $
% $Date: 2011-05-11 17:12:24 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [GroundNew] = BuildGroundLatLon(Grounds, varargin)

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
GroundNew= -1;

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

    GroundNew.arrLat = unique([Ground.arrLat Ground2.arrLat]);
    GroundNew.arrLon = unique([Ground.arrLon Ground2.arrLon]);

    % Loop Through Lat
    for iLat = 1:length(GroundNew.arrLat)
        curLat = GroundNew.arrLat(iLat);

        % Loop Through Each Lon
        for iLon = 1:length(GroundNew.arrLon)
            curLon = GroundNew.arrLon(iLon);

            surf1max = 0;      
            if curLat < Ground.arrLat(1)
                curLat1 = Ground.arrLat(1);
                surf1max = 1;
            elseif curLat > Ground.arrLat(end)
                curLat1 = Ground.arrLat(end);
                surf1max = 1;
            else
                curLat1 = curLat;
            end

            if curLon < Ground.arrLon(1)
                curLon1 = Ground.arrLon(1);
                surf1max = 1;
            elseif curLon > Ground.arrLon(end)
                curLon1 = Ground.arrLon(end);
                surf1max = 1;
            else
                curLon1 = curLon;
            end

            surf2max = 0;
            if curLat < Ground2.arrLat(1)
                curLat2 = Ground2.arrLat(1);
                surf2max = 1;
            elseif curLat > Ground2.arrLat(end)
                curLat2 = Ground2.arrLat(end);
                surf2max = 1;
            else
                curLat2 = curLat;
            end

            if curLon < Ground2.arrLon(1)
                curLon2 = Ground2.arrLon(1);
                surf2max = 1;
            elseif curLon > Ground2.arrLon(end)
                curLon2 = Ground2.arrLon(end);
                surf2max = 1;
            else
                curLon2 = curLon;
            end

            curAlt1 = interp2(Ground.arrLat, ...
                Ground.arrLon, Ground.tableAlt', curLat1, curLon1);
            
            curAlt2 = interp2(Ground2.arrLat, ...
                Ground2.arrLon, Ground2.tableAlt', curLat2, curLon2);
            
            if ((surf1max == 0) && (surf2max == 1))
                GroundNew.tableAlt(iLat, iLon) = curAlt1;

            elseif ((surf2max == 1) && (surf2max == 0))
                GroundNew.tableAlt(iLat, iLon) = curAlt2;
                GroundNew.tableSurfCond(iLat, iLon) = curSurfCond2;
            else
                % Use the Most Current Altitude Given:
                GroundNew.tableAlt(iLat, iLon) = curAlt2;
%                 GroundNew.tableAlt(iLat, iLon) = min(curAlt1, curAlt2);

            end            
        end
    end
% 
% curPt = 0;
% for iLat = 1:length(Ground.arrLat)
%     curLat = Ground.arrLat(iLat);
%     for iLon = 1:length(Ground.arrLon)
%         curLon = Ground.arrLon(iLon);
% 
%         curAlt = Ground.tableAlt(iLat, iLon);
%         curPt = curPt + 1;
%         matGround(:, curPt) = [curLat; curLon; curAlt];
%     end
% end
% 
% GroundNew.matGround = matGround;
%% Compile Outputs:
%	GroundNew= -1;

end % << End of function BuildGroundLatLon >>

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
