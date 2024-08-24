function norm_x = normalize_x(x,N)

norm_x = ( x - repmat(min(x),N,1) ) ./ ( repmat(max(x) - min(x),N,1) );
