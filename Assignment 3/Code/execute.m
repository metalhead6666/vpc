clear all
clc

% part 1

A = cell(4, 1);
b = cell(4, 1);
values_array = cell(4, 1);

% exercise 1 & 2
for iterator = 1 : 4
    send = sprintf('../Output/A%d', iterator);
    name = sprintf('../Input/A%d', iterator);
    image = strcat(name, '.bmp');
    file = strcat(name, '.pts');
    
    [A{iterator}, b{iterator}, values_array{iterator}] = calculate_matrix_A(image, file, send);
end

% exercise 3-7
[B, M, Xw, Yw, Zw, xf, yf] = calculate_matrix_M(A, b, values_array);

% part 2
% exercise 1-4
second_part(B, Xw, Yw, Zw, xf, yf);

% exercise 5
qr_decomposition(M);
