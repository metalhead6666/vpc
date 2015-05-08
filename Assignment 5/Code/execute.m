clear all
clc

[F, corners, images, p] = fundamental_matrix();
epipolar_estimation(F, corners, images, p);
E = essential_matrix(F);
