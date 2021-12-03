function [X] = SIC_decode(Y,H,val)

[~,N] = size(H);

[~,L] = size(Y);

[Q,R] = qr(H); % décomposition QR de la matrice du canal H

Z = Q'*Y;

X = zeros(N,L);

for l=1:L
    MSE=abs(val*R(N,N)-Z(N,l)).^2;
    [~,ind]=min(MSE);
    X(N,l)=val(ind);
end

for n=N-1:-1:1
    for l=1:L
        SUM=sum(R(n,n+1:N).*X(n+1:N,l));
        MSE=abs(Z(n,l)-R(n,n)*val-SUM).^2;
        [~,ind]=min(MSE);
        X(n,l)=val(ind);
    end
end

X=reshape(X, 1,N*L);

end

