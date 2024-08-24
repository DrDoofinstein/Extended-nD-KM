function [upper_u,lower_u,upper_u_m,lower_u_m] = assign_membership(x,c,N,C,m1,m2)

% Compute Euclidian Distance
for j = 1:C
    d(j,:) = sqrt( sum( (x - repmat(c(j,:),N,1) ).^2, 2) );
end

%% FCM 

u_m1 = zeros(C,N);
u_m2 = zeros(C,N);

upper_u = zeros(C,N);
lower_u = zeros(C,N);

upper_u_m = zeros(C,N);
lower_u_m = zeros(C,N);

fuzzifier_m1 = 2.0 / (m1 - 1);
fuzzifier_m2 = 2.0 / (m2 - 1);

% Compute Membership
for j = 1:C
    
    temp = ( repmat(d(j,:),C,1) ./ d );
    temp(find(isnan(temp))) = 1.0;
    result_u(j,:) = 1 ./ sum(temp);
    
    result_u1 = ( repmat(d(j,:),C,1) ./ d ) .^ fuzzifier_m1;
    result_u1(find(isnan(result_u1))) = 1.0; 
    
	u_m1(j,:) = 1 ./ sum(result_u1);
    u_m1(find(isinf(u_m1))) = 0.0; 
    
    result_u2 = ( repmat(d(j,:),C,1) ./ d ) .^ fuzzifier_m2;
    result_u2(find(isnan(result_u2))) = 1.0;  
    
	u_m2(j,:) = 1 ./ sum(result_u2);
    u_m2(find(isinf(u_m2))) = 0.0; 
    
    idx = find( result_u(j,:) < (1/C) );
        upper_u(j,idx) = u_m1(j,idx);
        lower_u(j,idx) = u_m2(j,idx);
        upper_u_m(j,idx) = m1;
        lower_u_m(j,idx) = m2;
    
    idx = find( result_u(j,:) >= (1/C) );
        upper_u(j,idx) = u_m2(j,idx);
        lower_u(j,idx) = u_m1(j,idx);
        upper_u_m(j,idx) = m2;
        lower_u_m(j,idx) = m1;
    
end