function [params]=modified_logit_regre(Input,Target)
% function to estimate the parameters of the modified logistic regression

N = length(Target);
mean_par=mean(Target);
fun=@(params)cal_likeli_modified_logit(params,Input,Target);
opts=optimoptions('fmincon','MaxIter',1000,'MaxFunEvals',100000);
lb1=-5;
lb2=-5;
ub1=5;
ub2=5;
A=[0,1,1;0,-1,-1;0,1,-1;0,-1,1];
b=[(ub1-lb2)*0.75,(ub1-lb2)*0.75,(ub1-lb2)*0.75,(ub1-lb2)*0.75];
x0=rand(5,3);
x0(:,1)=mean_par+x0(:,1)*(sqrt(mean_par)-mean_par);
x0(:,2)=lb1+x0(:,2)*(ub1-lb1);
x0(:,3)=lb2+x0(:,3)*(ub2-lb2);
[params_candidate(:,1),feval(1,1)]=fmincon(fun,x0(1,:)',A,b,[],[],[mean_par,lb1,lb2],[sqrt(mean_par),ub1,ub2],[],opts);
[params_candidate(:,2),feval(2,1)]=fmincon(fun,x0(2,:)',A,b,[],[],[mean_par,lb1,lb2],[sqrt(mean_par),ub1,ub2],[],opts);
[params_candidate(:,3),feval(3,1)]=fmincon(fun,x0(3,:)',A,b,[],[],[mean_par,lb1,lb2],[sqrt(mean_par),ub1,ub2],[],opts);
[params_candidate(:,4),feval(4,1)]=fmincon(fun,x0(4,:)',A,b,[],[],[mean_par,lb1,lb2],[sqrt(mean_par),ub1,ub2],[],opts);
[params_candidate(:,5),feval(5,1)]=fmincon(fun,x0(5,:)',A,b,[],[],[mean_par,lb1,lb2],[sqrt(mean_par),ub1,ub2],[],opts);

[~,ID]=min(feval);
params=params_candidate(:,ID);

end

function [likelihood]=cal_likeli_modified_logit(params,Input,Target)

p=cal_logit(params,Input);
likelihood= (p.^Target).*((1-p).^(1-Target));
likelihood=-sum(log(likelihood));

end
