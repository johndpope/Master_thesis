function unittest_check_overlap()

% CHECK_OVERLAP_TEST to test the
% CHECK_OVERLAP function.
%
% See also MUNIT_RUN_TESTSUITE

%   <author>Prem Ratan M
%   <T.U.Braunschweig>
% munit_set_function('check_overlap');

ovlp=0;
X1Y1_IM=[1;1];
X2Y2_IM=[1000;1000];
res1=[1;1];
res2=[1;2];
res3=[2;1];
a=[50;20];
p=2;
th=deg2rad(25);
imag=zeros(((X2Y2_IM-X1Y1_IM).*res1)');
imag1=[1,zeros(1,size(imag,2)-2),0;zeros(size(imag,1)-2,size(imag,2));1,zeros(1,size(imag,2)-2),1];
imag2=[1,zeros(1,size(imag,2)-2),1;zeros(size(imag,1)-2,size(imag,2));0,zeros(1,size(imag,2)-2),1];
imag3=[1,zeros(1,size(imag,2)-2),1;zeros(size(imag,1)-2,size(imag,2));1,zeros(1,size(imag,2)-2),0];
imag4=[0,zeros(1,size(imag,2)-2),1;zeros(size(imag,1)-2,size(imag,2));1,zeros(1,size(imag,2)-2),1];

% Placing the shape at the bottom left corner
[loc_shape_1, IR1C1_SH] = compute_local_shape(X1Y1_IM, res1, a, p, [X1Y1_IM(1)+1; X2Y2_IM(2)-1], th,@cutoff_sharp);

[ad1]=check_overlap(ovlp,loc_shape_1,imag1,IR1C1_SH);
[ad2]=check_overlap(ovlp,loc_shape_1,imag2,IR1C1_SH);
[ad3]=check_overlap(ovlp,loc_shape_1,imag3,IR1C1_SH);
[ad4]=check_overlap(ovlp,loc_shape_1,imag4,IR1C1_SH);

assert(isequal(~[ad1;ad3;ad4],ones(3,1)));
assert((~ad2)==0,'Fail in check_overlap');

% Placing the shape at the top left corner
[loc_shape_2, IR1C1_SH_1] = compute_local_shape(X1Y1_IM, res1, a, p, [X1Y1_IM(1)+1; X1Y1_IM(2)+1], th,@cutoff_sharp);

[ad5]=check_overlap(ovlp,loc_shape_2,imag1,IR1C1_SH_1);
[ad6]=check_overlap(ovlp,loc_shape_2,imag2,IR1C1_SH_1);
[ad7]=check_overlap(ovlp,loc_shape_2,imag3,IR1C1_SH_1);
[ad8]=check_overlap(ovlp,loc_shape_2,imag4,IR1C1_SH_1);

assert(isequal(~[ad5;ad6;ad7],ones(3,1)));
assert((~ad8)==0,'Fail in check_overlap');

% Placing the shape at the top right corner
[loc_shape_3, IR1C1_SH_2] = compute_local_shape(X1Y1_IM, res1, a, p, [X2Y2_IM(1)-1; X1Y1_IM(2)+1], th,@cutoff_sharp);

[ad9]=check_overlap(ovlp,loc_shape_3,imag1,IR1C1_SH_2);
[ad10]=check_overlap(ovlp,loc_shape_3,imag2,IR1C1_SH_2);
[ad11]=check_overlap(ovlp,loc_shape_3,imag3,IR1C1_SH_2);
[ad12]=check_overlap(ovlp,loc_shape_3,imag4,IR1C1_SH_2);

assert(isequal(~[ad10;ad11;ad12],ones(3,1)));
assert((~ad9)==0,'Fail in check_overlap');

% Placing the shape at the bottom right corner

[loc_shape_4, IR1C1_SH_3] = compute_local_shape(X1Y1_IM, res1, a, p, [X2Y2_IM(1)-1; X2Y2_IM(2)-1], th,@cutoff_sharp);

[ad13]=check_overlap(ovlp,loc_shape_4,imag1,IR1C1_SH_3);
[ad14]=check_overlap(ovlp,loc_shape_4,imag2,IR1C1_SH_3);
[ad15]=check_overlap(ovlp,loc_shape_4,imag3,IR1C1_SH_3);
[ad16]=check_overlap(ovlp,loc_shape_4,imag4,IR1C1_SH_3);

assert(isequal(~[ad13;ad14;ad16],ones(3,1)));
assert((~ad15)==0,'Fail in check_overlap');
end

