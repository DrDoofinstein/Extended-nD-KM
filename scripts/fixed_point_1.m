function [m fig_num] = fixed_point(data, U, V, C, fig_num)

m_class = zeros(C,1);

for class = 1 : C
    [m_class(class) fig_num] = fuzzifier_class(data, U(class), V, C, class, fig_num);
end

m = sum(m_class)/C;