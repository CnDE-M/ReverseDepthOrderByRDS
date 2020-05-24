%% Parameters Need to input before running this script
% per_correlate
% centerRadium
% dotSize
% disparity
% outerRadium
% crossSize
% crossPosition
% blankRadium

FlushEvents('keyDown');  % Discard all the chars from the Event Manager queue.
% get buffer page 
RDS_DrawBufferPages;

% %% (0) start one trial
% % ----- Buffer page: Next Trial Instruction Page
% % "press the button for next trial"
% Screen('SelectStereoDrawBuffer',windowPtr,0);
% Screen('DrawTexture', windowPtr, NextTrialInstructionPage)
% Screen('SelectStereoDrawBuffer',windowPtr,1);
% Screen('DrawTexture', windowPtr, NextTrialInstructionPage)
% Screen('Flip', windowPtr);
% 
% KbStrokeWait;  %--- press the button for next trial

%% (1) Prefixation Stage

% ----- Buffer page: Next Trial Instruction Page
% "press the button for next trial"
Screen('SelectStereoDrawBuffer',windowPtr,0);
Screen('DrawTexture', windowPtr, PreFixationPage)
Screen('DrawLines', windowPtr, [ct_xCoords; ct_yCoords], fix_lineWidth, params.stim.fixationPointLum, [CenterXpixel, CenterYpixel - crossPosition], 2);

Screen('SelectStereoDrawBuffer',windowPtr,1);
Screen('DrawTexture', windowPtr, PreFixationPage)
Screen('DrawLines', windowPtr, [ct_xCoords; ct_yCoords], fix_lineWidth, params.stim.fixationPointLum, [CenterXpixel, CenterYpixel - crossPosition], 2);

vbl(1) = Screen('Flip', windowPtr);

KbStrokeWait;  %--- press the button for next trial

FlushEvents('keyDown');  % Discard all the chars from the Event Manager queue.

%% Get Stimulus and Masks
% parameters setting
flipTime = vbl + RDS_waitTime;
for frame = 1:params.stim.rdsNumber
    
    % draw one RDS frame
    RDS_drawStimuli_LR;
    
    % buffer-save dot position and color
    bufferSave_inDotCoorL(:,:,frame) = l_in_DotRects;
    bufferSave_inDotColorL(:,:,frame) = inDot_lColor_RGB;
    bufferSave_inDotCoorR(:,:,frame) = r_in_DotRects;
    bufferSave_inDotColorR(:,:,frame) = inDot_rColor_RGB;
    bufferSave_otDotCoor(:,:,frame)  = ot_DotRects;
    bufferSave_otDotColorR(:,:,frame) = otDot_rColor_RGB;
    bufferSave_otDotColorL(:,:,frame)  = otDot_lColor_RGB;
    
    vbl = Screen('Flip', windowPtr, flipTime); 

    if frame==1
        StimulusOnsetTimeSec = vbl;
    end
    flipTime = vbl + RDS_waitTime;
end

%% (3) Response
% get buffer page 

% ----- Buffer page: Next Trial Instruction Page
% "press the button for next trial"
Screen('SelectStereoDrawBuffer',windowPtr,0);
Screen('DrawTexture', windowPtr, WaitForReportPage);
Screen('SelectStereoDrawBuffer',windowPtr,1);
Screen('DrawTexture', windowPtr, WaitForReportPage);
Screen('Flip', windowPtr, flipTime);        

%% -- wait for the response
[keyPressTimeSec, keyCode] = KbWait;

% record which key was pressed
KeyChar = KbName(keyCode);
KeyChar = KeyChar(1);
% Response Time of button press
RT = keyPressTimeSec-StimulusOnsetTimeSec;

%% clear buffer
% Clear buffers and textures which will not be used anymore to prevent
% overload of the graphic memory.
% Screen('Close', NextTrialInstructionPage);
Screen('Close', WaitForReportPage);
Screen('Close', PreFixationPage);


