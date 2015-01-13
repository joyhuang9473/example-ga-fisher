function OK = cvprcheck()
    try
        cvLda(1, 1);
        cvLdaProj(1, 1);
        cvKnn(1, 1, 1);
        OK = true;
    catch
        fprintf(2, 'cvprtoolbox not found!\n');
        fprintf(2, 'cvprtoolbox -> Add to Path\n');
        OK = false;
    end
end