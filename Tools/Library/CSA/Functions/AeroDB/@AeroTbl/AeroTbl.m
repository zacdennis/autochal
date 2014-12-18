% AEROTBL Class File for Aerodynamic Tables
% -------------------------- UNCLASSIFIED ---------------------------
% ------------------ ITAR Controlled Work Product -------------------
% -------------- Northrop Grumman Proprietary Level 1 ---------------
% AeroTbl:
%     Class Definition for the AeroTbl object.
% 
% Inputs - IndepVars: CellStr(nx1) of IndepVar Names
%        - IndepDataIn: Cell(nx1) of IndepVar breakpoint Vectors
%                     : Struct: with fields named (IndepVars) of data
%		 - Depvars: CellStr(mx1) of DepVar Names
%        - DepDataIn: Cell(nx1) of DepVar data matricies
%                   : Struct: with fields named (DepVars) of data
%		 
% Output - obj: An AeroTbl object 
%        
% <any additional informaton>
%
% Example:
%	obj = AeroTbl(IndepVars, IndepDataIn, DepVars, DepDataIn)
%
% See also AeroElm AeroSpl AeroFcn
%
% VERIFICATION DETAILS:
% Verified: No
% Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/616
%
% Copyright Northrop Grumman Corp 2011

% Subversion Revision Informaton At Last Commit
% $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/Functions/AeroDB/@AeroTbl/AeroTbl.m $
% $Rev:: 2220                                                 $
% $Date::               

classdef AeroTbl < AeroElm 
% file: 
    properties
        IndepData = {[]};   %Independent data - Nx1 cell array of vectors for N dimensions
                            %or a struct containing fields with names
                            %IndepVars.
        DepData = {[]}; % a matrix of dimension n, that has lenghs equal to lengh of each vector in IndpeData     
    end

    properties (SetAccess = private)
        InterpMethod = 'Linear';
        ExtrapMethod = 'None - Clip';  
    end

%% Class methods
    methods 
        %% Meth: Constructor
        function obj = AeroTbl(IndepVars, IndepDataIn, DepVars, DepDataIn) %Constructor function

%todo: add property for "equal Spaceing of all inputs"  this will allow 
% the use of the *linear, *nearest, *cubic interpolates at rapid speed.  

            obj=obj@AeroElm(IndepVars, DepVars);  % Construct AeroElm
            % Parse IndepVars
            for i=1:length(obj.IndepVars)
                p = obj.addprop(obj.IndepVars{i});
                if isstruct(IndepDataIn)
                    obj.IndepData{i} = IndepDataIn.(obj.IndepVars{i}); %copy to cell array
                    eval(['obj.' IndepVars{i} '= IndepDataIn.' obj.IndepVars{i} ';']);
                elseif iscell(IndepDataIn)
                    obj.IndepData{i} = IndepDataIn{i}; %copy over
                    eval(['obj.' obj.IndepVars{i} '= IndepDataIn{i};']);
                else
                    error('InDepData must be a cell or a struct');
                end

                p.Dependent = true; %not quite sure how  to set this
                p.Transient = true; %somehow prevents the dyn prop from being saved
                p.SetAccess = 'private';
