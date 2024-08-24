function [u, c, fig_num] = IT2FCM(C, M, N, x, m1, m2, fig_num)

%%
% m1 = 2;
% m2 = 2;

max_iteration = 1000;

% [header,feature,index,filename, pathname] = read_feature();

% N = header(1);          % Number of data patterns
% M = header(2);          % Number of dimension
% C = header(3);          % Number of classes

% x = normalize_x(feature,N);
c = zeros(C,M);
t = 0.501;
for i = 1 : C
    for j = 1 : M
        c(i,j) = t;
        t = t - 0.001;
    end
end
% if (C == 2)
%     c = [0.501 0.501; 0.499 0.499];
% else
%     c = [0.501 0.501; 0.499 0.499; 0.5 0.5];
% end

%%
error_sum = 255;
iteration = 0;

old_upper_u = zeros(C,N);
old_lower_u = zeros(C,N);

% c1 = [];
% c2 = [];
% c3 = [];

while (error_sum ~= 0 && iteration <= max_iteration)
    
%     c1 = [c1; [c(1,1) c(1,2)]];
%     c2 = [c2; [c(2,1) c(2,2)]];
%     if (C == 3)
%         c3 = [c3; [c(3,1) c(3,2)]];    
%     end
    
    [upper_u,lower_u,upper_u_m,lower_u_m] = assign_membership(x,c,N,C,m1,m2);
        
    c = update_center(x,c,N,C,M,upper_u,lower_u,upper_u_m,lower_u_m);   
    
    old_u = (old_upper_u + old_lower_u) / 2;
    u = (upper_u + lower_u) / 2;
    error_sum = norm(old_u - u);

    old_upper_u = upper_u;
    old_lower_u = lower_u;
    
    iteration = iteration + 1; 
           
end

% cc = c;
% [tmp,idx] = sort(c(:,1));
% c = cc(idx,:);
% 
% [tmp,idx] = hard_partition(x,c,N,C,m1,m2);
% 
% %%
% fig_num = fig_num + 1;
% figure(fig_num);
% hold on;
% 
% plot(x(find(idx == 1),1), x(find(idx == 1),2), 'ko');
% plot(x(find(idx == 2),1), x(find(idx == 2),2), 'ks');
% 
% plot(c1(:,1), c1(:,2), 'g.-','MarkerSize',15);
% plot(c2(:,1), c2(:,2), 'r*-','MarkerSize',10);
% 
% if (C == 3)
%     plot(x(find(idx == 3),1), x(find(idx == 3),2), 'k^');
%     plot(c3(:,1), c3(:,2), 'b.-','MarkerSize',15);
% end
% 
% plot(c(:,1), c(:,2), 'k.','MarkerSize',20);
% xlabel('Feature 1');
% ylabel('Feature 2');
%% compute classification rate

% if (C == 2)
%     
%     correct_idx = [ones(1,header(4)) ones(1,header(5))*2];
%     
%     classification_rate = ((N - size(find(correct_idx ~= idx),2))/N)*100;
%     
%     correct_count = (N - size(find(correct_idx ~= idx),2));
%     incorrect_count = N - correct_count;
%     
% else
%     
%     correct_idx = [ones(1,header(4)) ones(1,header(5))*2 ones(1,header(6))*3];
%     
%     classification_rate = ((N - size(find(correct_idx ~= idx),2))/N)*100;
%     
%     correct_count = (N - size(find(correct_idx ~= idx),2));
%     incorrect_count = N - correct_count;
%     
% end    
% 
% correct_count
% incorrect_count
% classification_rate

