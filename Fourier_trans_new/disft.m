function [spec] = disft(in_sig)
% in_sig is the input signal - a vector
n=max(size(in_sig));

for k=0:n-1
    sum=0;
    for t=0:n-1
       
        sum=sum+in_sig(t+1)*exp(-1j*2*pi*k*t/n);
    end
   
    spec(k+1)=sum;
end

end

