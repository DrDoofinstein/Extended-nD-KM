%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This code is for optimizing fuzzifier of type-X fuzzy C-mean %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
close all;

%% Getting Data

M = 2;      %% Number of Features in Image
C = 2;      %% Number of Classes

[feature N r c] = getdata(M);
% [feature N r c] = hwang_data(M);

Nc = N/C;                               % Number of data patterns in one class

%% Normalizing Data

data_o = normalize_x(feature,N);  % data is N X M matrix

data = getsample(data_o, C, M);
No = N;
N = 200*C;
U_it2 = initfcm(C, N, M);

%% Variable initialization

bins = 50;                              % Edit bins according to the data being chosen
win_size = 15;                          % Size of smoothing window

len = bins + 1;
histogram = zeros(len,M);
U = zeros(len,C,M);

U_upper = zeros(len,C,M);
U_lower = zeros(len,C,M);

y = zeros(len,C,M);
y_upper = zeros(len,C,M);
y_lower = zeros(len,C,M);

v = zeros(C,M);

chk = 0;
q = 1;
q_max = 100;
thr = 0.1;
fig_num = 4;

m_itr = zeros(q_max,2,M);
m_itr_indi = zeros(N,q_max,2,M);
m_itr_indi_o = m_itr_indi;
m1 = 4;
m2 = 2;
m1_old = m1;
m2_old = m2;
all_m1 = zeros(q_max,1);
all_m2 = all_m1;

delta = 1/bins;
x = 0 : 1/bins : 1;

upper_limit = 1 + (4/log10(49*C - 49));
lower_limit = (2*C - 1)/C;

classification_rate = zeros(q_max,1);
correct_count = zeros(q_max,1);
incorrect_count = zeros(q_max,1);
true_pos = zeros(q_max,1);
false_pos = zeros(q_max,1);
true_neg = zeros(q_max,1);
false_neg = zeros(q_max,1);
accuracy = zeros(q_max,1);
precision = zeros(q_max,1);

title_var_class = {' (Class: 1' ' (Class: 2' ' (Class: 3' ' (Class: 4'};
title_var_dim = {' Dimension: 1)' ' Dimension: 2)' ' Dimension: 3)'};

while chk == 0
    U_o = U;
    
    %% Calculating new membership and cluster prototype using IT-2
    
    [U_it2_mag, V_it2, fig_num] = IT2FCM(C, M, N, data, m1, m2, fig_num);
%     [U_it2_mag, U_it2, V_it2] = it2fcm1(U_it2, C, M, N, data, m1, m2);
    
    [fig_num classification_rate(q) correct_count(q) incorrect_count(q) true_pos(q) false_pos(q) true_neg(q) false_neg(q)] = plot_it2result(data, U_it2_mag, V_it2, fig_num, C, N, [0 0 0 1500 1500 1500]);
    accuracy(q) = (true_pos(q) + true_neg(q))/(true_pos(q) + false_pos(q) + true_neg(q) + false_neg(q));
    precision(q) = true_pos(q) / (true_pos(q) + true_neg(q));
    
%     fig_num = disp_image(N, r, c, C, U_it2_mag, data, fig_num);
%     fig_num = disp_4class_image(N, r, c, C, U_it2_mag, data, fig_num);
    
    U = 0*U;
    
    %% Generating histogram
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%% Bins are formed for each interval of delta ranging from %%%%%%%
    %%%%%%%                   -delta/2 -> 1+delta/2                 %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for dim = 1 : M
        for i = 1 : N
            bin_num = floor(data(i,dim)/delta) + 1;
            [~, class] = max(U_it2_mag(:,i));
            U(bin_num,class,dim) = U(bin_num,class,dim) + 1;
        end
    end
    
    U_upper = 0 * U_upper;
    U_lower = 0 * U_lower;
    
    for dim = 1 : M
        for class = 1 : C
            %% Smoothing of Histogram
            U(:,class,dim) = smooth_histogram(win_size,U(:,class,dim),len);
            
            %% Gaussian Curve Fitting for primary memebership
            
            y(:,class,dim) = mygaussfit(x,U(:,class,dim));
            
            %% Upper and lower histograms
            for i = 1 : len
                if U(i,class,dim) > y(i,class,dim)
                    U_upper(i,class,dim) = U(i,class,dim);
                else
                    U_lower(i,class,dim) = U(i,class,dim);
                end
            end
            
            %% Upper and lower membership
            
