% BISECT searches for value of x that makes f(x)=0.
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% bisect:
% *  Filename: bisect.cpp
% *       UTILITY ROUTINE TO PERFORM SEARCH FOR VALUE OF x THAT MAKES
% *       f(x)=0, USING THE BISECTION METHOD. BASED UPON FUNCTION rtbis
% *       FROM "NUMERICAL RECIPES".
% *       THE FUNCTION f IS ASSUMED TO EXIST EXTERNALLY. BISECT IS CALLED
% *       IN A LOOP WHICH INCLUDES THE EVALUATION OF f, WITH THE LOOP
% *       CONTROLLED BY THE VALUE OF istat.
% *
% *       x HOLDS THE CURRENT VALUE FOR WHICH f(x) IS TO BE EVALUATED.
% *       THE RESULT OF THE EVALUATION IS RETURNED TO BISECT IN f.
% *       x1 AND x2 ARE INPUTS THAT DEFINE THE RANGE OF x OVER WHICH THE
% *       SEARCH WILL BE CARRIED OUT. THIS RANGE IS ASSUMED TO BRACKET
% *       THE SOLUTION (NO ERROR CHECKING IS PERFORMED). tol IS AN INPUT
% *       THAT DEFINES THE NUMERICAL TOLERANCE OF THE FINAL x SOLUTION.
% *
% *       WK IS AN ARRAY OF DIMENSION FOUR THAT IS USED BY BISECT
% *       TO HOLD INTERMEDIATE VALUES.
% *
% *       THE FLAG ISTAT IS USED AS FOLLOWS:
% *       istat =0     - TELLS BISECT TO INITIALIZE FOR A NEW SEARCH
% *       istat =1     - INSTRUCTS THE CALLING PROGRAM TO GO EVALUATE
% *                     THE FUNCTION USING THE VALUE x, AND THEN
% *                     PLACE THE RESULT IN f.
% *       istat =2     - SEARCH COMPLETED; SOLUTION IS RETURNED IN x;
% *                     FINAL x IS WITHIN tol OF THE TRUE ROOT OF f(x)=0.
% *
% *       EXCEPT TO SET istat =0 INITIALLY, THE VALUE OF istat SHOULD NOT
% *       BE CHANGED BY THE CALLING PROGRAM.
% *
% *     rtbis: CURRENT "BOTTOM" VALUE OF x
% *     dx: 	 CURRENT LENGTH OF INTERVAL
% *     search_oriented: INDICATOR THAT SEARCH HAS BEEN PROPERLY
% *            ORIENTED (search_oriented >0)
% *     numIteration:   CURRENT NUMBER OF ITERATIONS
% **********************************************************************/
% F = omegaDot;
% X = omega;
% X1 = K1;
% X2 = K2;
% TOL = 0.01;
% WK = zeros(1,4);
% ISTAT = 0;
%
% SYNTAX:
%	[Xo, WKo, ISTATo] = bisect(F, X, X1, X2, TOL, WK, ISTAT)
%
% INPUTS: 
%	Name    	Size		Units		Description
%	F   	       <size>		<units>		<Description>
%	X   	       <size>		<units>		<Description>
%	X1  	      <size>		<units>		<Description>
%	X2  	      <size>		<units>		<Description>
%	TOL 	     <size>		<units>		<Description>
%	WK  	      <size>		<units>		<Description>
%	ISTAT	   <size>		<units>		<Description>
%	varargin	[N/A]		[varies]	Optional function inputs that
%	     		        				 should be entered in pairs.
%	     		        				 See the 'VARARGIN' section
%	     		        				 below for more details
%
% OUTPUTS: 
%	Name    	Size		Units		Description
%	Xo  	      <size>		<units>		<Description> 
%	WKo 	     <size>		<units>		<Description> 
%	ISTATo	  <size>		<units>		<Description> 
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
%	[Xo, WKo, ISTATo] = bisect(F, X, X1, X2, TOL, WK, ISTAT, varargin)
%	% <Copy expected outputs from Command Window>
%
%	% <Enter Description of Example #2>
%	[Xo, WKo, ISTATo] = bisect(F, X, X1, X2, TOL, WK, ISTAT)
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
%	Source function: <a href="matlab:edit bisect.m">bisect.m</a>
%	  Driver script: <a href="matlab:edit Driver_bisect.m">Driver_bisect.m</a>
%	  Documentation: <a href="matlab:pptOpen('bisect_Function_Documentation.pptx');">bisect_Function_Documentation.pptx</a>
%
% See also <add relevant functions> 
%
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/55
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/bisect.m $
% $Rev: 1717 $
% $Date: 2011-05-11 17:32:32 -0500 (Wed, 11 May 2011) $
% $Author: healypa $

