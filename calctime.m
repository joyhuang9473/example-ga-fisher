function [time, pass] = calctime(pass)
	sec = mod(floor(pass), 60);
	min = mod(floor(pass / 60), 60);
	hr = mod(floor(pass / 3600), 60);
    time = sprintf('%02d:%02d:%02d', hr, min, sec);
end