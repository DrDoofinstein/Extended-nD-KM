function c = update_center(x,c,N,C,M,upper_u,lower_u,upper_u_m,lower_u_m)

u_r = zeros(C,N);
u_l = zeros(C,N);
u_r_m = zeros(C,N);
u_l_m = zeros(C,N);
for i = 1:N
    for j = 1:M
        count = 0;
        for k = 1:C
            if(x(i,j)<=c(k,j))
                count = count + 1;
            end
        end
        
        if(count == 2)
            for k = 1:C
                u_r(k,i) = lower_u(k,i);
                u_l(k,i) = upper_u(k,i);
                u_r_m(k,i) = lower_u_m(k,i);
                u_l_m(k,i) = upper_u_m(k,i);
            end
        else
            for k = 1:C
                u_r(k,i) = upper_u(k,i);
                u_l(k,i) = lower_u(k,i);
                u_r_m(k,i) = upper_u_m(k,i);
                u_l_m(k,i) = lower_u_m(k,i);
            end
        end
    end
end

%%
c_r = zeros(C,M);
c_l = zeros(C,M);
for k = 1:C
    for j = 1:M        
        temp1 = 0;
        temp2 = 0;
        temp11 = 0;
        temp22 = 0;
        for i = 1:N              
            temp1 = temp1 + (x(i,j) * (u_r(k,i)^u_r_m(k,i)));
            temp2 = temp2 + (u_r(k,i)^u_r_m(k,i));
            temp11 = temp11 + (x(i,j) * (u_l(k,i)^u_l_m(k,i)));
            temp22 = temp22 + (u_l(k,i)^u_l_m(k,i));
        end
        c_r(k,j) = temp1 / temp2;
        c_l(k,j) = temp11 / temp22;
        c(k,j) = (c_r(k,j) + c_l(k,j)) / 2;
    end
end