function G = sigmoid1( U, V)
%SIGMOID1 此处显示有关此函数的摘要
% Sigmoid kernel function with slope gamma and intercept c
    gamma = 0.2;
    c = -1;
    G = tanh(gamma*U*V' + c);

end

