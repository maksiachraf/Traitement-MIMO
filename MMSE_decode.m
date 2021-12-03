function [X] = MMSE_decode(Y,H,sigma_v,val)

[~,N] = size(H);

[~,L] = size(Y);

Q = eye(N);

FMMSE= inv(H*Q*H' + sigma_v*eye(N)) * H * Q;

Z=FMMSE'*Y;

X=zeros(N,L);

for n=1:N
    for l=1:L
        MSE=abs(val-Z(n,l)).^2;
        [~,ind]=min(MSE);
        X(n,l)=val(ind);
    end
end

X=reshape(X, 1,N*L);

end

