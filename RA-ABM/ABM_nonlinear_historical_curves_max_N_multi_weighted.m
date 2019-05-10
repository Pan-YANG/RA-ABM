function [rain_field_esti,is_par,Incentive_rec]=ABM_nonlinear_historical_curves_max_N_multi_weighted(rain_field_true,radar_field,gauge_xy,...
																		budget,alpha_P,max_par,min_par,rate,...
																		params,X,Y,folder,N_cluster,window_size,power_P,power_V,k,loop_ID)
N_event=length(rain_field_true);          
N_agent=length(max_par);

for i=1:N_event

	rain_field_true_i=rain_field_true{i,1};
	radar_field_i=radar_field{i,1};
    X_i=X{i,1};
    Y_i=Y{i,1};
	[X_max,Y_max,T]=size(rain_field_true_i);
	
	for t=1:T % prepare the rain gauge observation of rainfall
		gauge_obs(:,t)=diag(rain_field_true_i(ceil(gauge_xy(:,1)),ceil(gauge_xy(:,2)),t));
	end
	
	gauge_data.X_obs=gauge_xy(:,1);
	gauge_data.Y_obs=gauge_xy(:,2);
	gauge_data.P_obs=gauge_obs; % prepare the gauge_data
	
	Incentive=zeros(N_agent,T);
    idx=zeros(N_agent,T);
    
    X_obs_i=[];
    Y_obs_i=[];
    P_obs_i=[];
    P_true_i=[];
    is_know=2;
    
    for t=1:T
        
        coeff=[params,X_i(:,t),Y_i(:,t)];
        options=statset('UseParallel',0);
        idx(:,t)=squeeze(kmeans(coeff,N_cluster,'Options',options,'MaxIter',10000,'Replicates',10));
        
        if t==1
            Incentive(:,t)=maximum_N_obs_nonlinear(coeff,idx(:,t),budget,is_know);
        else
            P_underlying=diag(rain_field_esti_i(ceil(X_i(:,t)),ceil(Y_i(:,t)),t-1));
            P_underlying(P_underlying<0.0001)=0.0001;
            P_max=max(P_underlying(:))+0.001;
            P_weight=(P_underlying/P_max).^0.3; % P weight
            
            spatial_variability=cal_spatial_variability(rain_field_esti_i(:,:,t-1),X_i(:,t),Y_i(:,t),X_max,Y_max,window_size);
            V_max=max(spatial_variability(:))+0.001;
            V_weight=(spatial_variability/V_max).^0.4; % V weight
            
            pop_den=cal_pop_den(X_i(:,t),Y_i(:,t),X_max,Y_max,window_size);
            D_inverse=1./pop_den;
            D_inverse_max=max(D_inverse(:))+0.001;
            D_weight=(D_inverse/D_inverse_max).^0.3; %D weight
            
            Incentive(:,t)=maximum_N_weighted_nonlinear(coeff,idx(:,t),P_weight*power_P+V_weight*power_V+D_weight*k,...
                                                    budget,is_know);
        end
        
        
        [is_par_i(:,t),P_true,P_obs,X_obs,Y_obs]=cal_agent_response_3param(rain_field_true_i(:,:,t),X_i(:,t),Y_i(:,t),alpha_P,Incentive(:,t),max_par,min_par,rate);
		[rain_field_esti_i(:,:,t),rain_field_var_i(:,:,t)]=esti_rain_field_parfor(radar_field_i,rain_field_true_i,gauge_data,P_obs,X_obs,Y_obs,t,folder,loop_ID);
        
    end
                                                        
                                                        
                                                        
	rain_field_esti{i,1}=rain_field_esti_i;
    is_par{i,1}=is_par_i;
    Incentive_rec{i,1}=Incentive;
	
end
end
