%% Metropolis algorithm's parameters
clear
clc
num_samples=100; % Required number of samples
burn_in=1; % Ignore first few samples
dimensions=3;
x_sampled=zeros(dimensions,num_samples+burn_in);
descriptors_differences=zeros(num_samples+burn_in,1);
acceptance_ratios=zeros(num_samples+burn_in,1);
total_accepts=0;
model_runs_per_sample=3;

%% Initialise model parameters to be updated
num_shapes=4000; % 350,286 400 286
initial_shapes=150; % 55,65 70 65
min_overlap=400; % 2040, 3000 2450
x=[num_shapes;initial_shapes;min_overlap]; % Initial parameter vector

%% Initialising other model parameters
[model_params,cutoff_func,combine_func,overlap_func]=initialise_image_creation_model('num_shapes',x(1),'initial_shapes',x(2),'min_overlap',x(3));

%% Parameters related to prior densities
prior_distributions=SimParamSet();
prior_distributions.add(SimParameter('prior_dist_x1',UniformDistribution(10,6000)));
prior_distributions.add(SimParameter('prior_dist_x2',UniformDistribution(10,6000)));
prior_distributions.add(SimParameter('prior_dist_x3',UniformDistribution(10,6000)));

%% Jumping widths of proposal densities for uniformly distributed random parameters
width_num_shapes=400; %[10,0.25,10;50,5,50;100,10,100;300;20;300]; % Set for mean of jumps in num_shapes to be 25
width_initial_shapes=20; % Set for mean of jumps in initial_shapes to be 5
width_min_overlap=400;  % Set for mean of jumps in min_overlap to be 100
widths=[width_num_shapes;width_initial_shapes;width_min_overlap];

%% Likelihood function parameters
sigma=0.4; % Calibrated such that .02e6 difference in descriptors should
% be accepted with a probability of only 0.17 check
% exp(-0.02e6/(2*(75^2)))
likelihood_ratio=@(d1,d2) exp((-d2+d1)/(2*sigma^2)); % A normal likelihood
% distribution for the
% descriptor
% differences


%% Cost func (assumed proportional to target density) parameters
cost_func=@(a,b)least_square_cost(a, b, weight_vector);
%FileName   = 'average_descriptors_for_image_sets.mat';
FileName   = 'selected_image_descriptors.mat';
upUpFolder = fileparts(fileparts(fileparts(fileparts(pwd))));
%FolderName = fullfile(upUpFolder, 'Average_desrciptors_for_100_selected_porous_media_2d_slices');
FolderName = fullfile(fullfile(upUpFolder, 'Average_descriptors_for_1_selected_porous_media_slice'),'Slice_5');
File       = fullfile(FolderName, FileName);load(File);
% base_descriptors=average_descriptors_for_image_sets(6,2).values;
base_descriptors=descriptors;
weight_vector=ones(size(base_descriptors,1),1);
%weight_vector(size(base_descriptors,1),1)=2;


% Initial computation for first step
[descriptors_old] = create_image_and_compute_descriptors(model_params,cutoff_func,combine_func,overlap_func,model_runs_per_sample);
descriptors_difference_old= least_square_cost(descriptors_old,base_descriptors,weight_vector);
prior_density_old=0.5;

%% Metropolis algorithm with a componentwise update
tic
for i = 1:num_samples+burn_in
    
    i
    current_diff=descriptors_difference_old
    
    %% Computing new proposal
    pick=randi([1,dimensions]); % Randomly picks a variable to be
    % updated
    x_new=x;
    
    x_new(pick)=x_new(pick)-widths(pick)/2 + widths(pick)*rand;
    
    %% Computing prior densities
    prior_density_new=prior_density_compute(pick,x_new(pick),prior_distributions);
    prior_densities_ratio=prior_density_new/prior_density_old
    
    %% Creating image and computing likelihood
    
    [model_params,cutoff_func,combine_func,overlap_func]=initialise_image_creation_model('num_shapes',x_new(1),'initial_shapes',x_new(2),'min_overlap',x_new(3));
    [descriptors_new] = create_image_and_compute_descriptors(model_params,cutoff_func,combine_func,overlap_func,model_runs_per_sample);
    descriptors_difference_new= least_square_cost(descriptors_new,base_descriptors,weight_vector);
    
    %% Computing acceptance ratio and checking for update
    
    % acceptance_ratio=descriptors_difference_old/descriptors_difference_new
    % acceptance_ratio=exp(-descriptors_difference_new+descriptors_difference_old)
    acceptance_ratio= likelihood_ratio(descriptors_difference_old,descriptors_difference_new) * prior_densities_ratio
    alpha=min(1,acceptance_ratio);
    
    u=rand
    
    if u < alpha
        total_accepts=total_accepts+1;
        disp('x changing');
        x=x_new;
        descriptors_difference_old=descriptors_difference_new;
    end
    
    prior_density_old=prior_density_new;
    
    x_sampled(:,i)=x;
    descriptors_differences(i,1)=descriptors_difference_old;
    acceptance_ratios(i,1)=acceptance_ratio;
    
end

toc
x_samples_after_burn_in=x_sampled(:,burn_in+1:end);
percentage_accepts=total_accepts/num_samples;


