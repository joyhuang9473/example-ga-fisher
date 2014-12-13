function fprintbackspace(b)
    if ~exist('b', 'var') || isempty(b)
        b = 1;
    end
    for i = 1:b
        fprintf(1, '\b');
    end
end