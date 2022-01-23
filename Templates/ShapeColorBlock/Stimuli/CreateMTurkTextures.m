%% Set Up Directory Structure
curDir = pwd; %also circle directory
CIRCdir = fullfile(curDir,'circle')
ACHdir = fullfile(curDir,'achromatic');
CHdir = fullfile(curDir,'chromatic');

%% Prepare images
imageNumbers = 14;
for i = 1:imageNumbers
    [imgCH{i},~,alphaCH{i}] = imread(fullfile(CHdir, [num2str(i) '.png']));
    [imgACH{i},~,alphaACH{i}] = imread(fullfile(ACHdir, [num2str(i) '.png']));
    maskCH{i} = imread(fullfile(CHdir, [num2str(i) '_mask.png']));
    maskACH{i} = imread(fullfile(ACHdir, [num2str(i) '_mask.png']));
end

[imgCircle,~,alphaCircle] = imread(fullfile(CIRCdir, 'colorCircle.png'));
alphaCircle = 255-alphaCircle;
%% Color Params
cRED = [94, 27, 72, 21, 31, 15, 13, 7, 29, 14, 78, 24, 53, 19];
cGREEN = [33, 12, 51, 16, 64, 22, 64, 22, 49, 18, 32, 14, 48, 17];
cBLUE = [56, 17, 14, 5, 26, 9, 95, 27, 165, 45, 143, 39, 76, 23];
backgroundRGB = [31 29 47];


%% Create Colored Images
background = cat(3,uint8(zeros(size(alphaCircle))+backgroundRGB(1)),uint8(zeros(size(alphaCircle))+backgroundRGB(2)),uint8(zeros(size(alphaCircle))+backgroundRGB(3)));

for i = 1:imageNumbers
    

    chrom(:,:,:,i) = cat(3,imoverlay(imgCH{i},maskCH{i}(:,:,1),[cRED(i),cGREEN(i),cBLUE(i)]/255),alphaCH{i});
    chromBW(:,:,:,i) = cat(3,imoverlay(imgCH{i},maskCH{i}(:,:,1),backgroundRGB/255),alphaCH{i});
    achrom(:,:,:,i) = cat(3,imoverlay(imgACH{i},maskACH{i}(:,:,1),backgroundRGB/255),alphaACH{i});
    circle = zeros(size(imgCircle));
    
    red = uint8(zeros(size(alphaCircle))+cRED(i));
    green = uint8(zeros(size(alphaCircle))+cGREEN(i));
    blue = uint8(zeros(size(alphaCircle))+cBLUE(i));
    bgd = imshow(background)
    hold on
    color = cat(3,uint8(red),uint8(green),uint8(blue));
    c = imshow(color)
    set(c,'AlphaData',alphaCircle)
    set(gca,'LooseInset',get(gca,'TightInset'));
    exportgraphics(gca, [num2str(i) 'circle.png'], 'BackgroundColor','none')
    circle_import = imread([num2str(i) 'circle.png']);
    final = circle_import(9:end-8,9:end-8,:);
    colorcircles(:,:,:,i) = final;
end


%% Save the stimuli as mat files
save('chrom.mat', 'chrom')
save('chromBW.mat', 'chromBW')
save('achrom.mat', 'achrom')
save('colorcircles.mat','colorcircles')

