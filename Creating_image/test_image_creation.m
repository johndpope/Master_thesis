clear
clc

%% Initialising the Image (background for the shapes)

%rand('seed', 1234);
%randn('seed', 1234);

image_top_left = [0; 0];
image_bottom_right = [1597;1639];

res=1;

image_size = ceil((image_bottom_right-image_top_left)*res);
image_in = zeros(image_size')';

shape_type = 'smooth_convex';  % 'smooth_convex', Other options if and when required
num_shapes = 1200;% Number of shapes required - 1200 default
max_tries = 10*num_shapes; % Max number of tries to place ns shapes on the image


% cutoff_func= @cutoff_sharp;
cutoff_func = @(x,res)cutoff_smooth(x, res, 1);

%combinator_func= @combine_sum1;
combine_func = @combine_sum2;

% A below refers to area of overlap in terms of number of pixels
A_no_overlap = 0;
A_always_allow = inf;
A_small_overlap = [80,1000,10000,num_shapes];%for a=30,10;b=20,10;max_ol=3000;min_ol = 200 to 600 for pow=1 to 5 and min_ol=200 (100 for cutoff_sharp) for pow = 1 to 1.5
A_medium_overlap = 3000;
A_large_overlap = 10000;

A_overlap_limit = A_small_overlap;
overlap_func = @(image1,image2,shape_count) allow_absolute_overlap(image1, image2,shape_count, res, A_overlap_limit);

%% Generate and display image

switch shape_type
    case 'smooth_convex'
        min_power = 1; max_power = 5;
        S=SimParamSet();
        S.add(SimParameter('a_dist',translate(BetaDistribution(2,2), 40, 20)));
        S.add(SimParameter('b_dist',translate(BetaDistribution(2,2), 30, 10)));
        S.add(SimParameter('theta_dist',translate(BetaDistribution(2,2), 0, pi/2)));
        S.add(SimParameter('power_dist',translate(BetaDistribution(2,2), (min_power+max_power)/2, (max_power-min_power)/2)));
        % S.add(SimParameter('pow_dist',translate(ExponentialDistribution(0.5), min_pow)));
        S.add(SimParameter('shape_cx_global',UniformDistribution(-0.2*(size(image_in,2)/res),1.2*(size(image_in,2)/res))));
        S.add(SimParameter('shape_cy_global',UniformDistribution(-0.2*(size(image_in,1)/res),1.2*(size(image_in,1)/res))));
        
        [image_out,shape_count]=create_image(image_in, res, num_shapes, max_tries, image_top_left,S,cutoff_func,combine_func,overlap_func);
        
        disp([num2str(shape_count) ' shapes were placed']);
end

%imshow(image_out);
%save('pow_1_to_1point5','image_out');
%save('min_ol_1000_3rd_realisation','image_out');
%image_out_binary=im2bw(image_out,0.5);
image_out_binary=image_out>0.5;
imshow(image_out_binary);

% save('realisation5_setting3','A_overlap_limit','num_shapes','min_power','max_power','S','image_out','image_out_binary');

% %% Lineal path function calculation
%  [l_p_x] = lineal_path_calc(image_out_binary);
%  [l_p_y] = lineal_path_calc(image_out_binary');
% % 
% % %l_p=(count_x+count_y)/(tot_count_1+tot_count_2);
% % 
% % %% Chord length function calculation
%  [c_l_x] = chord_length_func_calc(image_out_binary);
%  [c_l_y] = chord_length_func_calc(image_out_binary');
% % %
% % % c_l=(count_xx+count_yy)/(tot_chords_1+tot_chords_2);
% % %
% % %% Auto correlation calculation
%  [a_c_x] = auto_corr(image_out_binary);
%  [a_c_y] = auto_corr(image_out_binary');
% % 
% % %% Minkowsky functionals calculation
% % per1=imPerimeter(image_out_binary);
% % are1=imArea(image_out_binary);
% % ec1= imEuler2d(image_out_binary);
% % [ar2,peri2,ec2,cap2]=compute_mink_2d(image_out_binary);
% % [ar3,per3,ec3]=compute_mink_marchin_sqr(image_out_binary,0.5);
% 
% 
% 
% %% Plotting
% subplot(3,3,2);
% plot(1:length(l_p_x),l_p_x);
% title('Lineal path function in x')
% subplot(3,3,3);
% plot(1:length(l_p_y),l_p_y);
% title('Lineal path function in y')
% subplot(3,3,4);
% plot(1:length(c_l_x),c_l_x);
% NumTicks = 11;
% L = get(gca,'XLim');
% set(gca,'XTick',linspace(L(1),L(2),NumTicks))
% title('Chord length function in x');
% subplot(3,3,5)
% plot(1:length(c_l_y),c_l_y);
% NumTicks = 11;
% L = get(gca,'XLim');
% set(gca,'XTick',linspace(L(1),L(2),NumTicks))
% title('Chord length function in y');
% subplot(3,3,6)
% plot(0:length(a_c_x)-1,a_c_x);
% title('Auto correlation w.r.t. distance in x');
% subplot(3,3,7)
% plot(0:length(a_c_y)-1,a_c_y);
% title('Auto correlation w.r.t. distance in y');
% % % 
% % % subplot(2,3,6)
% % % plot(1:length(c_l),cumsum(c_l));
% % 
% % title('Chord length cumsum function in x')