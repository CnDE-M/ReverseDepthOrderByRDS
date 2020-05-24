% Draw left and right eye's RDS circle of radium "outerRadium"
% The center disk of radium "centerRadium" has horizontal disparity
% The stimuli will draw on the screen by anaglyph mode
%
% >>>>> Input Argument:
% per_correlate
% centerRadium
% dotSize
% disparity
% outerRadium
% crossSize
% crossPosition
%

%% ..... center disk Dots
%  Initialize dots properties including: size, postion(coordinates) and color
% >>>>> Dot Number
% according to the constant dot density
inDot_number = round( centerRadium^2*pi*params.stim.dotDensity / dotSize^2); % constant area taken by dot

% >>>> Dot Size
if mod(dotSize, 2) == 0
    dotSize_half_up = dotSize/2;
    dotSize_half_down = dotSize/2;
else
    dotSize_half_up = (dotSize+1)/2;
    dotSize_half_down = (dotSize-1)/2;
end
% dots are square in experiment, we use "FillRect" to draw square.
% dot size determine base square coordinate.
dotBaseRect = [-dotSize_half_up, -dotSize_half_up, dotSize_half_down, dotSize_half_down];

% >>>> Dot Position
% "Dot position" is dot center point coordinate
% Dots are randomly generated within circle area
%
% (1) polar coordinate [theta. radium] centered at (0,0).
%
%     radium^2 is randomly generated within [0, R^2]
%     theta is randomly  generated within [0, 2*pi]
%
inDot_theta=[]; inDot_r=[];inDot_x=[];inDot_y=[];in_DotRects=[];
inDot_theta =rand(1,inDot_number)*2*pi;
inDot_r = sqrt( rand(1,inDot_number)*(centerRadium)^2 );
%
% (2) transfer to cartesian coordinate
%
inDot_x = ceil(inDot_r .* cos(inDot_theta)) + CenterXpixel;
inDot_y = ceil(inDot_r .* sin(inDot_theta)) + CenterYpixel;   

% generate square coordinates based on each dot center point
for ii = 1:inDot_number
    in_DotRects(:, ii) = CenterRectOnPointd(dotBaseRect, inDot_x(ii), inDot_y(ii));
end    

% >>>> Dot Correlation
% Dot Color
% equally possibility of white or black
inDot_color_raw = []; inDot_Color_RGB=[]; contrast_column=[];

inDot_color_raw = randsrc(1,inDot_number,[params.stim.dotColorType; params.stim.dotColorRate]);
inDot_Color_RGB = repmat(inDot_color_raw,[3,1]);

% "Coordinate Properties" of dots in inner disk
%  with "per_correlated" percentage of dots will turn to contrast color 
%       Change the right vision dots'color, 
%       while keep left vision dots'color constant
%
% randomly select "per_correlate" percentage of columns to reverse contrast
contrast_num = round(inDot_number * per_correlate);
contrast_column = [ones([1,contrast_num]),zeros([1,inDot_number - contrast_num])];
contrast_column = contrast_column(randperm( inDot_number ));
contrast_column = [1:inDot_number] .* contrast_column;
contrast_column(contrast_column==0)=[];
unContrast_column = setdiff([1:inDot_number], contrast_column);

% contrast color of dots selected
%%%% dots in left vision are unchanged
inDot_lColor_RGB=[]; inDot_rColor_RGB =[];
inDot_lColor_RGB = inDot_Color_RGB;
%%%% dots in right vision are changed.
inDot_rColor_RGB = inDot_Color_RGB;
inDot_rColor_RGB(:,contrast_column) = ~inDot_rColor_RGB(:,contrast_column); 

% >>> disparity move
% move both left and right vision dots in opposite direction
% make sure disparity step is integer
% also randomize the disparity direction
if rem(disparity,2) == 0
    d = disparity / 2;
else
    d = (disparity + 1) / 2;
end
% randomize the disparity direction
d = d *(-1)^disparityDirection;
l_in_DotRects=[]; r_in_DotRects=[];

if params.stim.ifDisparityReverse == 1
    % left image dot coordinates: x + disparity value
    l_in_DotRects = in_DotRects;
    l_in_DotRects(1,unContrast_column) = in_DotRects(1,unContrast_column)+d;
    l_in_DotRects(3,unContrast_column) = in_DotRects(3,unContrast_column)+d;
    l_in_DotRects(1,contrast_column) = in_DotRects(1,contrast_column)-d;
    l_in_DotRects(3,contrast_column) = in_DotRects(3,contrast_column)-d;

    % right image dot coordinates: x - disparity value
    r_in_DotRects = in_DotRects;
    r_in_DotRects(1,unContrast_column) = in_DotRects(1,unContrast_column)-d;
    r_in_DotRects(3,unContrast_column) = in_DotRects(3,unContrast_column)-d;
    r_in_DotRects(1,contrast_column) = in_DotRects(1,contrast_column)+d;
    r_in_DotRects(3,contrast_column) = in_DotRects(3,contrast_column)+d;
    
elseif  params.stim.ifDisparityReverse == 0
    % left image dot coordinates: x + disparity value
    l_in_DotRects = in_DotRects;
    l_in_DotRects(1,:) = in_DotRects(1,:)+d;
    l_in_DotRects(3,:) = in_DotRects(3,:)+d;

    % right image dot coordinates: x - disparity value
    r_in_DotRects = in_DotRects;
    r_in_DotRects(1,:) = in_DotRects(1,:)-d;
    r_in_DotRects(3,:) = in_DotRects(3,:)-d;
end

