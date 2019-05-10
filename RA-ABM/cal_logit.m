function [p]=cal_logit(params,Input)

p=params(1,:)./(1+exp(params(2)*Input+params(3)));
p=max(0,min(1,p));

end
