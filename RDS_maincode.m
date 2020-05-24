% >>> This is the main code to run the whole experiment
%
% Clear the workspace and the screen
sca;
close all;
clc
clear
clearvars;
% diary off; %% in case the previous other diary is not off
           %  and texts will be saved in current experiment diary
          
%% >>>>> Read in parameters
RDS_readParameters;

%% >>>>> DIALOG: subject information
%---- get subject information
Subject_prompt={'Subject name (no space)', ...
    'Session Number (for this subject)', ...
    'gender[male|female]', ...
    'age', ...
    'Left eye sight', ...
    'Right eye sight', ...
    'Passed stereo vision test?[yes|no]' ...
    'Know experiment purpose?[yes|no]'...
    'Other info.'
    };

dialog_title='Give_Subject_Information';
num_lines=1;
Subject_default_answer={'','', '','','','','','',''};
subject_info=inputdlg(Subject_prompt,dialog_title,num_lines,Subject_default_answer);

subject.Name= subject_info{1};
subject.sessionNumber = str2num(subject_info{2}); % number
subject.gender = subject_info{3};
subject.age = str2num(subject_info{4}); % number
subject.leftEyeSight = subject_info{5};
subject.rightEyeSight = subject_info{6};
subject.stereoVision = subject_info{7};
subject.knowPurpose = subject_info{8};
subject.otherInfo = subject_info{9};


%% >>>>> Set Up Display and prepare
%
% --------- creat subject data file
% exprTime = datestr(now,29); % 'yyyy-mm-dd' ?ISO 8601)
exprDay = date; clocktime = clock;
params.exprDay = exprDay; params.clocktime = clocktime;

