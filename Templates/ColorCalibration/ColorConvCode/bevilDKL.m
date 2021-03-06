% Bevil xy
% scatter(0.3265, 0.4180)
% scatter(0.3806, 0.3845)
% scatter(0.3983, 0.4616)
% scatter(0.3693, 0.5357)
% scatter(0.3023, 0.5351)
% scatter(0.2611, 0.4593)
% scatter(0.2668, 0.3834)
% scatter(0.2992, 0.3440)
% scatter(0.3420, 0.3438)


x = [0.3265,0.3806,0.3983,0.3693,0.3023,0.2611,0.2668,0.2992,0.3420,0.326 0.326,0.3263,0.3264,0.3269,0.3263,0.3261,0.3267,0.3262,0.3263];

y = [0.4180, 0.3845,0.4616,0.5357,0.5351,0.4593,0.3834,0.3440,0.3438,0.4179,0.4179,0.4191,0.4186,0.4185,0.4191,0.4189,0.4185,0.4186,0.4185];

Y = [118 118 118 118 118 118 118 118 118 122 112 131 105 135 100 142 93.6 148.6 88];

xyY = vertcat(x,y,Y);
DrawChromaticity
scatter(x,y,'+')
XYZ_bevil = xyYToXYZ(xyY)

LMSBevil = XYZtoLMS(XYZ_bevil);
LMSGray = LMSBevil(:,1);
LMSPerc = (LMSBevil-LMSGray)./LMSGray;