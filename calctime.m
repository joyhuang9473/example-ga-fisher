function [time, pass] = calctime(pass, start)
    if exist('start', 'var') && ~isempty(start)
        pass = pass - start;
    end
    if length(pass) == 6
        day = pass(3); hr = pass(4);
        min = pass(5); sec = pass(6);
        pass = ((day*24 + hr)*60 + min)*60 + sec;
    end
	sec = mod(floor(pass), 60);
	min = mod(floor(pass / 60), 60);
	hr = mod(floor(pass / 3600), 60);
    time = sprintf('%02d:%02d:%02d', hr, min, sec);
end