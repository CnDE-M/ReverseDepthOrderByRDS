params.stim.ifDisparityReverse% >>>> Input
% ---- ConditionList: conditions types included in the session
% ---- NTrialsPerCondition: trials number per condition
%
% >>>> Output
% ---- data: trial details + subject response

%% Set the sequence of trials as randomly interleaving conditions.

% "TrialSeq" is a list of stimuli conditions
% --- trial relevant conditions
TrialsSeq = [];
NConditions=size(ConditionList, 1); % Total number of conditions
TrialsSeq(:,1) = repelem([1:NConditions]', NTrialsPerCondition);
NTrials = size(TrialsSeq,1);

% --- disparity direction
disparityDirectionList = [];
disparityDirectionList = repmat([0;1],[NTrials/2,1]);
TrialsSeq(:,2) = disparityDirectionList;

% randomize sequence
seq = randperm(NTrials);
TrialsSeq = TrialsSeq(seq,:);

%% -- loop for each trial
for iTrial=1:NTrials
    
    % -- parameter setting
    iTrial_condition = ConditionList(TrialsSeq(iTrial,1), :);
    visionField = iTrial_condition(1);
    per_correlate = iTrial_condition(2);
    centerRadium = centerRadiumList(visionField);
    dotSize = dotSizeList(visionField);
    disparity = disparityList(visionField);
    outerRadium = outerRadiumList(visionField);
    blankRadium = blankRadiumList(visionField);
    crossSize = crossSizeList(visionField);
    crossPosition = crossPositionList(visionField);
    
    disparityDirection = TrialsSeq(iTrial,2);
    
    % -- do the trial, record responses.
    RDS_DoATrial;
    
    FlushEvents('keyDown');	% Discard all the chars from the Event Manager queue.
    
    % -- save the data
    % make sure data saved are enough to repeat the 
    % The lines of data saving for other sessions are commented
    data{iTrial,1} = iTrial_condition;
    data{iTrial,2} = KeyChar;   %--- response button pressed
    data{iTrial,3} = RT;   %--- from bar stimuli onset to button press
    data{iTrial,4} = bufferSave_inDotCoorL;  
    data{iTrial,5} = bufferSave_inDotColorL; 
    data{iTrial,6} = bufferSave_inDotCoorR;
    data{iTrial,7} = bufferSave_inDotColorR; 
    data{iTrial,8} = bufferSave_otDotCoor;
    data{iTrial,9} = bufferSave_otDotColorR;
    data{iTrial,10} = bufferSave_otDotColorL;
    data{iTrial,11} = disparityDirection;
    % buffer saving all variables in workspace in case of code middle breaking

    save('allVariables.mat');
end