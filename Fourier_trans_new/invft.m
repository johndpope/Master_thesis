function [fild] = invft(in_sig,len)
% in_sig is the input signal - a vector
n=len;



for a=0:n-1 %time or x
    t=a+1;
    
    sum=0;
    
    
    %     if n|2==0
    %
    %           a=a-((n+2)/2);
    %
    %         else
    %             a=a-ceil(n/2);
    %         end
    
    for b=1:n%k or frequency
        k=b-1;
%                 if n|2==0
%                    k=b-((n+2)/2);
%                 else
%                     k=b-ceil(n/2);
%                 end
               
               % sum=sum+(in_sig(b)*((-1)^a)*exp(1j*2*pi*a*k/n));
        sum=sum+(in_sig(b)*exp(1j*2*pi*a*k/n));
    end
    fild(t)=1/n*sum;
end

