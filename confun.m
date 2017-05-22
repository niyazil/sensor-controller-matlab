function[c,ceq]=confun(P,varTheta,meanTheta,DpAllOn_Alg,Rthetax_Alg,Rx_Alg,Rv_Alg,Dthres,Pmax)

temp=diag(DpAllOn_Alg./sqrt(Pmax)); %replace Pmax entries with P vector variable
Dp_Alg=diag(temp'.*sqrt(P));

c=varTheta+meanTheta^2-Rthetax_Alg'*Dp_Alg*inv(Dp_Alg*Rx_Alg*Dp_Alg+Rv_Alg)*Dp_Alg*Rthetax_Alg-Dthres;
ceq=[];

