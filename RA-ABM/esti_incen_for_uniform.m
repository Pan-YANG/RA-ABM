function [Incentive]=esti_incen_for_uniform(budget,params)
% function to estimate the incentive provided for the uniform incentive scheme, 
% given the amount of budget

fun=@(Incentive)cal_diff_sqr_budget(Incentive,params,budget);
x0=rand();
Incentive=fmincon(fun,x0,[],[],[],[],0,[]);

end

function [diff_sqr]=cal_diff_sqr_budget(Incentive,params,budget)

par_rate=cal_expected_response(Incentive,params);
cost=sum(par_rate.*Incentive);
diff_sqr=(cost-budget)^2;

end
