function [lineal_path_x] = lineal_path_calc(img)

cols=size(img,2);
path_length=zeros(cols,1);
increment=zeros(cols,1);        % Initialising here to avoid 
                                % creating this vector anew during each
                                % iteration while incrementing the existing
                                % path_length
re_initialise=zeros(cols,1);    % To re-initialise the increment vector to
                                % zeros after each time it is added to the 
                                % path_length vector                           
total_count=0;

for i=1:size(img,1)
    counter=0;
    for j=1:size(img,2)

        total_count=total_count+1;
        if  img(i,j)==0
            counter=0;
        else
            counter=counter+1;
            increment(1:counter-1,1)=1;
    %       path_length=path_length+[ones(counter-1,1);zeros(length(path_length)-counter+1,1)];
            path_length=path_length+increment;
            increment=re_initialise;
            %ones(countr-1) to avoid counting line segments of zero length (or
            %single pixels)
        end
    end
end

lineal_path_x=path_length/total_count;

%% Earlier code
% count_x=zeros(length(img),1);
% tot_count=0;
%
% for i=1:size(img,1)
%     counter=0;
%     for j=1:size(img,2)-1
%         tot_count=tot_count+1;
%
%         if img(i,j)== 1 && img(i,j+1)== 1
%             counter=counter+1;
%
%             if j == size(img,2)-1
%                 count_x=count_x+([(counter:-1:1)';zeros(size(count_x,1)-counter,1)]);
%                 counter=0;
%             end
%             continue
%
%         else if counter >= 1 && img(i,j)== 1 && img(i,j+1)== 0
%                 count_x=count_x+([(counter:-1:1)';zeros(size(count_x,1)-counter,1)]);
%                 counter=0;
%             end
%         end
%
%     end
%
%     l_p_x=count_x/tot_count;

end

