function [min_par,max_par,rate]=gen_agent_response_curve_uniform(N_agent,p_min,p_max,rate_lb)

min_par=zeros(N_agent,1);
max_par=zeros(N_agent,1);
rate=zeros(N_agent,1);

for i=1:N_agent
    while min_par(i,1)<=0.0005
        min_par(i,1)=0+p_min*rand();
    end
    
    while (max_par(i,1)<=min_par(i,1))||(max_par(i,1)>=1)
        max_par(i,1)=0.005+p_max*rand();
    end
    
    while (rate(i,1)<=0.2)||(rate(i,1)>=rate_lb)
        rate(i,1)=0.2+rand()*(rate_lb-0.2);
    end
    
end

end