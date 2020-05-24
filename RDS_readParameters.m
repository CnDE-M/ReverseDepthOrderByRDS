% This script is to save and initialize all items' parameters before the experiement
%
% >>>>> Before using, please set variables:
% runPath
%
%--------------------------------------------------------------------------
% parameters setting refering 
% "Reversed depth in anti-correlated random dot stereograms and the central-peripheral difference in visual inference"
%--------------------------------------------------------------------------
% symbol meaning:
% ??? variable changed between experiment
% *** variable need to confirm when codes are initialized in a new 
%
%

%% >>>>> Run path: file where the codes are
runPath = "????"; % ***

% initialize as empty
params = []; 

%% >>>>> session name
params.sessionOptions = {'expr1_1','expr1_2','expr1_3','expr1_4','expr1_5','expr2_1','expr3_1'};

%% >>>>> DIALOG: experiment type
[indx,~] = listdlg('PromptString',{'select one session name'},...
                    'SelectionMode','single','ListString',params.sessionOptions );

sessionName = string(params.sessionOptions(indx));      

%% >>>>> Button setting
params.buttons = ['1','2']; % *** 1 - left | 2 - right

%% >>>>> Screen settings
% specify which monitor to use
params.screen.SCREEN_NUM = 0 ;  
% stereomode 8 means red-blue anaglyph
params.screen.STEREO_MODE = 8;
% background color
params.screen.minLum = 0; % black 
% foreground color
params.screen.maxLum = 1; % white 
% red
params.screen.red = [1, 0, 0];
% 
params.screen.backgroundLum = [0.5, 0.5, 0.5];
% screen physical size
% width-shorter side | height-longer side
[~,params.screen.displayPhysicalWidthMM] = Screen('DisplaySize', params.screen.SCREEN_NUM);  %mm
% screen pixel size
params.screen.ScreenXpixels = 1920; % ***
params.screen.ScreenYpixels = 1080; % ***
% screen refresh frequency
params.screen.ifi = 0.0167; % ***

%% [METHOD] from visual angle to pixel size
% These parameter would determine the stimulus size, please varify them.
params.screen.viewingDistanceMM = 400;  %mm
PixelPerDegreeVA =  params.screen.ScreenYpixels / (2 * atand(params.screen.displayPhysicalWidthMM / 2 / params.screen.viewingDistanceMM));


%% >>>>> Stimuli Images

% -----#[text] 
params.stim.textLum = params.screen.maxLum; % text in trials
params.stim.instLum = [1,1,0]; % instruction test luminance

% -----#[Fixation Cross]
% params.stim.crossSize          % ???
% params.stim.ct_crossPosition      % ???
params.stim.fixationPointLum = params.screen.red;
param.stim.fixationlineWidth = 4;  fix_lineWidth = param.stim.fixationlineWidth;
% -----#[disparity]
% params.stim.disparity % ???
% params.stim.ifDisparityReverse

% -----#[random dot]
% params.stim.dotSize = [,]; % ???
params.stim.dotColorType = [0, 1];
params.stim.dotColorRate = [0.5, 0.5];
params.stim.dotDensity = 0.25;

% -----#[radium]
% params.stim.centerRadium = [,]; % ???
% params.stim.outerRadium = [,]; % ???
% params.stim.blankRadium = [,]; % ???

% -----[display duration]
params.stim.rdsDuration = 0.1; 
params.stim.rdsNumber = 15; 
RDS_waitTime = (round(params.stim.rdsDuration/params.screen.ifi)-0.5) * params.screen.ifi ;

%% >>>>> Trials Conditions Setting
% ..... stimuli
% for all the list, column 1 is for central vision field; column 2 is for peripheral vision field
if sessionName == "expr1_1"
    params.stim.dotSizeList = [0.348, 0.348];
    params.stim.centerRadiumList = [3, 3]; 
    params.stim.outerRadiumList = [4.3, 4.3];
    params.stim.disparityList = [0.087, 0.087];
    params.stim.crossPositionList = [3.65, 10.1];
    params.stim.crossSizeList = [0.44, 0.44];      
    params.stim.blankRadiumList = [0, 0];  % 0 means this is an invalid variable
    
    params.stim.ifDisparityReverse = 0;
    params.stim.conditionsCorrelation = [0;   % full-correlated
                                         0.5; % half-correlated
                                         1];  % anti-correlated
    
elseif sessionName == "expr1_2"
    params.stim.dotSizeList = [0.174, 0.348];
    params.stim.centerRadiumList = [1.5, 3]; 
    params.stim.outerRadiumList = [2.15, 4.3];
    params.stim.disparityList = [0.044, 0.087]; 
    params.stim.crossPositionList = [1.83, 10.1];
    params.stim.crossSizeList = [0.22, 0.44];      
    params.stim.blankRadiumList = [0, 0];  % 0 means this is an invalid variable

    params.stim.ifDisparityReverse = 0;
    params.stim.conditionsCorrelation = [0;   % full-correlated
                                         0.5; % half-correlated
                                         1];  % anti-correlated
   
