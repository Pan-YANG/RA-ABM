function [exp_par_rate]=cal_expected_response(Incentive,params)
% function to calculate the expected participation rate of agents, 
% assuming logit function for the response curve

exp_par_rate=params(:,1)./(1+exp(params(:,2).*Incentive+params(:,3)));
exp_par_rate=max(0,min(1,exp_par_rate));

end
