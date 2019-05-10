function [result]=ABM_batch(N_agent,p_min,p_max,rate_lb,sigma,budget,Incentive_range,N_iteration,...
                               rain_field_true,radar_field,gauge_xy,alpha_P,X,Y,folder,N_cluster,k,window_size)
% running the integrated reward allocation-ABM-rainfall intepolation model in batch mode

% generate the 'true' response curves
	[min_par,max_par,rate]=gen_agent_response_curve_uniform(N_agent,p_min,p_max,rate_lb);

% manager estimate the response curves of agents
	[params,is_par,Incentive_hist]=esti_res_curve_from_hist_withfixed_success...
                                    (max_par,min_par,rate,Incentive_range,N_iteration);

    parfor j=1:50 % Run different policies in for 50 stochastic realizations
    
        results_uni=ABM_eval_uniform_incentive(rain_field_true,radar_field,gauge_xy,...
											budget,alpha_P,max_par,min_par,rate,params,...
											X,Y,folder,j);    % policy URP
                                        
        results_maxN=ABM_eval_historical_maxN(rain_field_true,radar_field,gauge_xy,...
											budget,alpha_P,max_par,min_par,rate,params,...
											X,Y,folder,N_cluster,j);       % policy MPP                          

        results_share=ABM_eval_share_budget(rain_field_true,radar_field,gauge_xy,...
											budget,alpha_P,max_par,min_par,rate,...
											X,Y,folder,j);					% policy RSP   
                                        
        results_maxN_pop_weighted=ABM_eval_historical_max_N_pop_weighted(rain_field_true,radar_field,gauge_xy,...
                                        budget,alpha_P,max_par,min_par,rate,params,... 									
                                        X,Y,folder,N_cluster,window_size,k,j);   % policy MDPP
		
		
		% retrieve results									
        ARE_uni(j,:)=results_uni.ARE;
        total_uni(j,:)=results_uni.total_par;
        RMSE_uni(j,:)=results_uni.RMSE;
        cost_uni(j,:)=results_uni.cost;
        
        ARE_maxN(j,:)=results_maxN.ARE;
        total_maxN(j,:)=results_maxN.total_par;
        RMSE_maxN(j,:)=results_maxN.RMSE;
        cost_maxN(j,:)=results_maxN.cost;
        
        ARE_share(j,:)=results_share.ARE;
        total_share(j,:)=results_share.total_par;
        RMSE_share(j,:)=results_share.RMSE;
        cost_share(j,:)=results_share.cost;
    
        ARE_maxN_pop_weighted(j,:)=results_maxN_pop_weighted.ARE;
        total_maxN_pop_weighted(j,:)=results_maxN_pop_weighted.total_par;
        RMSE_maxN_pop_weighted(j,:)=results_maxN_pop_weighted.RMSE;
        cost_maxN_pop_weighted(j,:)=results_maxN_pop_weighted.cost;
    end                                                         

result.ARE_uni=ARE_uni;
result.total_uni=total_uni;
result.RMSE_uni=RMSE_uni;
result.cost_uni=cost_uni;

result.ARE_maxN=ARE_maxN;
result.total_maxN=total_maxN;
result.RMSE_maxN=RMSE_maxN;
result.cost_maxN=cost_maxN;

result.ARE_share=ARE_share;
result.total_share=total_share;
result.RMSE_share=RMSE_share;
result.cost_share=cost_share;

result.ARE_maxN_pop_weighted=ARE_maxN_pop_weighted;
result.total_maxN_pop_weighted=total_maxN_pop_weighted;
result.RMSE_maxN_pop_weighted=RMSE_maxN_pop_weighted;
result.cost_maxN_pop_weighted=cost_maxN_pop_weighted;

end