elseif sessionName == "expr1_3"
    params.stim.dotSizeList = [0.174, 0.348];
    params.stim.centerRadiumList = [1.5, 3]; 
    params.stim.outerRadiumList = [2.15, 4.3];
    params.stim.disparityList = [0.087, 0.174]; 
    params.stim.crossPositionList = [1.83, 10.1];
    params.stim.crossSizeList = [0.22, 0.44];      
    params.stim.blankRadiumList = [0, 0];  % 0 means this is an invalid variable
    
    params.stim.ifDisparityReverse = 0;
    params.stim.conditionsCorrelation = [0;   % full-correlated 
                                         0.5; % half-correlated
                                         1];  % anti-correlated

elseif sessionName == "expr1_4"
    params.stim.dotSizeList = [0.348, 0.348];
    params.stim.centerRadiumList = [3, 3]; 
    params.stim.outerRadiumList = [4.7, 4.7];
    params.stim.disparityList = [0.087, 0.087]; 
    params.stim.crossPositionList = [4.1, 10.1];
    params.stim.crossSizeList = [0.44, 0.44];      
    params.stim.blankRadiumList = [3.65, 3.65];  % 0 means this is an invalid variable
   
    params.stim.ifDisparityReverse = 0;
    params.stim.conditionsCorrelation = [0;   % full-correlated
                                         0.5; % half-correlated
                                         1];  % anti-correlated
                                     
elseif sessionName == "expr1_5"
    params.stim.dotSizeList = [0.174, 0.348];
    params.stim.centerRadiumList = [1.5, 3]; 
    params.stim.outerRadiumList = [2.35, 4.7];
    params.stim.disparityList = [0.044, 0.087]; 
    params.stim.crossPositionList = [2.05, 10.1];
    params.stim.crossSizeList = [0.22, 0.44];      
    params.stim.blankRadiumList = [1.825, 3.65]; 
   
    params.stim.ifDisparityReverse = 0; 
    params.stim.conditionsCorrelation = [0;   % full-correlated
                                     0.5; % half-correlated
                                     1];  % anti-correlated
    
elseif sessionName == "expr2_1"
    params.stim.dotSizeList = [0.348, 0.348];
    params.stim.centerRadiumList = [3, 3]; 
    params.stim.outerRadiumList = [4.3, 4.3];
    params.stim.disparityList = [0.087, 0.087]; 
    params.stim.crossPositionList = [3.65, 10.1];
    params.stim.crossSizeList = [0.44, 0.44];      
    params.stim.blankRadiumList = [0, 0];  % 0 means this is an invalid variable
    
    params.stim.ifDisparityReverse = 0;
    params.stim.conditionsCorrelation = [0.7;   
                                         0.8; 
                                         0.9]; 
                                     
 elseif sessionName == "expr3_1"
    params.stim.dotSizeList = [0.348, 0.348];
    params.stim.centerRadiumList = [3, 3]; 
    params.stim.outerRadiumList = [4.3, 4.3];
    params.stim.disparityList = [0.087, 0.087]; 
    params.stim.crossPositionList = [3.65, 10.1];
    params.stim.crossSizeList = [0.44, 0.44];      
    params.stim.blankRadiumList = [0, 0];  % 0 means this is an invalid variable
     
    params.stim.ifDisparityReverse = 1;
    params.stim.conditionsCorrelation = [0.5;   
                                         0.8; 
                                         0.9]; 
   
end

centerRadiumList = params.stim.centerRadiumList * PixelPerDegreeVA;
outerRadiumList = params.stim.outerRadiumList * PixelPerDegreeVA;
blankRadiumList = params.stim.blankRadiumList * PixelPerDegreeVA;
dotSizeList = round(params.stim.dotSizeList * PixelPerDegreeVA);
disparityList = round(params.stim.disparityList * PixelPerDegreeVA);
crossPositionList = round(params.stim.crossPositionList * PixelPerDegreeVA);
crossSizeList = round(params.stim.crossSizeList * PixelPerDegreeVA);

% ..... condition list
params.stim.conditionsVisionField = [1;  %  1 - central 
                                     2]; %  2 - peripheral
                               
% params.stim.conditionsCorrelation = [0;   % full-correlated
%                                      0.5; % half-correlated
%                                      1];  % anti-correlated
                               
params.stim.conditionsList=[];
params.stim.conditionsList(:,1) = repmat(params.stim.conditionsVisionField, [size(params.stim.conditionsCorrelation,1), 1]);
params.stim.conditionsList(:,2) = repelem(params.stim.conditionsCorrelation, size(params.stim.conditionsVisionField, 1));                          

% ..... Trial numbers per condition per subject 
params.stim.NTrialsPerCondition = 50; % formal experiment 90





