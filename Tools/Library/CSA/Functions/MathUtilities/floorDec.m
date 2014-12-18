% FLOORDEC Rounds the number to the nearest Decimation towards -infinity
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% floorDec:
%   Rounds the number toward -infinity to the decimal place specified by
%   the user. 
% SYNTAX:
%	[Result] = floorDec(Number, Decimation)
%	[Result] = floorDec(Number)
%
% INPUTS: 
%	Name      	Size		Units           Description
%	Number	    [Variable]	[User Defined]	Number(s) to be rounded
%	Decimation	[1x1]		[User Defined]  Decimation level to be rounded 
%                                           to.
%                                           Defaults:
%                                           Decimation = 1;
%
% OUTPUTS: 
%	Name      	Size		Units           Description
%	Result	    [Variable]  [User Defined]  Number(s) rounded to Decimation
% NOTES:
%   Number can be scalar ([1]), a vector ([1xN] or [Nx1]), or a 
%   multi-dimensional matrix (M x N x P x ...]).  The output Result will 
%   carry the same dimensions as the input.
%   Decimation value should be a positive value.  Values that are 
%   Decimation < 0 will have abs(Decimation) applied.  If Decimation = 0, 
%   it will be reset to 1.
%
%   Output will be limited to the size of the Command window display
%   format. By default Matlab outputs to short format
%
% EXAMPLES:
%   Example 1: Positive Scalar Inputs
%   a = 1.142;
%   Decimation = 0.1;
%   floorDec( a, Decimation)
%
%   Results:  1.1000
%
%   Example 2: Negative Scalar Inputs
%   a = -1.142;
%   Decimation = 0.1;
%   floorDec( a, Decimation)
%
%   Results:  -1.2000
%
%   Example 3: Matrix Inputs with Mixed Values
%   Decimation = 0.1;
%   a = [ 0.9218    -0.1763    0.9355    0.4103;...
%        -0.7382     0.4057    0.9169   -0.8936 ];
%   floorDec( a, Decimation)
%
%   Results:
%    [ 0.9000   -0.2000    0.9000    0.4000;
%     -0.8000    0.4000    0.9000   -0.9000 ]
%
%   Example 4: Vector Inputs
%   a = [1.1 -4.9 -5.1 104 -106];
%   Decimation = 10;
%   floorDec( a, Decimation)
%
%   Results: [ 0   -10   -10   100  -110 ]
%
% HYPERLINKS:
%	Source function: <a href="matlab:edit floorDec.m">floorDec.m</a>
%	  Driver script: <a href="matlab:edit Driver_floorDec.m">Driver_floorDec.m</a>
%	  Documentation: <a href="matlab:pptOpen('floorDec_Function_Documentation.pptx');">floorDec_Function_Documentation.pptx</a>
%
% See also ceilDec roundDec format
%
% VERIFICATION DETAILS:
% Verified: Yes, Via Peer Review
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/414
%
% Copyright Northrop Grumman Corp 2011
% Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
% http://vodka.ccc.northgrum.com/trac/CSA/

% Subversion Revision Information At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/MathUtilities/floorDec.m $
% $Rev: 1976 $
% $Date: 2011-06-29 11:33:06 -0500 (Wed, 29 Jun 2011) $
% $Author: healypa $

function [Result] = floorDec(Number, Decimation)

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
Result= -1;

%% Input Argument Conditioning:
if nargin < 1
   disp([mfnam ' :: Please refer to useage of floorDec' endl ...
       'Syntax: [Result] = floorDec(Number, Decimation)' endl ...
       '        [Result] = floorDec(Number)']);
   return;
end;

if nargin == 1
    Decimation = 1;
end

if numel(Decimation) ~= 1
    disp([mfnam ' WARNING: Decimation is not [1x1].']);
    disp(['                 Decimation = ', num2str(Decimation(1))]);
    Decimation = Decimation(1);
end

if (isempty(Number) || isempty(Decimation))
    errstr = [mfnam tab 'ERROR: One (or more) input is empty' ];
    error([mfnam 'CSA:floorDec:EmptyInput'],errstr);
end

if (ischar(Number) || ischar(Decimation))
    errstr = [mfnam tab 'ERROR: Input of type CHAR' ];
    error([mfnam 'CSA:floorDec:CharInput'],errstr);
end

if (Decimation <= 0)
    if Decimation == 0
        disp([mfnam ' WARNING: Decimation is set to 0.']);
        disp('                 Result is NaN, Decimation will be set to 1');
        Decimation = 1;
    else
        Decimation = abs(Decimation);
        disp([mfnam ' WARNING: Decimation < 0, applying abs(Decimation)']);
        disp(['                 Decimation = ', num2str(Decimation)]);
    end
end

% Seperating the imaginary and real parts
imNumber = imag(Number);
Number = real(Number);
% Preallocating the variables.
Shape_Number = size(Number);
Elem_Number = numel(Number);
Result = zeros(Shape_Number);
imResult = zeros(Shape_Number);

%% Main Function:

remDecimal = rem( abs(Number), Decimation );     % Determine Remainder
if remDecimal == 0
    baseMult = round( abs(Number/Decimation));
else
    baseMult = fix( abs(Number/Decimation) );
end

for i = 1:Elem_Number;
    if (Number(i) < 0) && abs(remDecimal(i)) > 0
        Result(i) = (baseMult(i) + 1) * Decimation * sign(Number(i));
    else
        Result(i) = baseMult(i) * Decimation * sign(Number(i));
    end
    % This will only run if there is an imaginary component.
    if imNumber(i)
        imremDecimal = rem( abs(imNumber(i)), Decimation );     % Determine Remainder
        if imremDecimal == 0
            imbaseMult = round( abs(imNumber(i)/Decimation));
        else
            imbaseMult = fix( abs(imNumber(i)/Decimation) );
        end
        if (imNumber(i) < 0) && abs(imremDecimal) > 0
            imResult(i) = (imbaseMult + 1) * Decimation * sign(imNumber(i));
        else
            imResult(i) = imbaseMult * Decimation * sign(imNumber(i));
        end
        Result(i) = Result(i) + 1i*imResult(i);
    end
end

end % << End of function floorDec >>

%% REVISION HISTORY
% YYMMDD INI: note
% 101013 JPG: Filled in the function template.
% 101013 CNF: Function template created using CreateNewFunc
% 051021 MWS: Function created
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName             :  Email                :  NGGN Username 
% JPG: James Patrick Gray   :  james.gray2@ngc.com  :  g61720
% MWS: Mike W Sufana        :  mike.sufana@ngc.com  :  sufanmi 

%% FOOTER
% Distribution
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.
%
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------------------- UNCLASSIFIED ---------------------------
