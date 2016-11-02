cor_func = @(x) exp(-x.^2); %Correlation function
x=linspace(0,1);
T=1; %time period
spec=disft(cor_func(x));
ab_spec=abs(spec);
plot(0:1/T:(length(x)-1)/T,ab_spec);%plotting dft of cor_func
figure;
plot(0:1/T:(length(x)-1)/T,ab_spec.^2);
avg_pow=mean(ab_spec.^2);
vari=0.5*avg_pow*((2*pi)^3);%line(1-d)/cube edge(3-d) length 1
st_dev=sqrt(vari);
n=100;%number of co-ordinates in the line/cube edge(3-d)
a = st_dev*randn(n/2-1,1);
a(n/2)=0;
a(n/2+1:n)=a(n/2:-1:1);
b = st_dev*randn(n/2-1,1);
b(n/2)=0;
b(n/2+1:n)=-b(n/2:-1:1);
c=a+1j*b;
l=linspace(-.5,.5);

for r=1:n
    summ=0;
    for t=1:n
        summ= summ+c(t)*exp(1j*2*pi*l(t)*r);
    end
    y(r)=summ;
end
y=abs(y);
[Y1,Y2]=meshgrid(y,y);
Y=sum(spdiags(Y1.*Y2));
plot(0:99,Y(100:199),'r*');
hold on;
plot(0:.01:.99,cor_func(0:.01:.99),'g*');










