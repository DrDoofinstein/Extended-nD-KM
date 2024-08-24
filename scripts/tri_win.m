function [win half] = tri_win(win_size)

if mod(win_size,2) == 1
    win_size = win_size + 1;
end

win = zeros(win_size + 1,1);
half = floor(win_size/2);
for i = 0 : half
    win(i+1) = (2*i)/half;
end

for i = (half + 1) : win_size
    win(i+1) = (2 * (win_size - i))/half;
end

win = win./max(win);