%                 p.GetMethod = eval(['@(obj) GetVal(obj,''' IndepVars{i} ''')']);
            end
            
            % Loop DepVars
            for i=1:length(obj.DepVars)
                %Creat Property
                p = obj.addprop(obj.DepVars{i});
                %Set Data 
                if isstruct(DepDataIn)
                    eval(['obj.' obj.DepVars{i} '= DepDataIn.' obj.DepVars{i} ';']);
                elseif iscell(DepDataIn)
                    eval(['obj.' obj.DepVars{i} '= DepDataIn{i};']);
                else
                    error('InDepData must be a cell or a struct');
                end
                %NewProperty Properties
                p.Dependent = false; 
                P.Transient = true; 
                p.SetAccess = 'public'; % restrict access
            end
            
       end % AeroTbl
        
       %% Meth: disp
       function disp(obj)
            tab  = sprintf('\t');
            disp@AeroElm(obj);       
            %disp([tab obj.DepVar ': Size is: ' mat2str(size(obj.DepData))]);
%             strttxt = PrintStructure(obj.DepData,5);
%             disp(strttxt);
%             outlst = '';
%             nDVs = length(obj.DepVars);
%             for i=1:nDVs
%                 outlst = [outlst obj.DepVars{i} obj.DepVarsUnits{i} '|']; %#ok<AGROW>
%             end
%             if nDVs > 0, outlst = outlst(1:end-1); end % remove '|' on last
%             
%             disp([tab 'DepVars: [' outlst ']' ]);
            disp([tab 'Interp : ' obj.InterpMethod]);
            disp([tab 'Extrap : ' obj.ExtrapMethod]);
       end
                
        %% Method: Size
        function outval = size(obj,dim)
            if nargin == 1
                outval = size(obj.DepData);
            else
                outval = size(obj.DepData,dim);
            end
        end
        
        %% Method: GetVal
        function [output,dim] = GetVal(obj,name)
            %Function to return independent values
            %ArgCheck
            if isempty(name); error('name not incuded in call!');end
            if ischar(name)
                dim = find(strcmp(obj.IndepVars,name));
            elseif isnumeric(name)
                dim = name ;
            else
                error('improper data type'); %TODO: Expound on this error
            end
            %Check and get values
            if isempty(dim) || dim>length(obj.IndepVars)
                error('Can''t determin dimension requested'); %TODO: Expound on this error
            else
                output = obj.IndepData{dim}; 
            end
        end
        
        %% Method: Eval
        % implicitely called 
        function outval = eval(obj,DepVarName,varargin) 
            % AeroTbl.eval Help File
            % Desc: This is the primary interpn call to retrieve data from
            % the table.  
            % Eval: Inputs: obj: the parent object
            %               DepVarName: teh Name of teh Dependent Variable to calculate
            %               Varargin: 
            %               Case 1: Empty -> Returns Array of values
            %               Case 2: cell -> A cell of length
            %               length(Indepvars) specifying input values (in
            %               order)
            %               Case 3: n inputs (length(indepvars) in order at
            %               place to evaluate
            % Examples: 
            %   Data = obj.eval('DepVar'); %Displays full data
            %   Data = eval(obj,'DepVar',indep1,indep2);
            %   Data = obj.eval('DepVar',{inep1,indep2});
            
            if nargin == 1 % ONLY the Obje
                error('Must specify the DepVar to eval!');
%                 outval = obj; %output the struct of stuff... 
            end
            %help for eval applied to this function
            if isempty(varargin)% No specifice values -> output table
                outval = obj.(DepVarName);
                return 
            end
            if length(varargin) == 1 && isa(varargin{1},'cell')
                Temp= varargin{1}; 
                for i=1:length(Temp) % recreate vargin as if we had typed it out
                    varargin{i} = Temp{i}; 
                end
            end
            if length(varargin) ~= length(obj.IndepVars) %if cell shoudl be corrected by now
                error('must have same number of args as number of indep vars or be a single cell array of proper length');
            else
                % Check to see if any of the lookup independent variables
                % is a ':' (e.g. all available) and replace it with the
                % actual independent variables
                num_varargin = length(varargin);
                for i_varargin = 1:num_varargin
                    cur_varargin = varargin{i_varargin};
                    if(isempty(cur_varargin) || strcmp(cur_varargin, ':'))
                        varargin{i_varargin} = obj.IndepData{i_varargin};
                    end
                end 
            end
            
            switch obj.InterpMethod
                case 'None-Flat'
                    methodStr = 'nearest';
                case 'Linear'
                    methodStr = 'linear';
                case 'Cubic spline'
                    methodStr = 'spline';
                otherwise
                    error('Invalid Interp Method');
            end
            % Select Extrapolation Method
            switch obj.ExtrapMethod
                case 'None - Clip'
                    nonecliped = @(x,x1)  min(x1(end),max(x,x1(1)));
                    x1data = cellfun(nonecliped, varargin, obj.IndepData, 'UniformOutput', 0);
                case 'Linear'
                    x1data = varargin; 
                    error('not yet implimented');
                case 'Cubic spline'
                    x1data = varargin; 
                    error('not yet inplimented');
                otherwise
                    error('Invalid Extrap Method'); 
            end
            
            %evaluate section
            if isvector(obj.(DepVarName)) %1-D
                outval = interp1(obj.IndepData{:},obj.(DepVarName),x1data{:}, methodStr);
            else %n-D
                outval = interpn(obj.IndepData{:},obj.(DepVarName),x1data{:});
            end
        end

        %% Method: deriv
        function outval = deriv(obj)
            outval = -1;
            disp('This method is not yet implemented');
        end
        
        %% Method: set.InterpMethod                    
        function obj = set.InterpMethod(obj,InterpMethod)
            %AeroTbl.InterpMethod: used to set private member interpolatino
            %method {'None - Flat', 'Linear', 'Cubic spline'}
            if ~(strcmpi(type,'None - Flat') || strcmpi(type,'Linear') || strcmpi(type,'Cubic spline'))
                error('Type must be either None - Flat, Linear, or Cubic spline')
            end
            obj.InterpMethod = InterpMethod;
        end % Set.Type

        %% set.ExtrapMethod
        function set.ExtrapMethod(obj,ExtrapMethod)
            %AeroTbl.ExtrapMethod: Used to set private memeber
            %extrapolation method.  {None - Clip', 'Linear', 
            % 'Cubic spline'}
            if ~(strcmpi(type,'None - Clip') || strcmpi(type,'Linear') || strcmpi(type,'Cubic spline'))
                error('Type must be either None - Flat, Linear, or Cubic spline')
            end
            obj.ExtrapMethod = ExtrapMethod;
        end
    end
    
end % classdef   

%% Revision History
% YYMMDD INI: note
%
% 110830 TKV: Added single input cell structure for eval and various help
% scripts.  
% 100630 MWS: Added ability to specify independed and dependent variable
% units.
% 100305 TKV: Moved Most of AeroElm to here: Allowed eval to work as eval,
% created table form for new properties: Created Struct input form and cell
% input form parsing.  -> Backward compatible reads of old data : updated 
% disp method to allow multiple DepVars.  
%
% 080507 TKV: added error checking and numeric input support for
% GetIndepVal method.
%**Add New Revision notes to TOP of list**

% Initials Identification: 
% INI: FullName  :  Email  :  NGGN Username 
% MWS: Mike Sufana   : mike.sufana@ngc.com   : sufanmi
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