function [Xo, WKo, ISTATo] = bisect(F, X, X1, X2, TOL, WK, ISTAT)

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
Xo= -1;
WKo= -1;
ISTATo= -1;

%% Input Argument Conditioning:
% Pick out Properties Entered via varargin
% [<PropertyValue>, varargin]  = format_varargin('<PropertyValue', <Default>, 2, varargin);

%  switch(nargin)
%       case 0
%        ISTAT= ''; WK= ''; TOL= ''; X2= ''; X1= ''; X= ''; F= ''; 
%       case 1
%        ISTAT= ''; WK= ''; TOL= ''; X2= ''; X1= ''; X= ''; 
%       case 2
%        ISTAT= ''; WK= ''; TOL= ''; X2= ''; X1= ''; 
%       case 3
%        ISTAT= ''; WK= ''; TOL= ''; X2= ''; 
%       case 4
%        ISTAT= ''; WK= ''; TOL= ''; 
%       case 5
%        ISTAT= ''; WK= ''; 
%       case 6
%        ISTAT= ''; 
%       case 7
%        
%       case 8
%        
%  end
%
%  if(isempty(ISTAT))
%		ISTAT = -1;
%  end
%% Main Function:
%% Retrieve Data from the WK vector:
rtbis           = WK(1);
dx              = WK(2);
search_oriented = WK(3);
numIteration    = WK(4);

TRUE = (1 == 1);
FALSE = (1 == 0);

switch ISTAT
    case 0
        % Initialize Search Routine:
        rtbis           = 0.0;
        dx              = 0.0;
        search_oriented = FALSE;    % [bool]
        numIteration    = 0;        % [int]

        % GO EVALUATE F(X1)
        Xo     = X1;
        ISTATo = 1;

    case 1
        % Evaluate function f
        
        % Check Search orientation:
        if (search_oriented == FALSE)
            % Search is NOT oriented:
            %   Reorient Search (Note that this logic assumes that solution
            %   is bracketed by X1:X2)

            if (F < 0.0)
                rtbis = X1;
                dx = X2 - X1;
            else
                rtbis = X2;
                dx = X1 - X2;
            end
            search_oriented = TRUE;

            % SET NEXT VALUE OF X AND GO EVALUATE F(X)
            dx = dx * 0.5;
            Xo  = rtbis + dx;

        else
            %% ITERATIVE SEARCH PORTION; CHECK FUNCTION VALUE
            if (F <= 0.0)
                rtbis = X;

                % TEST FOR DONENESS
                if ((abs(dx) < tol) || (F == 0.0) || (numIteration > XITMAX))
                    % WE'RE DONE
                    ISTATo = 2;
                else

                    % KEEP GOING
                    dx  = dx * 0.5;
                    Xo   = rtbis + dx;
                    numIteration = numIteration + 1;
                    ISTATo = ISTAT;
                end
            end
        end
    otherwise
        % SEARCH IS ALREADY DONE, JUST RETURN
        Xo     = X;
        ISTATo = ISTAT;
end

%% RETURN DATA TO WORK VECTOR:
WKo(1) = rtbis;
WKo(2) = dx;
WKo(3) = search_oriented;
WKo(4) = numIteration;


%% Compile Outputs:
%	Xo= -1;
%	WKo= -1;
%	ISTATo= -1;

end % << End of function bisect >>

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
