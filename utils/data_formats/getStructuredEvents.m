function [structData] = getStructuredEvents(Events)
   Phase = [];
   PhaseCos =[];
   PhaseSin = [];
   Frequency = [];
   Time = [];
   InfoChanel = [];
   InfoMeasured = [];
   PathCones = [];
   
   for i = 1:size(Events,2)
       Phase = [Phase,Events(i).Phase];
       PhaseCos = [PhaseCos,Events(i).PhaseCos];
       PhaseSin = [PhaseSin,Events(i).PhaseSin];
       Frequency = [Frequency,Events(i).Frequency];
       Time = [Time,Events(i).Time];
       InfoChanel = [InfoChanel,Events(i).InfoChanel];
       InfoMeasured = [InfoMeasured,Events(i).InfoMeasure];
       PathCones =[PathCones,Events(i).PathCones];
   end
   
   structData.Phase = Phase;
   structData.PhaseCos = PhaseCos;
   structData.PhaseSin = PhaseSin;
   structData.Frequency = Frequency;
   structData.Time = Time;
   structData.InfoChanel = InfoChanel;
   structData.InfoMeasure = InfoMeasured;
   structData.PathCones = PathCones;
   
end