if  ~exist(runPath+"\Subject_Result\"+subject.Name+"-"+sessionName+'-'+num2str(subject.sessionNumber)+"-"+exprDay,'file')
    mkdir(runPath+"\Subject_Result\"+subject.Name+"-"+sessionName+"-"+num2str(subject.sessionNumber)+"-"+exprDay);
end

cd(runPath+"\Subject_Result\"+subject.Name+"-"+sessionName+"-"+num2str(subject.sessionNumber)+"-"+exprDay);

% ---- Log Command Window text to file
% it includes:
%       subject and experiment key response
%       experimenter instructions text
% diaryName = "Command_Window_Text"+'-'+sessionName+'-'+exprDay+'-'+num2str(clocktime(4))+ '-'+num2str(clocktime(5));
% diary(diaryName);
% diary on;

%
% ------ Call psychtoolbox 
% !!!!!!!!!!!!!!!!!!!!! Setting for debugging
% delete when in formal experiment
PsychDebugWindowConfiguration();
Screen('Preference', 'SkipSyncTests', 1);

% for graphics;
PsychDefaultSetup(2);
[windowPtr, windowRect] = PsychImaging('OpenWindow', params.screen.SCREEN_NUM, params.screen.backgroundLum, [], [], [], params.screen.STEREO_MODE);
[mScreenXpixels, mScreenYpixels] = Screen('WindowSize', windowPtr);
[CenterXpixel, CenterYpixel] = RectCenter(windowRect);
mifi = Screen('GetFlipInterval', windowPtr);
PsychDefaultSetup(2);
PsychImaging('PrepareConfiguration');
InitializeMatlabOpenGL;
Screen('BlendFunction', windowPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
topPriorityLevel = MaxPriority(windowPtr);
Priority(topPriorityLevel); 
% Unify key code for different operating system
KbName('UnifyKeyNames');
% RestrictKeysForKbCheck(KbName('s'));

%% ///////////////////////////////////
% ------------- check parameter setting
fprintf('//////////////////////////////////////////////////\n');
fprintf("## Checking parameter setting...\n")
%
% ///// check run path 
% read current running path
fullpathname = mfilename('fullpath');
% the defined "runpath" is the file path that includes all subfiles
% The file should be named as 'Eye_Of_Origin_Singleton'
%
fullpathname = split(fullpathname,'\');
fullpathname = fullpathname(1:size(fullpathname,1)-2);
fullpathname = join(fullpathname,'\');
mrunPath = string(fullpathname);
%
% check whether the runpath is changed
if runPath ~= mrunPath
    % if changed, stop, report to reset
    fprintf("\n[ERROR]\n");
    fprintf("!!!! run path is changed. Please reset the 'runPath'\n");
    fprintf("!!!! Current path is: \n%s\n", mrunPath);    
    sca;return
end

cd(runPath+"\Codes_For_Experiments");

% ///// screen XY pixel size
% screen longer side pixel size
if  params.screen.ScreenXpixels ~= mScreenXpixels ||  params.screen.ScreenYpixels ~= mScreenYpixels
    fprintf("\n[ERROR]\n");
    fprintf("!!!! screen size is changed. Please reset the 'ScreenXpixel'\n");
    fprintf("!!!! Current ScreenXpixel is: \n%d\n", mScreenXpixels);    
    sca;return
end
% screen shorter side pixel size
if  params.screen.ScreenYpixels ~= mScreenYpixels
    fprintf("\n[ERROR]\n");
    fprintf("!!!! screen size is changed. Please reset the 'ScreenYpixel'\n");
    fprintf("!!!! Current ScreenYpixel is: \n%d\n", mScreenYpixels);   
    sca;return
end

% ////// screen refresh frequency
if round(params.screen.ifi,3) ~= round(mifi,3)
    fprintf("\n[ERROR]\n");
    fprintf("!!!! screen refresh frequency is changed. Please reset the 'ifi'\n");
    fprintf("!!!! Current ifi is: \n%d\n", mifi);    
    sca;return
end

% ///// Check buttons for response
commandwindow;
fprintf("\n## Check button input:[press ENTER]\n");
pause();

responseType = ["Left", "Right"]; % 1--left; 2--right

for iType = 1: length(responseType)
    isRightKey=0;
    while(isRightKey==0)
        % Response Key Input
        fprintf("# press button for [%s tilt bar]\n", responseType(iType));
        [~, keyCode] = KbStrokeWait;
        % record which key was pressed
        KeyChar = KbName(keyCode);
        if KeyChar(1) ~= params.buttons(iType)
            fprintf("\n[ERROR]\n");
            fprintf("!!!! button input is changed. Please reset the 'params.button'\n");
            fprintf("!!!! pre-set %s button is: \n%s\n", responseType(iType), params.buttons(iType)); 
            fprintf("!!!! Current %s button is: \n%s\n",  responseType(iType), KeyChar(1));  
            isRightKey = 0;
            sca;return
        else
            isRightKey = 1;
        end
    end
end
input("## Buttons are confirm[press any key to continue])"); %% this s to output the useless command window button inputs above
Screen('Flip', windowPtr);

fprintf("## Checking parameter setting is done\n\n")


% ------------ Shuffle seeds for random number generator, otherwise the random number
% sequence would be the same every time when you restart MATLAB.
%
% --- this is to reload the rand seed
% a = load('randstate.mat');
% randstate = a.randstate;
% rng(randstate);
randstate = rng('shuffle');

%% ///////////////////////////////////


%% >>>>> Do Test Trials
fprintf('//////////////////////////////////////////////////\n');
line_1 = 'Welcome: Test Trial';
fprintf([line_1,'\n']);

Screen('SelectStereoDrawBuffer',windowPtr,0);
Screen('DrawText', windowPtr, line_1, CenterXpixel-200, CenterYpixel, params.stim.textLum);
Screen('SelectStereoDrawBuffer',windowPtr,1);
Screen('DrawText', windowPtr, line_1, CenterXpixel-200, CenterYpixel, params.stim.textLum);
Screen('Flip', windowPtr);

% input("[press ENTER to start]\n");
KbStrokeWait;

% input variables
ConditionList = params.stim.conditionsList;
NTrialsPerCondition = params.stim.NTrialsPerCondition;
data=[];

% do trials
RDS_DoManyTrials;

% "fn_test" includes test parameters and results
fn_expr ="test-"+subject.Name+"-"+sessionName+"-"+num2str(subject.sessionNumber)+"-"+exprDay+'.mat';
save(fn_expr, "data");

%% >>>>> ending
%
% -----------------------------------------------
% Buffer: End page
% >> End of Experiment
% --------------------------------------------------------
ExperimentFinishPage = Screen('OpenOffscreenWindow', windowPtr, params.screen.backgroundLum);
Screen('DrawText', ExperimentFinishPage,  'Trials completed --- Thank you very much!!',  CenterXpixel-500, CenterYpixel-50, params.screen.maxLum);
Screen('DrawText', ExperimentFinishPage,  'please tell the experimenter your comments/observations',  CenterXpixel-700, CenterYpixel+50, params.screen.maxLum);

Screen('SelectStereoDrawBuffer',windowPtr,0);
Screen('DrawTexture', windowPtr, ExperimentFinishPage);
Screen('SelectStereoDrawBuffer',windowPtr,1);
Screen('DrawTexture', windowPtr, ExperimentFinishPage);
Screen('Flip', windowPtr);
% leave the ending page on the screen until a key press is received

fprintf("## End of Session\n");
% input("## Buffering...");input("## Buffering...");input("## Buffering...");
% input("$ This session is done");
% input("## [Experimenter] press ENTER to continue\n");
KbStrokeWait;

% 
% % >>> Input subject feedback
% % ---- subject feedback
% % >> is there "wall paper illusion" during seeing the stimuli?
% % >> other experience or accidents during performing the experiments
% % >> Do you see depth from the stimuli?
% 
% fprintf('//////////////////////////////////////////////////\n');
% fprintf("*** feedback and experience *** \n\n");
% fprintf('$ Now I will ask questions on your experience on the experiment\n')
% input("## [Experimenter] Press any key to continue\n");
% subject.feedback.depth = input('$ [1] Did you see depth:\n', 's');
% subject.feedback.rivalry = input('\n$ [2] Did you feel binocular rivalry:\n', 's');
% subject.feedback.wall_illusion = input('\n$ [3] Did you see wall illusion:\n', 's');
% subject.feedback.condition = input("\n$ [4] Did you notice sometimes your left and right eye's image are not the same?:\n", 's');
% subject.feedback.strategy = input("\n$[5] Did you use any strategy during the task?");
% subject.feedback.subjectComment = input('\n$ [6] Do you have more comment on the experiment:\n', 's');
% input("$ That's all. Thank you so much for your participation\n[press ENTER to continue]");
% subject.feedback.experimenterObserve = input("## Please input experimenter's observation:\n ", 's');

% short for "Screen('CloseAll')"
% close all buffers and textures and exit PTB 
sca;

% >>>> Save Result
%
% ---- save result and parameters
% save subject information
fn_expr ="info-"+subject.Name+"-"+sessionName+"-"+num2str(subject.sessionNumber)+"-"+exprDay+'.mat';
save(fn_expr, "subject");

% "fn_params" includes parameters from 'eoos_pre_parameters.m'
fn_expr ="params-"+subject.Name+"-"+sessionName+"-"+num2str(subject.sessionNumber)+"-"+exprDay+'.mat';
save(fn_expr, "params");

% % save the randstate
% fn_expr ="randstate-"+subject.Name+"-"+sessionName+"-"+num2str(subject.sessionNumber)+"-"+exprDay+"-"+num2str(clocktime(4))+ "-"+num2str(clocktime(5))+'.mat';
% save(fn_expr, "randstate");

% ---- end logging command window text
% diary off;
