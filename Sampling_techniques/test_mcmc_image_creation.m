%% Metropolis algorithm's parameters
num_samples=9900; % Required number of samples
burn_in=100; % Ignore first 100 samples
dimensions=3;
parameters_sampled=zeros(dimensions,num_samples);
burn_in_samples=zeros(dimensions,burn_in);


%% Initialise model parameters to be updated 
num_shapes=2000;
initial_shapes=50;
min_overlap=1500;
x=[num_shapes;initial_shapes;min_overlap]; % Initial parameter vector

%% Initialising other model parameters
image_top_left = [0; 0];
image_bottom_right = [1597;1639];
res=1;
image_size = ceil((image_bottom_right-image_top_left)*res);
image_in = zeros(image_size')';
max_tries = 10*num_shapes;
min_power = 1; max_power = 5;
S=SimParamSet();
S.add(SimParameter('a_dist',translate(BetaDistribution(2,2), 30, 20)));
S.add(SimParameter('b_dist',translate(BetaDistribution(2,2), 20, 10)));
S.add(SimParameter('theta_dist',translate(BetaDistribution(2,2), 0, pi/2)));
S.add(SimParameter('power_dist',translate(BetaDistribution(2,2), (min_power+max_power)/2, (max_power-min_power)/2)));
% S.add(SimParameter('pow_dist',translate(ExponentialDistribution(0.5), min_pow)));
S.add(SimParameter('shape_cx_global',UniformDistribution(-0.2*(size(image_in,2)/res),1.2*(size(image_in,2)/res))));
S.add(SimParameter('shape_cy_global',UniformDistribution(-0.2*(size(image_in,1)/res),1.2*(size(image_in,1)/res))));

%% Initialising model methods
cutoff_func = @(x,res)cutoff_smooth(x, res, 1);
combine_func = @combine_sum2;
A_small_overlap = [80,1000,10000,num_shapes];
overlap_func = @(image1,image2,shape_count) allow_absolute_overlap(image1, image2,shape_count, res, A_small_overlap);

%% Widths of proposal densities for uniformly distributed random parameters
width_num_shapes=10;
width_initial_shapes=0.25;
width_min_overlap=10;
d=[width_num_shapes;width_initial_shapes;width_min_overlap];


%% Cost func (assumed proportional to target density) parameters 
weight_vector=ones(length(a,1),1);
cost_func=@(a,b)least_square_cost(a, b, weight_vector);
base_descriptors_data=load();
base_descriptors=;


%% Metropolis algorithm with a componentwise update
for i = 1:num_samples+burn_in
    
[image,~,~]=create_image(image_in, res, num_shapes, max_tries, image_top_left,S,cutoff_func,combine_func,overlap_func);
        
image_binary=image>0.5;

descriptors= compute_descriptors(image_binary);

descriptors_average= least_square_cost(descriptors,base_descriptors,weight_vector);

pick=randi([1,length(d),1,1]); % Randomly picks a variable to be
                               % updated

                               
proposal_sample=x(pick)-d(pick)/2 + d(pick)*rand;

model(proposal_sample)



end







%% Random parameters
num_shapes=gendist_create('uniform', {1000, 300}); % Don't want it to be negative
initial_shapes=gendist_create('uniform', {70, 50}); % Don't want it to be negative
min_overlap=gendist_create('uniform', {2000, 1500});
max_overlap=gendist_create('uniform', {8000, 1500});
a_dist=gendist_create('uniform', {60, 30});
b_dist=gendist_create('uniform', {60, 40});
pow=gendist_create('uniform', {3, 2});



%% Fixed parameters
% Initialise input image 
image_top_left = [0; 0];
image_bottom_right = [1597;1639];
res=1;
image_size = ceil((image_bottom_right-image_top_left)*res);
image_in = zeros(image_size')';
max_tries= 10 * num_shapes;
cutoff_func = @(x,res)cutoff_smooth(x, res, 1);
combine_func = @combine_sum2;
overlap_func = @(image1,image2,shape_count) allow_absolute_overlap(image1, image2,shape_count, res, A_overlap_limit);
A_overlap_limit = [30,3000,10000,num_shapes];

[image_out,shape_count,images_store]=create_image(image_in, res, num_shapes, max_tries, image_top_left,S,cutoff_func,combine_func,overlap_func);
image_in=zeros