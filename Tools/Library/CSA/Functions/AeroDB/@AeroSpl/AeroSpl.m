classdef AeroSpl < AeroElm 
% file: 
    properties
        DepData = [];
    end

%% Class methods
    methods 
        %% Meth: Constructor
        function obj = AeroSpl(IndepVars, IndepData, DepVar, DepData) %Constructor function
            %TODO: Perform error checking on input arguments
            
            % Construct! 
            obj=obj@AeroElm(IndepVars, IndepData, DepVar);            
            obj.DepData = DepData;
       end % AeroSpl
       
       %% Meth: disp
       function disp(obj)
            tab  = sprintf('\t');
            disp@AeroElm(obj);
            
            disp([tab obj.DepVar ': Size is: ' mat2str(size(obj.DepData))]);
       end
       
       %% Method: Eval        
       function outval = eval(obj,varargin) 
           %TODO: Error checking and domain validity
           
           outval = spline(obj.IndepData{1}, obj.DepData, varargin{1});
       end
       
       %% Method: Size
        function outval = size(obj,dim)
            if nargin == 1
                outval = size(obj.DepData);
            else
                outval = size(obj.DepData,dim);
            end
        end
        
        %% Method: deriv
        function outval = deriv(obj)
        end
    end

%% Get static methods (called as class.Eval(arg)
    methods (Static)            
    end %Static methods
end % classdef   



%% Revision History
% YYMMDD INI: note
%
% 080507 TKV: added error checking and numeric input support for
% GetIndepVal method.
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% TKV: Travis Vetter : travis.vetter@ngc.com : vettetr 

%% Footer
% -------------------------- UNCLASSIFIED ---------------------------
% --------------- Nothrop Grumman Proprietary Level 1 ---------------
% ------------------ ITAR Controlled Work Product -------------------
% WARNING - This document contains technical data whose export is
%   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
%   seq.) or the Export Administration Act of 1979, as amended, Title 50,
%   U.S.C., App.2401et seq. Violation of these export-control laws is 
%   subject to severe civil and/or criminal penalties.

