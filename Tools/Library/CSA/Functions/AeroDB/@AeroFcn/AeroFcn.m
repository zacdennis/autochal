classdef AeroFcn < AeroElm 
% file: 
    properties
        hFcn;           % Function handle
    end

%% Class methods
    methods 
        %% Meth: Constructor
        function obj = AeroFcn(IndepVars, IndepData, DepVar, fcnHnd) %Constructor function
            %TODO: Perform error checking on input arguments
            
            obj=obj@AeroElm(IndepVars, IndepData, DepVar);  % Construct! 
            obj.hFcn = fcnHnd;
       end % AeroFcn
       
       %% Meth: disp
       function disp(obj)
            tab  = sprintf('\t');
            disp@AeroElm(obj);
            
            disp([tab 'Function Handle: ' char(obj.hFcn)]);
       end

       %% Method: Eval        
       function outval = eval(obj,varargin) 
           %TODO: Error checking and domain validity
           
           nIVs = length(obj.IndepVars);
           args = [];
           
           if isempty(varargin)   %Use IndepData
               varnam = 'obj.IndepData{';
           else     %Use user data
               varnam = 'varargin{';
           end
               
           for i = 1:nIVs
               args = [args varnam num2str(i) '}, '];
           end
           if ~isempty(args), args = args(1:end-2); end
           
           outval = eval(['obj.hFcn(' args ')']);
       end
       
       %% Method: size
       function outval = size(obj,dim)
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

