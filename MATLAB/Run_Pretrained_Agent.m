% Load the pre-trained RL agent
load('agent.mat', 'agent'); % Ensure 'agent.mat' contains the variable 'agent'

% Specify the Simulink model name
modelName = 'Simscape_Simulink_Mass_Spring_Damper_RL';

% Open the Simulink model (if not already open)
open_system(modelName);