%             y_upper(:,class,dim) = mygaussfit(x,smooth_histogram(win_size,U_upper(:,class,dim),len));
%             y_lower(:,class,dim) = mygaussfit(x,smooth_histogram(win_size,U_lower(:,class,dim),len));
            
            y_upper(:,class,dim) = mygaussfit(x,U_upper(:,class,dim));
            y_lower(:,class,dim) = mygaussfit(x,U_lower(:,class,dim));
            
            norm_fac = max(y_upper(:,class,dim));
            y_upper(:,class,dim) = y_upper(:,class,dim)./norm_fac;             % Normalizing Upper membership
            y_lower(:,class,dim) = y_lower(:,class,dim)./norm_fac;             % Changing Lower membership accordingly
            y(:,class,dim) = y(:,class,dim)./norm_fac;                      % Changing Primary membership accordingly
            
            %% Plotting
%             fig_num = fig_num + 1;
%             figure(fig_num);
%             hold on;
%             bar(x,U_upper(:,class,dim),'y');         % Histogram for upper membership
%             bar(x,U_lower(:,class,dim),'m');         % Histogram for lower membership
%             plot(x,y(:,class,dim),'-k');             % Membership
%             plot(x,y_upper(:,class,dim),'.-g');      % Upper membership
%             plot(x,y_lower(:,class,dim),'.-r');      % Lower membership
%             legend('Histogram for UMF','Histogram for LMF','Result of GF Fitting','UMF','LMF');
%             str = strcat('FOU, ',title_var_class(class),title_var_dim(dim));
%             title(str);
%             axis([0 1 0 1])
        end
        
        %% Data for which m is to be calculated
        
        V_point = V_it2(:,dim);
        
        
        %% Computation of fuzzifier m1 and m2
        
        m1_mat = zeros(N,1);
        m2_mat = zeros(N,1);
        
        for i = 1 : N
            bin_num = floor(data(i,dim)/delta) + 1;
            U_point = y_upper(bin_num, :, dim);
            [m1_mat(i) fig_num] = fixed_point(data(i,dim), U_point, V_point, C, fig_num);
            if m1_mat(i) < 0
                m1_mat(i) = - m1_mat(i);
            end
            
            U_point = y_lower(bin_num, :, dim);
            [m2_mat(i) fig_num] = fixed_point(data(i,dim), U_point, V_point, C, fig_num);
            
            m_itr_indi_o(i,q,1,dim) = m1_mat(i);
            m_itr_indi_o(i,q,2,dim) = m2_mat(i);
            
            if m2_mat(i) < 0
                m2_mat(i) = - m2_mat(i);
            end
            
            if m1_mat(i) > upper_limit
                m1_mat(i) = upper_limit;
            elseif m1_mat(i) < lower_limit
                    m1_mat(i) = lower_limit;
            end
            
            if m2_mat(i) > upper_limit
                m2_mat(i) = upper_limit;
            elseif m2_mat(i) < lower_limit
                    m2_mat(i) = lower_limit;
            end
            
            if m1_mat(i) < m2_mat(i)
                temp_swap = m2_mat(i);
                m2_mat(i) = m1_mat(i);
                m1_mat(i) = temp_swap;
            end
            
            m_itr_indi(i,q,1,dim) = m1_mat(i);
            m_itr_indi(i,q,2,dim) = m2_mat(i);
        end
        
        m1 = sum(m1_mat)/N;
        m2 = sum(m2_mat)/N;
        
        m1_test = sum(m_itr_indi_o(:,q,1,dim))/N;
        m2_test = sum(m_itr_indi_o(:,q,2,dim))/N;
        
        m_itr(q,1,dim) = m1;
        m_itr(q,2,dim) = m2;
        
    end
    
    chk_m = abs(m1 - m1_old) + abs(m2 - m2_old);
    m1_old = m1;
    m2_old = m2;
    
    all_m1(q) = m1;
    all_m2(q) = m2;
    
    q = q + 1;
    if q > q_max || chk_m < thr
        chk = 1;
    end
    [upper_u,lower_u,upper_u_m,lower_u_m] = assign_membership(data_o,V_it2,No,C,m1,m2);
    u = (upper_u + lower_u) / 2;

    fig_num = disp_image(No, r, c, C, u, data_o, fig_num);    
end

m_final = zeros(q,2);
m_final(1,1) = 4;
m_final(1,2) = 2;
m_final(2:q,:) = (m_itr(1:(q-1),:,1) + m_itr(1:(q-1),:,2))/2;


a = 1: q;
fig_num = fig_num + 1;
figure(fig_num)
hold on;
plot(a,m_final(:,1),'-ks','MarkeredgeColor','k','MarkerFaceColor','r');
plot(a,m_final(:,2),'-ko','MarkeredgeColor','k','MarkerFaceColor','g');
legend('m_1','m_2','location','SouthEast');
axis([1 q 0 4]);
xlabel('Number of iterations')
ylabel('m_1 and m_2 values')