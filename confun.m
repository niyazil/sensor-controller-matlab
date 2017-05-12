function[c,ceq]=confun(P,varTheta,meanTheta,DpAllOn,Rthetax_Alg,Rx_Alg,Rv_Alg,Dthres)

temp=diag(DpAllOn/sqrt(Pmax)); %replace Pmax entries with P vector variable
Dp=diag(temp.*P);
c=varTheta+meanTheta^2-Rthetax_Alg'*Dp*inv(Dp*Rx_Alg*Dp+Rv_Alg)*Dp*Rthetax_Alg-Dthres;
ceq=[];

