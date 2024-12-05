% Define observation and action spaces
obsInfo = rlNumericSpec([3 1], 'LowerLimit', -Inf, 'UpperLimit', Inf, 'Name', 'observations');
actInfo = rlNumericSpec([1 1], 'LowerLimit', -1, 'UpperLimit', 1, 'Name', 'force');

% Set up the Simulink environment
env = rlSimulinkEnv('mass_damper_RL1', 'mass_damper_RL1/RL Agent', obsInfo, actInfo);

% Configure TD3 agent options
agentOpts = rlTD3AgentOptions(... 
    'SampleTime', 0.1, ... 
    'TargetSmoothFactor', 0.005, ... 
    'MiniBatchSize', 128, ... ,
    'ExperienceBufferLength', 500000, ...
    'ExplorationModel', rl.option.GaussianActionNoise('StandardDeviation', 0.3, 'StandardDeviationDecayRate', 1e-5));

% Define critic networks
statePath = [
    featureInputLayer(3, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(32, 'Name', 'stateFC')];

actionPath = [
    featureInputLayer(1, 'Normalization', 'none', 'Name', 'action')
    fullyConnectedLayer(32, 'Name', 'actionFC')];

% Create Critic 1 with a unique addition layer
commonPath1 = [
    additionLayer(2, 'Name', 'add1') 
    reluLayer('Name', 'relu1') 
    fullyConnectedLayer(1, 'Name', 'commonOutput1')];

% Assemble Critic 1 Network
critic1Network = layerGraph(statePath);
critic1Network = addLayers(critic1Network, actionPath);
critic1Network = addLayers(critic1Network, commonPath1);
critic1Network = connectLayers(critic1Network, 'stateFC', 'add1/in1');
critic1Network = connectLayers(critic1Network, 'actionFC', 'add1/in2');
critic1 = rlQValueFunction(critic1Network, obsInfo, actInfo);

% Create Critic 2 (similar to Critic 1 but with unique layer names)
commonPath2 = [
    additionLayer(2, 'Name', 'add2') 
    reluLayer('Name', 'relu2') 
    fullyConnectedLayer(1, 'Name', 'commonOutput2')];

% Assemble Critic 2 Network
critic2Network = layerGraph(statePath);
critic2Network = addLayers(critic2Network, actionPath);
critic2Network = addLayers(critic2Network, commonPath2);
critic2Network = connectLayers(critic2Network, 'stateFC', 'add2/in1');
critic2Network = connectLayers(critic2Network, 'actionFC', 'add2/in2');
critic2 = rlQValueFunction(critic2Network, obsInfo, actInfo);

% Define actor network
actorNetwork = [
    featureInputLayer(3, 'Normalization', 'none', 'Name', 'state')
    fullyConnectedLayer(32, 'Name', 'actorFC')
    reluLayer('Name', 'reluActor')
    fullyConnectedLayer(1, 'Name', 'output')
    tanhLayer('Name', 'tanh')];  % Ensure output is within [-1, 1]
actor = rlContinuousDeterministicActor(actorNetwork, obsInfo, actInfo);

% Create the TD3 agent
agent = rlTD3Agent(actor, [critic1, critic2], agentOpts);

% Configure training options
trainOpts = rlTrainingOptions(... 
    'MaxEpisodes', 500, ... 
    'MaxStepsPerEpisode', 500, ... 
    'ScoreAveragingWindowLength', 10, ... 
    'StopTrainingCriteria', 'AverageReward', ... 
    'StopTrainingValue', 1500, ... 
    'Verbose', false, ... 
    'Plots', 'training-progress');

% Train the agent
trainingStats = train(agent, env, trainOpts);
