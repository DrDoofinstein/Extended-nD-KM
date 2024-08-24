function [U_mag, U, V] = it2fcm1(U, C, M, N, data, m1, m2)

    q_max = 200;
    q = 0;
    
    
    
    U_l = U;
    U_u = U;
    U_mag = zeros(C,N);
    m = m1 * ones(N,1);
    
  
    m_l = ones(C,N,M);
    m_u = m_l;
    
    %V = 0.5 * ones(C,M);
    V = rand(C,M);
    thr = 0.00001;
    chk = 1;
    
    index = ones(N,M);
    for i = 1 : N
        for j = 1 : M
            index(i,j)=i;
        end
    end
    
    data_o = data;
        
%% %%%%%%%%%%%%%%%%%%%%%%%%% Initializing Cluster Prototype %%%%%%%%%%%%%%%%%%%%%%
    %for dim = 1 : M
        %for i = 1 : C
            %V(i,dim)=sum(data(:,dim).*U(i,:,dim)')./sum(U(i,:,dim));
        %end
    %end

%% %%%%%%%%%%%%%%%%%%%%%%%%% Starting of Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    while (q < q_max) && (chk > thr)
        V_old = V;
%% %%%%%%%%%%%%%%%%%%%%%%%%% Calculate Membership %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for dim = 1 : M
            for i = 1 : N
                for j = 1 : C
                    dist_num = abs(V(j,dim) - data(i,dim));
                    val1 = 0;
                    val2 = 0;
                    
                    for k = 1 : C
                        dist_den = abs(V(k,dim) - data(i,dim));
                        val1 = val1 + (dist_num/dist_den)^(2/(m1-1));
                        val2 = val2 + (dist_num/dist_den)^(2/(m2-1));
                    end
                    
                    val1 = 1 / val1;
                    val2 = 1 / val2;
                    
                    if val1 < val2
                       U_u(j,index(i,dim),dim) = val2;
                       U_l(j,index(i,dim),dim) = val1;
                       m_u(j,index(i,dim),dim) = m2;
                       m_l(j,index(i,dim),dim) = m1;
                    else
                       U_l(j,index(i,dim),dim) = val2;
                       U_u(j,index(i,dim),dim) = val1;
                       m_u(j,index(i,dim),dim) = m1;
                       m_l(j,index(i,dim),dim) = m2;
                    end
                end
            end
        end

        U = (U_u + U_l)/2;

    %% %%%%%%%%%%%%%%%%%%%%%%%%% Calculate Cluster Prototype %%%%%%%%%%%%%%%%%%%%%%%%%
        for dim = 1 : M
            for j = 1 : C
                m(:,1) = (m_u(j,:,dim) + m_l(j,:,dim))/2;
                V(j,dim)=sum(data_o(:,dim).*(U(j,:,dim)'.^m))./sum(U(j,:,dim)'.^m);
            end
        end


        V_l = V;
        V_r = V;
%% %%%%%%%%%%%%%%%%%%%%%%%%% Sort Pattern Indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if chk == 1
            [data, index] = sort_data(data,index,M,N);
        end

%% %%%%%%%%%%%%%%%%%%%%%%%%% Iteration for Max Prototype %%%%%%%%%%%%%%%%%%%%%%%%%

        for dim = 1 : M
            for j = 1 : C
                for i = 1 : N
                    if data(i,dim) <= V(j,dim)
                        U(j,index(i,dim),dim) = U_l(j,index(i,dim),dim);
                        m(index(i,dim)) = m_l(j,index(i,dim),dim);
                    else
                        U(j,index(i,dim),dim) = U_u(j,index(i,dim),dim);
                        m(index(i,dim)) = m_u(j,index(i,dim),dim);
                    end
                end

                V_r(j,dim)=sum(data_o(:,dim).*(U(j,:,dim)'.^m))./sum(U(j,:,dim)'.^m);       % Old Data Used

                %One statement of paper is missing here

            end
        end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%% Iteration for Min Prototype %%%%%%%%%%%%%%%%%%%%%%%%%

        for dim = 1 : M
            for j = 1 : C
                for i = 1 : N
                    if data(i,dim) > V(j,dim)
                        U(j,index(i,dim),dim) = U_l(j,index(i,dim),dim);
                        m(index(i,dim)) = m_l(j,index(i,dim),dim);
                    else
                        U(j,index(i,dim),dim) = U_u(j,index(i,dim),dim);
                        m(index(i,dim)) = m_u(j,index(i,dim),dim);
                    end
                end

                V_l(j,dim)=sum(data_o(:,dim).*(U(j,:,dim)'.^m))./sum(U(j,:,dim)'.^m);       % Old Data Used

                %One statement of paper is missing here

            end
        end

%% %%%%%%%%%%%%%%%%%%%%%%%%% Updating Prototype %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        V = (V_l + V_r)/2;
        
        q = q + 1;
        chk = abs(sum(sum(V-V_old)));
        display(q);
    end
    
    for i = 1 : N
        for j = 1 : C
            U_mag(j,i) = sum(U(j,i,:))/M;
        end
    end
    
end
