function [results]=ABM_eval_historical_max_N_pop_weighted(rain_field_true,radar_field,gauge_xy,...
											budget,alpha_P,max_par,min_par,rate,params,...
											X,Y,folder,N_cluster,window_size,power,loop_ID)
% function to run the ABM model (to maximize the total measured rainfall intensity)
% this function can also be used to test the performance of the optimized function according to the test dataset
%%%%%% INPUTS %%%%%%
% rain_field_true is a cell containing all the ground truth rainfall field, each element corresponds to a rainfall event
% radar_field is a cell containing all the radar estimated rainfall field, each element corresponds to a rainfall event
% gauge_xy is a 2d array containing the X and Y positions of the rain gauges
% budget is the total amount of incentive that could be allocated
% alpha_P is a N_agent*1 array with each element the alpha_P value of each agent
% max_par, min_par are the maximum and minimum participation rate
% params are the historically estimated parameters of the response curve (assuming logit function)
% X and Y are the x and y positions of the agents
% folder is the folder where the .csv files written in (for function 'esti_rain_field')

%%%%%% OUTPUTS %%%%%%
% results is a strcture containing historical information about the agents, and the optimized parameters of the linear Incentive function
%     results.cost is the incentives allocated at each time step
%     results.ARE is the ARE error statistic at each time step
%     results.RMSE is the RMSE error statistic at each time step
%     results.total_par is the total # of participants at each time step
	
N_event=length(rain_field_true);

	[rain_field_esti,response,Incentive]=ABM_nonlinear_historical_curves_max_N_pop_weighted(rain_field_true,radar_field,gauge_xy,...
																		budget,alpha_P,max_par,min_par,rate,...
																		params,X,Y,folder,N_cluster,window_size,power,loop_ID);
    id=1;                                      
    for i=1:N_event

        [~,~,T]=size(rain_field_true{i,1});
        	
        for j=1:T
		
        	results.cost(id,1)=sum(Incentive{i,1}(:,j).*response{i,1}(:,j));
            results.total_par(id,1)=sum(response{i,1}(:,j));
            [results.ARE(id,1),results.RMSE(id,1)]=...
                cal_rain_error(rain_field_true{i,1}(:,:,j),rain_field_esti{i,1}(:,:,j));
            id=id+1;
            
        end
        
    end


