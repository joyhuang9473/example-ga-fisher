#GA-Fisher Face Recognition System

##Usage
1. put image directories (1, 2, ..., 49) into TrainDatabase
2. make sure that 'cvprtoolbox-code-297' is added to path
3. launch 'main.m' (UI mode) or 'GAFisherDemo.m' (console mode)

##Files
- calctime.m
<br>time formatter function, return 'hh:mm:ss'
- CalRecRate.m
<br>calculate the recognition rate of trained system
- cvprcheck.m
<br>check if cvprtoolbox is added to path or not
- cvprtoolbox-code-297
<br>cvpr tool box, see cvprtoolbox-code-297/readme.txt for more details
- e_name_vl.mat
<br>classes' label (students' name)
- FaceRec.m
<br>menu of face recognition
- fprintbackspace.m
<br>print \b (backspace)
- GAFisherCore.m
<br>GA-Fisher implementation
- GAFisherDemo.m
<br>simple demo of training
- GApca.m
<br>GA-PCA implementation
- licence.txt
<br>free licence
- LoadImage.m
<br>load an image and convert into vector
- main.m
<br>main menu
- name.mat
<br>classes' label (students' id)
- parsecoeff.m
<br>parse coefficient of input
- README.MD
<br>you are reading this
- Recognition.m
<br>recognize an image
- ScatterMat.m
<br>calculate scatter matrix (Sw, Sb) and mean
- TrainDatabase.m
<br>load input image for all 49 people
- Whiten.m
<br>whitening procedure and LDA
