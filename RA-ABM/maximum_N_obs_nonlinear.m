function [Incentive]=maximum_N_obs_nonlinear(coeff,idx,budget,is_known)
% function to maximum the expected total number of participation using nonlinear programing
C=unique(idx);
[M,N]=size(coeff);

fun=@(Incentive_cluster)cal_E_N_obs(Incentive_cluster,idx,coeff,is_known);
x0=5*rand(length(C),1);
nonlcon=@(Incentive_cluster)budget_constrain(Incentive_cluster,idx,coeff,budget,is_known);

options=optimoptions('fmincon','Display','off','Algorithm','interior-point',...
                        'UseParallel',0,'MaxFunEvals',100000);
Incentive_cluster=fmincon(fun,x0,[],[],[],[],zeros(length(C),1),[],nonlcon,options);

Incentive=zeros(M,1);

for i=1:length(C)
	IDs=(idx==C(i));
	Incentive(IDs)=Incentive_cluster(C(i));
end

end

function [E_N_obs]=cal_E_N_obs(Incentive_cluster,idx,coeff,is_known)
% function to calcualte the expected number of observations
C=unique(idx);
[M,N]=size(coeff);
Incentive=zeros(M,1);

for i=1:length(C)
	IDs=(idx==C(i));
	Incentive(IDs)=Incentive_cluster(C(i));
end

switch is_known
    case 1
        par_rate=cal_response_curve_3param(coeff(:,1),coeff(:,2),coeff(:,3),Incentive);
    case 2
        par_rate=cal_expected_response(Incentive,coeff(:,1:3));      
end
E_N_obs=-sum(par_rate);

end


function [c,ceq]=budget_constrain(Incentive_cluster,idx,coeff,budget,is_known)
% function to calcualte the budget constain
C=unique(idx);
[M,N]=size(coeff);
Incentive=zeros(M,1);

for i=1:length(C)
	IDs=(idx==C(i));
	Incentive(IDs)=Incentive_cluster(C(i));
end

switch is_known
    case 1
        par_rate=cal_response_curve_3param(coeff(:,1),coeff(:,2),coeff(:,3),Incentive);
    case 2
        par_rate=cal_expected_response(Incentive,coeff(:,1:3)); 
end
c=par_rate'*Incentive-budget;
ceq=[];
end


