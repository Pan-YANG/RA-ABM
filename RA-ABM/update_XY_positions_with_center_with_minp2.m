function [X,Y]=update_XY_positions_with_center_with_minp2(N_agent,T,p_move,L_max,X_Lim,Y_Lim,...
                                    center_position,center_radius)
% N_agent is the number of agents
% T is the number of time steps
% p_move is the pobability that an agent moves
% L_max is the maximum distance that an agent can move within one time step
% X_Lim and Y_Lim are the boundary of the study area

X(:,1)=X_Lim*rand(N_agent,1);
Y(:,1)=Y_Lim*rand(N_agent,1); % initial position is set randomly

for t=2:T
    
   dist_to_center=sqrt((X(:,t-1)-center_position(1)).^2+(Y(:,t-1)-center_position(2)).^2);
   is_move=rand(N_agent,1)>(1-0.0035-p_move*(1-exp(-dist_to_center/center_radius)).^3); 
   L=L_max*rand(N_agent,1);
   L=L.*is_move; % the distances that agents moved within one time step
   theta=2*pi*rand(N_agent,1); % the directions that agents moved to 
   X(:,t)=X(:,t-1)+L.*sin(theta);
   Y(:,t)=Y(:,t-1)+L.*cos(theta); % update X and Y according to L and theta
   is_inbound_X=(X(:,t)>=0)&(X(:,t)<=X_Lim); % logics determing if X is within limit
   is_inbound_Y=(Y(:,t)>=0)&(Y(:,t)<=Y_Lim); % logics determing if Y is within limit
   while (sum(is_inbound_X)+sum(is_inbound_Y)<2*N_agent)
       
       ID_out_bound=(~is_inbound_X)|(~is_inbound_Y); % identify the agents that go outside boundary
       alphas=rand(sum(ID_out_bound),1);
       teltas=0.5*pi*rand(sum(ID_out_bound),1);
       % adjust the L and theta to avoid crossing boundary
       X(ID_out_bound,t)=X(ID_out_bound,t-1)+alphas...
           .*L(ID_out_bound).*sin(theta(ID_out_bound)+teltas); 
       Y(ID_out_bound,t)=Y(ID_out_bound,t-1)+alphas...
           .*L(ID_out_bound).*cos(theta(ID_out_bound)+teltas); 
       is_inbound_X=(X(:,t)>=0)&(X(:,t)<=X_Lim); % logics determing if X is within limit
       is_inbound_Y=(Y(:,t)>=0)&(Y(:,t)<=Y_Lim); % logics determing if Y is within limit
       
   end
   
end

end
