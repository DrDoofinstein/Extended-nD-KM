function [fig_num classification_rate correct_count incorrect_count true_pos false_pos true_neg false_neg] = plot_it2result(data, U, V, fig_num, C, N, header)

classification_rate = 0;
correct_count = 0;
incorrect_count = 0;

true_pos = 0;
false_pos = 0;

maxU = max(U);
% Find the data points with highest grade of membership in cluster 1
index1 = find(U(1,:) == maxU);

% Find the data points with highest grade of membership in cluster 2
index2 = find(U(2,:) == maxU);

limit1 = N/C;
pos = 0;
f_pos = 0;
for i = 1 : length(index1)
    if index1(i) > limit1
        false_pos = false_pos + 1;
        f_pos = f_pos + 1;
    else
        true_pos = true_pos + 1;
        pos = pos + 1;
    end
end
true_neg = N - N/C - f_pos;
false_neg = (N/C) - pos;

if true_pos < 0.1 * N
    temp = index1;
    index1 = index2;
    index2 = temp;
    pos = 0;
    f_pos = 0;
    for i = 1 : length(index1)
        if index1(i) > limit1
            false_pos = false_pos + 1;
            f_pos = f_pos + 1;
        else
            true_pos = true_pos + 1;
            pos = pos + 1;
        end
    end
    true_neg = N - N/C - f_pos;
    false_neg = (N/C) - pos;
end

limit2 = 2 * N/C;
pos = 0;
f_pos = 0;
for i = 1 : length(index2)
    if index2(i) < (limit1 + 1) && index2(i) > limit2
        false_pos = false_pos + 1;
        f_pos = f_pos + 1;
    else
        true_pos = true_pos + 1;
        pos = pos + 1;
    end
end
true_neg = true_neg + N - N/C - f_pos;
false_neg = false_neg + (N/C) - pos;

fig_num = fig_num + 1;
figure(fig_num);
hold on;
plot(data(index1,1),data(index1,2),'*','color','g');
plot(data(index2,1),data(index2,2),'*','color','r');
plot(data(index1,1),data(index1,2),'o','color','k');
plot(data(index2,1),data(index2,2),'square','color','k');
if C == 3
    index3 = find(U(3,:) == maxU);
    
    pos = 0;
    f_pos = 0;
    for i = 1 : length(index3)
        if index3(i) < (limit2 + 1)
            false_pos = false_pos + 1;
            f_pos = f_pos + 1;
        else
            true_pos = true_pos + 1;
            pos = pos + 1;
        end
    end
    true_neg = true_neg + N - N/C - f_pos;
    false_neg = false_neg + (N/C) - pos;

    plot(data(index3,1),data(index3,2),'diamond','color','k');
    plot(data(index3,1),data(index3,2),'*','color','b');
    plot([V([1 2 3],1)],[V([1 2 3],2)],'*','color','k');
else
  % Plot the cluster centers
  plot([V([1 2],1)],[V([1 2],2)],'*','color','k');
end
xlabel('Feature 1')
ylabel('Feature 2')
axis([0 1 0 1]);
hold off;


% idx = zeros(1,N) ;
% idx(index1) = 1 ;
% idx(index2) = 2 ;
% 
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