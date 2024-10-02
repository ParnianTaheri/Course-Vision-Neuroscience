function [C1]=WANG_E(params)
thr = params(1);
u0 = params(2);
nDT=params(4);
I0=params(3);
% nDT=.5;
% I0=0.3255;
coh=1*[3.2 6.4 12.8 25.6];
ModelRunNo=5000;


C1=zeros(1,20);
blockN=0;
for j0=1:ModelRunNo
        r0=(size(coh,2)*10-1e-4)*rand();
        nn=1+floor(r0/10);

        X=WANG([thr (coh(nn)) I0 u0]);

        C1(j0,2)=nn;%coh       
        C1(j0,3)=X(3);%choice
        C1(j0,5)=X(1)+nDT;
        C1(j0,6)=X(3);%ACC  
%         C1(j0,8)=thr;%thr
%         C1(j0,9)=X(2);%deltaS
%         C1(j0,13)=I0;
%         C1(j0,15)=u0;
%         C1(j0,16)=blockN;
%         C1(j0,19)=nDT; %non Decision Time

end

end