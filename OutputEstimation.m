function [ y_output ] = OutputEstimation( A, B, d, u, y, m )
%{
    Any system can be written as 

                                            z^(-d) B                y
                                G = -------------------- = -----------
                                                   A                   u

    where
-- y : output of the system
-- u : control action (input to the system)
-- A = 1 + a_1 z^-1 + a_2 z^-1 + ... + a_na z^(-na) 
-- B = b_0 + b_1 z^-1 + b_2 z^-1 + ... + b_nb z^(-nb)
-- d : delay in the system. Notice that this form of the Diaphontaing solution is available for systems with d>=1


    This function is intended to find the output of a system like a
    transfer function given the input, the system which you can have the
    orders (na, nb, d), the previous output and the point at which you want
    to estimate the system at. This is like a difference equation
    estimation for a system.

    Notice that in difference equation you have "u" inputs as a vector and
    "y" may not be estimated yet and hence you can initialize "y" with
    zeros and each point estimated should be added to "y" as the present
    output depends on the previous outputs and the inputs, then, the
    function should be like that 

        y = zeros(1, length(u))
        for m=1:length(u)
            y(m) = outputestimation( A, B, d, u, y, m );
        end

    This function is going to be benifical if the A, B matrices are going
    to be changed over time such as in Recursive Least Squares algorithm
    such that each loop we are going to find "theta" which contain A, B.
    Hence, we can calculated the estimated ouput based on the estimated
    parameters using this function as 

        y_estm = zeros(1, length(u))
        for m=1:length(u)
            y_estm(m) = outputestimation( A, B, d, u, y_estm, m );
        end

Function inputs and outputs
Inputs
-- y : vector that contains the previous outputs of the system
-- u : vector that contains the inputs to the system
    A = [1,  a_1,  a_2,  a_3,  ..., a_na] ----> size(1, na)
    B = [b_0,  b_1, b _2,  b_3,  ..., a_nb]----> size(1, nb)
    d : delay in the system (d>=1)
    m : point at which we want to find the solution at.
Outputs
    y : the output at point m as estimated from the previous outputs and inputs u
%}

%% order
na = length(A) - 1;
nb = length(B) -1;
%% coefficients
B = B/A(1); % T ensure the first element (the highest power) is equal to 1
A = A/A(1); % T ensure the first element (the highest power) is equal to 1
A = -A(2:end); % to delete "1" at the first and -ve for the difference eqn
%% y(m)
y(m)=0;
for j=1:na
    if m-j >0
        y(m)=y(m)+A(j)*y(m-j);
    end
end
for J=0:length(B)-1
    if m-J-d > 0
        y(m)=y(m)+B(J+1)*u(m-d-J);
    end
end
y_output=y(m);
end
