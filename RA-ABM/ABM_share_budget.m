function [rain_field_esti,is_par,Incentive_rec_rec]=ABM_share_budget(rain_field_true,radar_field,gauge_xy,...
																		budget,alpha_P,max_par,min_par,rate,...
																		X,Y,folder,loop_ID)
N_event=length(rain_field_true);          
N_agent=length(max_par);
% model warm up
total_par_warmup=zeros(200,1);
Incentive_warmup=zeros(200,1);
total_par_warmup(1)=50;

for i=2:200
    Incentive_warmup(i)=50/total_par_warmup(i-1);
    par_rate=cal_response_curve_3param(max_par,min_par,rate,Incentive_warmup(i));
    is_par_warmup=rand(N_agent,1)<=par_rate;
    total_par_warmup(i)=sum(is_par_warmup);
end

% actual ABM
Incentive_history=Incentive_warmup(end);
for i=1:N_event

	rain_field_true_i=rain_field_true{i,1};
	radar_field_i=radar_field{i,1};
    X_i=X{i,1};
    Y_i=Y{i,1};
	[~,~,T]=size(rain_field_true_i);
	
	for t=1:T % prepare the rain gauge observation of rainfall
		gauge_obs(:,t)=diag(rain_field_true_i(ceil(gauge_xy(:,1)),ceil(gauge_xy(:,2)),t));
	end
	
	gauge_data.X_obs=gauge_xy(:,1);
	gauge_data.Y_obs=gauge_xy(:,2);
	gauge_data.P_obs=gauge_obs; % prepare the gauge_data
	
	Incentive_exp=zeros(N_agent,T);
    Incentive_rec=zeros(N_agent,T);
    
    X_obs_i=[];
    Y_obs_i=[];
    P_obs_i=[];
    P_true_i=[];
    
    for t=1:T
        
        Incentive_exp(:,t)=Incentive_history;
        [is_par_i(:,t),P_true,P_obs,X_obs,Y_obs]=cal_agent_response_3param(rain_field_true_i(:,:,t),X_i(:,t),Y_i(:,t),alpha_P,Incentive_exp(:,t),max_par,min_par,rate);
		[rain_field_esti_i(:,:,t),~]=esti_rain_field_parfor(radar_field_i,rain_field_true_i,gauge_data,P_obs,X_obs,Y_obs,t,folder,loop_ID);
        Incentive_rec(:,t)=budget/sum(is_par_i(:,t));
        Incentive_history=Incentive_rec(:,t);
    end
                                                        
                                                        
                                                        
	rain_field_esti{i,1}=rain_field_esti_i;
    is_par{i,1}=is_par_i;
    Incentive_rec_rec{i,1}=Incentive_rec;
    
end
end
