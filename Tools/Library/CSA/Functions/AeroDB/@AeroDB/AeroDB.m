classdef AeroDB
    %file: @AeroDB\AeroDB.m
    properties
        AeroElms = {};
    end % of Public Properties
    
    methods
        function obj = AeroDB(AeroElms)
            obj.AeroElms = AeroElms;
        end % of Constructor
        
        %% Meth: disp
        function disp(obj)
            len = length(obj.AeroElms);
            
            for i = 1:len
                obj.AeroElms{i}.disp;
            end
        end
        
        %% Meth: count
        function n = count(obj)
            n = length(obj.AeroElms);
        end
        
        %% Meth: add
        function add(obj, AeroElm)
            obj.AeroElms{obj.count + 1} = AeroElm;
        end
        
        %% Meth: addRange
        function addRange(obj, AeroElms)
            obj.AeroElms = [obj.AeroElms AeroElms];
        end
        
        %% Meth: delete
        function delete(obj, Name)
            n = obj.count;
            elms = [];
            
            for i = 1:n
                if strcmp(obj.AeroElms{i}.Name, Name)
                    elms = [elms i];
                end
            end
            
            obj.AeroElms(elms) = [];
        end
    end %of methods 
        
end %of class
