function [relative_cost] = least_square_cost(a, b, w_v)
%% Old cost
% least_square_difference=sqrt((a-b).^2);
% sum_vec=sum(least_square_difference,2);
% cost=w_v'*sum_vec;

%% New relative cost
difference_squared=((a-b).^2); % b is your base descriptor and a is the 
                               % computed descriptor
least_square_difference=sqrt(sum(difference_squared,2));
relative_cost=least_square_difference./sqrt(sum(b.^2,2))
relative_cost=w_v'*relative_cost;

end

