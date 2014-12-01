function class = Recognition(Wopt, U, image)
    image = double(image);
    if length(size(image)) == 3
        image = rgb2gray(image);
    end
    if size(image, 1) ~= 80 || size(image, 2) ~= 60
        image = imresize(image, [80 60]);
    end
    x = reshape(image',size(image, 1) * size(image, 2), 1);
    
    xproj = Wopt.' * x;
    
    class = 0;
    mdist = inf;
    for i = 1:size(U, 2)
        d = 0;
        for j = 1:length(xproj)
            d = d + (U(j,i) - xproj(j)) ^ 2;
        end
        if d < mdist
            class = i;
            mdist = d;
        end
    end
end