% Changes Screen Color
% Stuart J Duffield 2021-12-14
targColorF = 'C:\Users\duffieldsj\Documents\GitHub\fMRI-Stimuli\Templates\ColorCalibration\targXYZ.csv'
startRGBF = ''
thresh = 1; % Import to set this specifically for each
targType = 'XYZ';

global PRport
PRport = 'COM6';
StepSize = 1;
ScreenSize = [];
KbName('UnifyKeyNames');
Screen('Preference', 'SkipSyncTests', 1); 
Screen('Preference', 'VisualDebugLevel', 0);
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SuppressAllWarnings', 1);
color = [0 0 0];
textcolor = [255 255 255] - color;
screen = max(Screen('Screens'));
[Window, Rect] = Screen('OpenWindow', screen, color, ScreenSize);
Screen('DrawText', Window, num2str(color),[],[],textcolor);
Screen('Flip',Window);
mNum = 1; % Measure Numberp
measurements = struct('targColor',{},'targType'{},'colorNumber',{},'gunVals',{},'xyY',{},'XYZ',{},'xyYJudd',{},'XYZJudd',{},'LMS',{},'spectra',{},'magnitideDiff');
date_time=strrep(strrep(datestr(datetime),' ','_'),':','_')

saveFile = ['automaticMeasurements\' date_time];
targColors = csvread(targColorF);
startRGBs = round(csvread(startRGBF));

for i = 1:size(startRGBs,1)
    targColor = targColors(i,:);
    initRGB = startRGBs(i,:);
    color = initRGB;
    while true
        changeColor(color,Window);
        [measurements,mNum]=getMeasure(measurements,mNum,color,i,targType,targColor);
        [nextcolor,mag,measurements] = colorDescent(measurements,targColor,targType,thresh);
        allRGBs = reshape(extractfield(measurements,'gunVals'),3,[]);
        currRGBs = allRGBs(extractfield(measurements,'colorNumber')==i)';
        if ismember(nextcolor,currRGBs,'row')
            disp('Next color has already been measured, stopping now')
            break
        end
        color = nextcolor;
    end
end
sca;
save(saveFile, 'measurements');




        
        

    


        

function changeColor(color, Window)
    textcolor = [255 255 255] - color;
    Screen('FillRect',Window,color);
    Screen('DrawText', Window, num2str(color),0,0,textcolor);
    Screen('Flip',Window);
    disp(color)   
end

function [measurements,mNum] = getMeasure(measurements,mNum,color,colornumber,targType,targColor)
    [xyYcie, XYZcie, xyYJudd, XYZJudd, LMS, spec] = getPR655;
    disp(['Measuring color' num2str(color)])
    disp(['xyY1931 Values are: ' num2str(xyYcie)])
    disp(['XYZ1931 Values are: ' num2str(XYZcie)])
    disp(['xyY Judd Values are: ' num2str(xyYJudd)])
    disp(['XYZJudd Values are: ' num2str(XYZJudd)])
    disp(['LMS Values are: ' num2str(LMS)])
    measurements(mNum).targColor = targColor;
    measurements(mNum).colorNumber = colornumber;
    measurements(mNum).targType = targType;
    measurements(mNum).gunVals = color;
    measurements(mNum).xyY = xyYcie;
    measurements(mNum).XYZ = XYZcie;
    measurements(mNum).xyYJudd = xyYJudd;
    measurements(mNum).XYZJudd = XYZJudd;
    measurements(mNum).LMS = LMS;
    measurements(mNum).spectra = spec;
    disp(mNum)
    mNum = mNum + 1; 
end

function [nextcolor,mag,measurements] = colorDescent(measurements,targColor,targType,thresh)
    switch targType
        case 'XYZ'
            measure = measurements(end).XYZ;
        case 'LMS'
            measure = measurements(end).LMS;
        case 'XYZJudd'
            measure = measurements(end).XYZJudd;
    end
    color = measurements(end).gunVals;
    nextcolor = color;
    diff = targColor-measure;
    mag = norm(diff)
    measurements(end).magnitudeDiff = mag;
    for j = 1:3
        if diff(j) < -thresh
            nextcolor(j) = nextcolor(j) - 1;
        elseif diff(j) > thresh
            nextcolor(j) = nextcolor(j) +1;
        end
    end
end

            

        