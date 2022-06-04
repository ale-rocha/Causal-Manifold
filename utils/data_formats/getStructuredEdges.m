function [structData] = getStructuredEdges(Edges)
   PhaseA = [];
   PhaseB =[];
   FrequencyA = [];
   FrequencyB = [];
   TimeA = [];
   TimeB = [];
   
   for i = 1:size(Edges,2)
       PhaseA = [PhaseA,Edges(i).PhaseA];
       PhaseB = [PhaseB,Edges(i).PhaseB];
       FrequencyA = [FrequencyA,Edges(i).FrequencyA];
       FrequencyB = [FrequencyB,Edges(i).FrequencyB];
       TimeA = [TimeA,Edges(i).TimeA];
       TimeB = [TimeB,Edges(i).TimeB];
   end
   
   structData.PhaseA = PhaseA;
   structData.PhaseB = PhaseB;
   structData.FrequencyA = FrequencyA;
   structData.FrequencyB = FrequencyB;
   structData.TimeA = TimeA;
   structData.TimeB = TimeB;
   
   
end
