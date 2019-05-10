function [rain_field_esti,Incentive_rec,is_par]=ABM_uniform_incentive(rain_field_true,radar_field,gauge_xy,...
																		Incentive,alpha_P,max_par,min_par,rate,...
																		X,Y,folder,loop_ID)
N_event=length(rain_field_true);                                                                    
for i=1:N_event

	rain_field_true_i=rain_field_true{i,1};
	radar_field_i=radar_field{i,1};
    X_i=X{i,1};
    Y_i=Y{i,1};
	[X_Lim,Y_Lim,T]=size(rain_field_true_i);
	
	for t=1:T % prepare the rain gauge observation of rainfall
		gauge_obs(:,t)=diag(rain_field_true_i(ceil(gauge_xy(:,1)),ceil(gauge_xy(:,2)),t));
	end
	
	gauge_data.X_obs=gauge_xy(:,1);
	gauge_data.Y_obs=gauge_xy(:,2);
	gauge_data.P_obs=gauge_obs; % prepare the gauge_data
	
	% prepare the X and Y positions of the crowds
	X_obs_i=[];
    Y_obs_i=[];
    P_obs_i=[];
    P_true_i=[];
    
    for t=1:T
        [is_par_i(:,t),P_true(:,t),P_obs,X_obs,Y_obs]=cal_agent_response_3param(rain_field_true_i(:,:,t),X_i(:,t),Y_i(:,t),alpha_P,Incentive,max_par,min_par,rate);
		[rain_field_esti_i(:,:,t),~]=esti_rain_field_parfor(radar_field_i,rain_field_true_i,gauge_data,P_obs,X_obs,Y_obs,t,folder,loop_ID);
                
    end
                                                        
                                                        
                                                        
	rain_field_esti{i,1}=rain_field_esti_i;
    is_par{i,1}=is_par_i;
    Incentive_rec{i,1}=Incentive*ones(length(max_par),T);
	
end
end
