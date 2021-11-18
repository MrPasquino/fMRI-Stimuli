function [fixGridTex, retinoTex, motionTex] = MakePTBtextures(params, window)
    
    if ~ispc && ~ismac
        progressBar = waitbar(0, sprintf(' '));
        wax = findobj(progressBar, 'type','axes');
        tax = get(wax,'title');
        set(tax,'fontsize',24)
        waitbar(0.1, progressBar, sprintf('Loading fixation grid texture...\n'));
    else
        progressBar = waitbar(0.1, sprintf('Loading fixation grid texture...\n'));
    end
    
    % Loading stimulus files
    load([params.directory.stimuli '/' 'isStimOn.mat'], 'isStimOn');
    load([params.directory.stimuli '/' 'mask.mat'], 'mask');
    load([params.directory.stimuli '/' 'pattern.mat'], 'pattern');
    load([params.directory.stimuli '/' 'fixGrid.mat'], 'fixGrid');
    fixGridTex = Screen('MakeTexture', window, fixGrid);
    
    % Creating the movie 4D array by repeating the stimulus pattern
    retinoTex = NaN(length(isStimOn), 1);
    waitbar(0.2, progressBar, sprintf('Loading retinotopy stimulus textures...\n'));
    retinoMovie = repmat(pattern, 1, 1, 1, ceil(length(isStimOn) / size(pattern,ndims(pattern))));
    waitbar(0.3, progressBar);
    retinoMovie(1, 1, 4, :) = 0;
    
    % Applying aperture values to movie transparency layer (and creating the texture frames)
    waitbar(0.5, progressBar, sprintf('Creating retinotopy stimulus bar apertures...\n'));
    for idx = 1:length(isStimOn)
        if isStimOn(idx)
            retinoMovie(:, :, 4, idx) = mask(:, :, idx);
            retinoTex(idx) = Screen('MakeTexture', window, retinoMovie(:, :, :, idx));
            waitbar(0.5 + (idx/length(isStimOn))/2, progressBar);
        end
    end
    
    % Adjusting the number of frames to the desired playback speed (60Hz -> 15Hz)
    playbackFps = size(retinoMovie,ndims(retinoMovie)) / params.run.exactDuration;
    retinoTex    = repelem(retinoTex, params.display.fps/playbackFps);
    waitbar(1, progressBar, sprintf('Loading complete.\n'));
    close(progressBar);
    motionTex = retinoTex;
    
end