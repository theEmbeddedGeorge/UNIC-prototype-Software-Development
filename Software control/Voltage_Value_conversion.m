x = 557000;
V_max = 65536.0;
V_range = 10;
V_ori = x/V_max * V_range -5;  
display(V_ori);

V_exp = linspace(-3.4,3.4,10); 
x_ori = (V_exp + 5) / 10.0 * V_max;
display(x_ori);
display(V_exp);
x_ori = x_ori';
V_exp = V_exp';