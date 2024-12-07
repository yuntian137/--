
z=tf('z',0.01);
num = -0.000893*(z^2-0.808*z+0.998)*(z-16.448057);
den = (z^2-0.075*z+0.88)*(z-0.965762)*(z+0.144853);
% sym2poly(num)
% sym2poly(den)
G=num/den/z;
bodeplot(G)
kp = 20;
ki = 70;
PI = kp + ki*0.01/(z-1);
kc = 0.7;
C = kc *  (z^2-0.075*z+0.88)/(z^2-0.808*z+0.998);
op = PI * C * G;
bodeplot(op);
margin(op);
cl=feedback(op,1);
step(feedback(op,1));
%bodeplot(G,G*C);
 clccc = PI*C
 