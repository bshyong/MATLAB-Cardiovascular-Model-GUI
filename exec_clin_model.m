close all;
clear all;
clc;
parameter_struct
[yinit]=get_clinical_initial;
opts=odeset('Stats', 'on');
[Tout, Yout]=ode23s(@clin_model_2, [0 20], yinit, opts);
plots