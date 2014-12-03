function [time, pass] = calctime(pass, start)
    if exist('start', 'var') && ~isempty(start)
        pass = pass - start;
    end
    if length(pass) == 6
        pass = (pass(4)*60 + pass(5))*60 + pass(6);
    end
	sec = mod(floor(pass), 60);
	min = mod(floor(pass / 60), 60);
	hr = mod(floor(pass / 3600), 60);
    time = sprintf('%02d:%02d:%02d', hr, min, sec);
end