function histogram = smooth_histogram(win_size,histogram,spread)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This function is for smoothing histogram using traingular window.   %%%
%%% Variables:                                                          %%%
%%% win_size-  window size of the triangular window to be used          %%%
%%% histogram- input variable containing the histogram                  %%%
%%% spread-    number of bins in histogram                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

histogram_temp = histogram;

[win center] = tri_win(win_size);   % Generating the triangular Window

center = center + 1;
win_len = 2*center-1;

for i = 1 : spread
    off_l = i - center;
    if off_l < 0
        off_l = 0;
    end
    
    off_r = (spread-i)-(center-1);
    if off_r < 0
        off_r = 0;
    end
    
    first = center + 1 - i;
    if first < 1
        first = 1;
    end
    
    last = spread - i + center;
    if last > (win_len)
        last = win_len;
    end
    
    temp_win = vertcat(zeros(off_l,1),win(first:last,1),zeros(off_r,1));
    histogram_temp(i) = sum(histogram.*temp_win);
end

% Normalising Histogram
if (max(histogram_temp)) == 0
    histogram = 0.*histogram;
else
    histogram = histogram_temp./(max(histogram_temp));
end