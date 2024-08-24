function [data, index] = sort_data(data,index,M,N)

    for dim = 1 : M
        for i = 1 : N-1
            for j = i : N
                if data(i,dim)<data(j,dim)
                    temp = data(i,dim);
                    data(i,dim) = data(j,dim);
                    data(j,dim) = temp;
                    temp = index(i,dim);
                    index(i,dim) = index(j,dim);
                    index(j,dim) = temp;
                end
            end
        end
    end
end