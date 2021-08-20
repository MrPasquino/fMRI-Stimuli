function [params] = InitializeKeyboard(params)
    
    KbName('UnifyKeyNames');
    params.key.names     = {'Escape'; 'W'; 'S'; 'D'; 'C'; 'R'; 'G'; 'I'; 'K'; 'O'; 'L'; 'RightArrow'; 'LeftArrow'; 'UpArrow'; 'DownArrow'};
    params.key.functions = {'abortRun'; ...
                            'increaseFixWindowSize'; ...
                            'decreaseFixWindowSize'; ...
                            'toggleFixDot'; ...
                            'centerFix'; ...
                            'manualReward'; ...
                            'toggleFixGrid'; ...
                            'increaseXgain'; ...
                            'decreaseXgain'; ...
                            'increaseYgain'; ...
                            'decreaseYgain'; ...
                            'dot2right'; ...
                            'dot2left'; ...
                            'dot2up'; ...
                            'dot2down'};
    params.key.list      = zeros(256, 1);
    
    for keyIdx = 1:numel(params.key.names)
        eval(sprintf('params.key.%s = KbName(''%s'');', params.key.functions{keyIdx}, params.key.names{keyIdx}));
        eval(sprintf('params.key.list(params.key.%s) = 1;', params.key.functions{keyIdx}));
    end
    
    params.key.minPressDuration = 0.2;
    params.key.lastPress        = GetSecs;
    
end % Function end
