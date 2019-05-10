function [params,is_par,Incentive_hist]=esti_res_curve_from_hist_withfixed_success(max_par,min_par,rate,Incentive_range,N_iteration)
% function to estimate the response curve by iteratively experiment on the agents
% the estimation is done by assuming logistic regression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M, N are the parameters governing the participation rate-incentive curve
% max_par, min_par are the maximum and minimum participation rate
% Incentive_range is the maximum and minimum value of Incentive
% N_iteration is the number of experiments (which represent the length of history)

N_agent=length(max_par);

for i=1:N_agent
    
    n_success=0;
    j=1;
    while n_success<=N_iteration
        Incentive_hist{i,1}(j,1) = Incentive_range(1)+(Incentive_range(2)-Incentive_range(1))*rand(1,1);
        par_rate=cal_response_curve_3param(max_par(i),min_par(i),rate(i),Incentive_hist{i,1}(j,1)); % the participation rate of each agent
        is_par{i,1}(j,1)=rand(1,1)<=par_rate; % logics determing if the agent is going to participate
        if is_par{i,1}(j,1)
            n_success=n_success+1;
        else
        end
        j=j+1;
    end
   
end

params = zeros(N_agent,3);

parfor i=1:N_agent
	params(i,:)=modified_logit_regre(Incentive_hist{i,1},is_par{i,1});
end

end