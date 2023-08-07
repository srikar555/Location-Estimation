clc
clear 
close all
x=100*rand;
y=100*rand;
D = 6;
x1 = D/2;
x2 = -D/2;
y1=0;
y2=0;
d2 = sqrt((y-y2)^2 + (x-x2)^2);
d1 = sqrt((y-y1)^2 + (x-x1)^2);
% delta_d = d2-d1;
% b= sqrt((D^2 - delta_d^2)/4);
% a=sqrt((delta_d^2)/4);
td=1:1:5;
for ii=1:length(td)
delta_d = td(ii);
b= sqrt((D^2 - delta_d^2)/4);
a=sqrt((delta_d^2)/4);
hplot(a,b);
hold on
end
legend(string(td))
hold off
function  hplot(a,b)
fplot(@(x)(sqrt(((x.^2/a^2)-1).*b^2)),'Color','b');
hold on
fplot(@(x)(-sqrt(((x.^2/a^2)-1).*b^2)),'Color','b');
hold off
end

