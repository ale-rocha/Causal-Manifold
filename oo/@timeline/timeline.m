classdef timeline
    properties (SetAccess=private, GetAccess=private)
        length=0;
        startTime = now;
        timestamps = zeros(0,1); %seconds 
        samplingRate = 1; %in Hz
    end
    methods
        function obj=timeline(varargin)
            if (nargin==0)
                %Keep default values
            elseif isa(varargin{1},'timeline')
                obj=varargin{1};
                return;
            else
                val=varargin{1};
                obj=set(obj,'Length',val);
                if (nargin==3)
                    if (ischar(varargin{2}))
                        cond.tag = varargin{2};
                    else
                        error('Tag must be a string');
                    end
                    if isempty(varargin{3})
                        cond.events=zeros(0,2);
                        cond.eventsInfo=cell(0,1);
                    else
                        cond.events = varargin{3};
                        cond.eventsInfo=cell(size(cond.events,1),1);
                    end
                end
            end
            assertInvariants(obj);
        end
    end
    
    methods (Access=protected)
        assertInvariants(obj);
    end
    
    methods (Access=private)
        idx=findCondition(obj,tag);
    end

end