%% ..... outer disk Dots    
% >>>> Dot Number
% According to the constant dot density, calculate dots number in the frame
otDot_number = round( (outerRadium^2) * pi * params.stim.dotDensity / dotSize^2); % constant area taken by dot

% >>>> Dot Position
% dot center point coordinate
%
% dot generate randomly within circle area
% randomly generate polar coordinate [theta. radium] centered at (0,0)
otDot_theta=[]; otDot_r=[]; otDot_x=[]; otDot_y=[];ot_DotRects=[];

otDot_theta =rand(1,otDot_number)*2*pi;
otDot_r = sqrt( rand(1,otDot_number)*(outerRadium)^2 );
% from polar coordinate to cartesion coordinate
otDot_x = ceil(otDot_r .* cos(otDot_theta)) + CenterXpixel;
otDot_y = ceil(otDot_r .* sin(otDot_theta)) + CenterYpixel;   

for ii = 1:otDot_number
    ot_DotRects(:, ii) = CenterRectOnPointd(dotBaseRect, otDot_x(ii), otDot_y(ii));
end    

% >>>> Dot Color
% equal possibility of white or black
otDot_color_raw = []; otDot_Color_RGB=[]; otDot_rColor_RGB=[]; otDot_lColor_RGB=[];

% full-correlated for all onter disk dots
otDot_color_raw = randsrc(1,otDot_number,[[0,1]; [0.5,0.5]]);
otDot_Color_RGB = repmat(otDot_color_raw,[3,1]);
otDot_rColor_RGB = otDot_Color_RGB;
otDot_lColor_RGB = otDot_Color_RGB;

%% ..... blank ring 
if  blankRadium>0 % experiment 4-5 
    % no dots at surrounding ring  
    % change dots'color at surrounding ring into grey(background color)
    distance_l = (otDot_x - CenterXpixel).^2 +(otDot_y - CenterYpixel).^2;
    mask_column=[];
    mask_column = find(distance_l<=blankRadium^2);
    for ii = 1:length(mask_column)
        otDot_lColor_RGB(:, mask_column(ii)) = params.screen.backgroundLum;   
        otDot_rColor_RGB(:, mask_column(ii)) = params.screen.backgroundLum;   
    end  

    % >>>> sort dots by color
    % grey dot in the front, so that grey-dots(blank dots) will not cover visible dots
    column_seq = [mask_column, find(distance_l>=blankRadium^2)];
    otDot_lColor_RGB = otDot_lColor_RGB(:,column_seq);
    otDot_rColor_RGB = otDot_rColor_RGB(:,column_seq);
    ot_DotRects = ot_DotRects(:,column_seq);
        
else
    % >>>> experiment 1-3
    % left
    lCenter_x = CenterXpixel+d;
    lCenter_y = CenterYpixel;
    distance_l = (otDot_x - lCenter_x).^2 +(otDot_y - lCenter_y).^2;
    l_mask_column = [];
    l_mask_column = find(distance_l<=centerRadium^2);
    otDot_lColor_RGB =otDot_Color_RGB;
    for ii = 1:length(l_mask_column)
        otDot_lColor_RGB(:, l_mask_column(ii)) = params.screen.backgroundLum;    
    end

    % right
    rCenter_x = CenterXpixel-d;
    rCenter_y = CenterYpixel;
    distance_r = (otDot_x - rCenter_x).^2 +(otDot_y - rCenter_y).^2;
    r_mask_column=[];
    r_mask_column = find(distance_r<=centerRadium^2);
    otDot_rColor_RGB =otDot_Color_RGB;
    for ii = 1:length(r_mask_column)
        otDot_rColor_RGB(:, r_mask_column(ii)) = params.screen.backgroundLum;    
    end

   % >>>> sort dots by color
    % grey dot in the front, so that grey-dots(blank dots) will not cover visible dots
    mask_column=[];
    mask_column = union(r_mask_column, l_mask_column);
    column_seq = [mask_column, setdiff([1:otDot_number],mask_column)];
    otDot_lColor_RGB = otDot_lColor_RGB(:,column_seq);
    otDot_rColor_RGB = otDot_rColor_RGB(:,column_seq);
    ot_DotRects = ot_DotRects(:,column_seq);       
end


%% red fixation cross
% >>>> cross position
% cross for central vision field always exist
if mod(crossSize, 2) == 0
    ct_sideLength = crossSize/2;
else
    ct_sideLength = (crossSize+1)/2;
end
ct_xCoords = [-ct_sideLength ct_sideLength 0 0];
ct_yCoords = [0 0 -ct_sideLength ct_sideLength];
% 

%% /////////////////// draw the stimuli pages ////////////////////////

% draw stimuli page
Screen('SelectStereoDrawBuffer',windowPtr,0);
Screen('FillRect', windowPtr, otDot_lColor_RGB ,ot_DotRects);
Screen('FillRect', windowPtr, inDot_lColor_RGB ,l_in_DotRects);
Screen('DrawLines', windowPtr, [ct_xCoords; ct_yCoords], fix_lineWidth, params.stim.fixationPointLum, [CenterXpixel, CenterYpixel - crossPosition], 2);

Screen('SelectStereoDrawBuffer',windowPtr,1);
Screen('FillRect', windowPtr, otDot_rColor_RGB ,ot_DotRects);
Screen('FillRect', windowPtr, inDot_rColor_RGB ,r_in_DotRects);
Screen('DrawLines', windowPtr, [ct_xCoords; ct_yCoords], fix_lineWidth, params.stim.fixationPointLum, [CenterXpixel, CenterYpixel - crossPosition], 2);

    