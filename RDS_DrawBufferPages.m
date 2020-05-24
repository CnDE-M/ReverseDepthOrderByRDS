% This is to draw the hint pages used in every trials
% pre-draw to save time and make sure they are always the same

Screen('TextSize', windowPtr, 35); 
% % --------------------------------------------------------
% % Buffer: Instruction page before next trial
% % 'Press a button for the next trial'
% % --------------------------------------------------------
% NextTrialInstructionPage = Screen('OpenOffscreenWindow', windowPtr, params.screen.backgroundLum);
% Screen('DrawText', NextTrialInstructionPage,  'Press a button for the next trial', CenterXpixel-300, CenterYpixel, params.stim.textLum);

% --------------------------------------------------------
% Buffer: Instruction page before next trial
% 'Press a button to report'
% --------------------------------------------------------
WaitForReportPage = Screen('OpenOffscreenWindow', windowPtr, params.screen.backgroundLum);
Screen('DrawText', WaitForReportPage,  'Press a button to report', CenterXpixel-250, CenterYpixel, params.stim.textLum);

% --------------------------------------------------------
% Buffer: Vergence Anchoring (fixation plus four corners)
% fixation page
% >> Before each trial, subject fixation at screen center
% --------------------------------------------------------
% ..... pre fixation page
% red fixation cross
% >>>> cross position
% cross for central vision field always exist
if mod(crossSize, 2) == 0
    ct_sideLength = crossSize/2;
else
    ct_sideLength = (crossSize+1)/2;
end
ct_xCoords = [-ct_sideLength ct_sideLength 0 0];
ct_yCoords = [0 0 -ct_sideLength ct_sideLength];

PreFixationPage = Screen('OpenOffscreenWindow', windowPtr, params.screen.backgroundLum);
leftCue = 'press any button';   rightCue = 'for the next trial';
Screen('DrawText', PreFixationPage,  leftCue, CenterXpixel-400, CenterYpixel-crossPosition, params.stim.textLum);
Screen('DrawText', PreFixationPage,  rightCue, CenterXpixel+50, CenterYpixel-crossPosition, params.stim.textLum);
