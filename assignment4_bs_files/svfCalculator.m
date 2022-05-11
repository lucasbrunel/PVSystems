function svf = svfCalculator(poa_azim,poa_tilt,varargin)
% Definition:
% svf = svfCalculator(poa_azim,poa_tilt,skyline_prof)
% svf = svfCalculator(poa_azim,poa_tilt,'skyline',skyline)
% svf = svfCalculator(poa_azim,poa_tilt,'plotting',true)
% svf = svfCalculator(poa_azim,poa_tilt,'skyline',skyline_prof,'plotting',true)
%
% Description:
% Calculates the sky view factor of a plane with given aximuth and tilt
% angles at a location with a specified skyline profile.
% Module azimuth range: [0,360] >> Convention:  N=0,E=90,S=180,W=270,N=360
% Module tilt range: [0,180)
%
% skyline_prof is a a logical matrix that inidicates which sky sectors are 
% visible (true) and which are blocked (false). If the skyline profile is 
% not specified, it is assumed that the horizon is free and should be equal
% to (1+cos(tilt))/2
%
% Example of use 1 - SVF of a module tilted 40deg and oriented towards South
% in a free horizon location :
%
% poa_tilt = 40;
% poa_azim = 180;
% svf = svfCalculator(poa_azim,poa_tilt,'plotting',true);
%
% Example of use 2 - SVF of a module tilted 30deg and oriented towards East
% in a location where the sky is blocked in the between 10deg and 90deg of 
% azimuth between and 10deg and 60deg of altitude:
%
% poa_tilt = 30;
% poa_azim = 90;
% ROWS = 180;
% COLS = 360;
% center_azim = repmat(linspace(0+360/(2*COLS),360-360/(2*COLS),COLS),ROWS,1);
% center_alt = repmat(linspace(90-180/(2*ROWS),-90+180/(2*ROWS),ROWS)',1,COLS);
% skyline_prof = true(size(center_azim));
% skyline_prof(center_azim>10 & center_azim<90 & center_alt>10 & center_alt<60) = false;
% svf = svfCalculator(poa_azim,poa_tilt,'skyline',skyline_prof,'plotting',true);
%%
%==========================================
% Author: Andres Calcabrini
%==========================================
%%
plotting = false;
ROWS = 180;%Default vertical resolution
COLS = 360;%Default horizontal resolution
skyline_mat = [true(ROWS/2,COLS);false(ROWS/2,COLS)];%Default skyline
    
if ~isempty(varargin)
    try
        for k = 1:2:length(varargin)
            if ischar(varargin{k}) && strcmp(varargin{k},'skyline')
                skyline_prof = varargin{k+1};
                if ischar(varargin{k}) && islogical(skyline_prof)
                    ROWS = size(skyline_prof,1);
                    COLS = size(skyline_prof,2);
                    skyline_mat = [true(ROWS/2,COLS);false(ROWS/2,COLS)];%removing the ground
                    skyline_mat = skyline_mat & skyline_prof;
                else
                    error('Invalid skyline format!');
                end
            elseif strcmp(varargin{k},'plotting')
                plotting = varargin{k+1};
            end
        end
    catch
        error('There is a problem with the extra input parameters');
    end
    
end


% Calculating the SVF
delta_azim = 2*pi/COLS;
delta_alt = pi/ROWS;
azim_ss_center=linspace(0+180/COLS,360-180/COLS,COLS);
alt_ss_center=linspace(90-90/ROWS,-90+90/ROWS,ROWS)';
% alt_ss_center = alt_ss_center(alt_ss_center>0);
jacob = repmat(cosd(alt_ss_center),1,COLS);
cos_aoi = sind(poa_tilt)*cosd(alt_ss_center)*cosd(poa_azim-azim_ss_center)+cosd(poa_tilt)*sind(alt_ss_center);
cos_aoi(cos_aoi<0) = 0;%if the projection of the POA is correct this line is not needed
sky_sector_vf = delta_azim*delta_alt*jacob.*cos_aoi/pi;
sky_vfs = skyline_mat.*sky_sector_vf;
svf = sum(sky_vfs(:));%if the projection of the POA is correct all negative values of sky_sector_vf are cancelled by skyline_mat

if plotting
    [az,alt,Z] = meshgrid(linspace(0,360,COLS+1),linspace(90,-90,ROWS+1),0);
    fig= figure('units','normalized','outerposition',[0.23 0.27 0.48 0.61]);
    ax = axes(fig);
    S = surf(ax,az,alt,Z,sky_vfs);
    S.EdgeColor = 'none';
    view(0,90);
    cmap = parula(128);
    cmap(1,:) = 0;
    colormap(cmap);
    ax.NextPlot = 'add';
    patch(ax,'Faces',[1 2 3 4],'Vertices',[0 0; 360 0; 360 90; 0 90],'FaceColor',[1 1 1],'FaceAlpha',0);
    ax.XLabel.String = 'Azimuth (\circ)';
    ax.XLabel.FontWeight = 'Bold';
    ax.YLabel.String = 'Altitude (\circ)';
    ax.YLabel.FontWeight = 'Bold';
    ax.XLim = [0 360];
    ax.YLim = [0 90];
    ax.XTick = 0:90:360;
    ax.XTickLabel = {'N = 0','E = 90','S = 180','W = 270','N = 360'};
    ax.YTick = 0:30:90;

    cb = colorbar(ax);
    cb.Label.String = 'Sky sector view factor (-)';
    cb.Label.FontWeight = 'Bold';
    cb.Label.FontSize =  16;
    ax.Box = 'on';
    ax.LineWidth = 1.2;
    ax.FontName = 'Calibri';
    ax.FontSize = 16;
end

end
