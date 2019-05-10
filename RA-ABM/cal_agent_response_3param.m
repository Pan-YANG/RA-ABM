function [is_par,P_true,P_obs,X_obs,Y_obs]=cal_agent_response_3param(rain_field_true,X,Y,alpha_P,Incentive,max_par,min_par,rate)
% rain_field_true is the ground truth rainfall field 

% X, Y are the x and y positions of agents at each time step, N_agent*1 array
% alpha_P is a N_agent*1 array with each element the alpha_P value of each agent

% Incentive are the incentive each agent recieves
% max_par, min_par are the maximum and minimum participation rate


N_agent=length(X);  % the number of agents 
X_ID=ceil(X); 
Y_ID=ceil(Y); % the X and Y IDs of the agents

P_true=diag(rain_field_true(X_ID,Y_ID));  % the ground truth rainfall intensity of the grid points where agents locate
par_rate=cal_response_curve_3param(max_par,min_par,rate,Incentive); % the participation rate of each agent

is_par=rand(N_agent,1)<=par_rate; % logics determing if the agent is going to participate

P_obs=P_true+randn(N_agent,1).*alpha_P.*P_true;  % therotical observed rainfall intensities if all agents are participating
P_obs(P_true==0)=0;
P_obs(P_obs<0)=0;

P_true=P_true.*(1./is_par); % ground truth rainfall intensity, only the participated agents are not Inf
P_obs=P_obs.*(1./is_par); % observed rainfall intensity, only the participated agents  are not Inf
X_obs=X.*(1./is_par);
Y_obs=Y.*(1./is_par); % X and Y positions, only the participated agents are not Inf

end

