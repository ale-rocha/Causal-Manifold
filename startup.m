
% @author Rocha-Solache

mypath=[pwd filesep];

%%Setup path
addpath(mypath);
addpath([mypath 'GUI']);
addpath([mypath 'oo']);
addpath([mypath 'plotting']);
addpath([mypath 'Config']);
addpath([mypath 'legacy']);
addpath([mypath 'IO']);
addpath([mypath 'Drafts']);
addpath([mypath 'utils']);
addpath([mypath 'utils/data_simulations']);
addpath([mypath 'utils/distances']);
addpath([mypath 'utils/projections']);
addpath([mypath 'plotting/Manifolds']);

cd(mypath);
clear mypath
