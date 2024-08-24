function [m fig_num] = fuzzifier_class(data, U, V, C, class, fig_num)

thr = 0.001;
q_max = 100;
delta = 1;
m_itr1 = zeros(q_max,1);

d = zeros(C,1);

for i = 1 : C
    d(i) = abs(data - V(i));
end

m_old = 2;
if class == 1
    d1 = d(C);
    start = 1;
    last = C-1;
else
    d1 = d(1);
    start = 2;
    last = C;
end

q = 0;
while delta > thr && q < q_max
    a = log(1/U);
    
    temp = 0;
    gamma = 2/(m_old-1);
    for k = start : last
        temp = temp + (d1/d(k))^gamma;
    end
    b = log(1 + temp);
    gamma = (a - b)/(log(d(class)/d1));
    m_new = 1 + (2/gamma);
    
    delta = abs(m_old - m_new);
    m_old = m_new;
    q = q + 1;
    m_itr1(q) = m_old;
end

% fig_num = fig_num + 1;
% figure(fig_num);
% plot(1:q,m_itr1(1:q));
% title('Variation of m with number of iterations')
% xlabel('Number of Iterations')
% ylabel('Fuzzifier m')
m = m_new;


