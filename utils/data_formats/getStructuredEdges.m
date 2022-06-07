function [structData] = getStructuredEdges(Edges)
   PhaseA = [];
   PhaseB =[];
   PhaseCosA = [];
   PhaseCosB =[];
   PhaseSinA = [];
   PhaseSinB =[];
   FrequencyA = [];
   FrequencyB = [];
   TimeA = [];
   TimeB = [];
   
   for i = 1:size(Edges,2)
       PhaseA = [PhaseA,Edges(i).PhaseA];
       PhaseB = [PhaseB,Edges(i).PhaseB];
       PhaseCosA = [PhaseCosA,Edges(i).PhaseCosA];
       PhaseCosB = [PhaseCosB,Edges(i).PhaseCosB];
       PhaseSinA = [PhaseSinA,Edges(i).PhaseSinA];
       PhaseSinB = [PhaseSinB,Edges(i).PhaseSinB];
       FrequencyA = [FrequencyA,Edges(i).FrequencyA];
       FrequencyB = [FrequencyB,Edges(i).FrequencyB];
       TimeA = [TimeA,Edges(i).TimeA];
       TimeB = [TimeB,Edges(i).TimeB];
   end
   
   structData.PhaseA = PhaseA;
   structData.PhaseB = PhaseB;
   structData.PhaseCosA = PhaseCosA;
   structData.PhaseCosB = PhaseCosB;
   structData.PhaseSinA = PhaseSinA;
   structData.PhaseSinB = PhaseSinB;
   structData.FrequencyA = FrequencyA;
   structData.FrequencyB = FrequencyB;
   structData.TimeA = TimeA;
   structData.TimeB = TimeB;
   
   
end
