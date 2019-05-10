function [par_rate]=cal_response_curve_3param(max_par,min_par,rate,I)

par_rate=max_par.*min_par.*exp(rate.*I)./(max_par+min_par.*(exp(rate.*I)-1));

end

