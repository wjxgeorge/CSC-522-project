function G = gaussian1(U,V)
%GAUSSIAN1 此处显示有关此函数的摘要
%   此处显示详细说明
    sigma = 0.8;
    [m, p] = size(U);
    [n, p] = size(V);
    norm_d = 3;
    
    G = zeros(m, n);
    for i=1:m
        for j=1:n
            U0 = U(i, :);
            V0 = V(j, :);
            G(i, j) = exp(-1*sigma*(norm(U0-V0,norm_d)^2));
        end
        
    end
    
end

