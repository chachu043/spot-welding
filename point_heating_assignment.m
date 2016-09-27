clear , clc
Lx = 1; % length along x of the plate
Ly = 1; % length along y of the plate
Nx = 40; % number of times the length along x is descritized
Ny = 40; % number of times the length along y is descritized
dx = Lx/Nx; % distance between each node along x
dy = Ly/Ny; % distance between each node along y

k = 205;               % Thermal conductivity (W/mK)
rho = 2700;             % Density (kg/m^3)
Cp = 900;               % Specific heat (J/kgK)
alpha = k/(rho*Cp);     % Thermal diffusivity (m^2/s)

deltaT = 5.759; % time step in seconds
deltaT_stable_max = .25*dx^2/alpha;     % Maximum stable time step
% above is the stability criterion

Lmax = 10^4; %maximum number of time steps before it stop whatsoever

T= 25*ones(Nx+1,Ny+1); %initialise the temperatures at the nodes to guess
Tplot = ones(Lmax,1); %initialise Tplot to allocate memory

x = 0:dx:Lx;            % Create x-distance node locations
y = 0:dy:Ly;            % Create y-distance node locations

for L = 1:Lmax       % Loop through time steps
    Told = T;           % Store previous T array as Told for next time step
    
    for j = 1:Ny        % Loop through rows
        for i = 1:Nx% Loop through columns
            if i==20&& j==20;
                 T(i,j)= 0.225*Told(i,j)+0.193*(Told(i-1,j)+Told(i+1,j)+Told(i,j-1)+Told(i,j+1)+1500);
            elseif i==1 && j==1
                T(i,j) = 0.04614*Told(i,j)+0.37*(Told(i+1,j)+Told(i,j+1)+14.45);
            elseif i==1 && j==Ny;
                T(i,j) = 0.04614*Told(i,j)+0.37*(Told(i+1,j)+Told(i,j-1)+14.45);
            elseif i==Nx && j==1;
                T(i,j) = 0.04614*Told(i,j)+0.37*(Told(i-1,j)+Told(i,j+1)+14.45);
            elseif i==Nx && j==Ny;
                T(i,j) = 0.04614*Told(i,j)+0.37*(Told(i-1,j)+Told(i,j-1)+14.45);
            elseif any(2:Nx-1==i) && j==1;
                T(i,j) = 0.153*Told(i,j)+0.185*(Told(i-1,j)+Told(i+1,j)+2*Told(i,j+1)+14.45);
            elseif any(2:Nx-1==i) && j==Ny;
                T(i,j) = 0.153*Told(i,j)+0.185*(Told(i-1,j)+Told(i+1,j)+2*Told(i,j-1)+14.45);
           elseif any(2:Ny-1==j) && i==1;
                T(i,j) = 0.153*Told(i,j)+0.185*(Told(i,j-1)+Told(i,j+1)+2*Told(i+1,j)+14.45);
            elseif any(2:Ny-1==j) && i==Nx;
                T(i,j)= 0.153*Told(i,j)+0.185*(Told(i,j-1)+Told(i,j+1)+2*Told(i-1,j)+14.45);
            else
                T(i,j)= 0.225*Told(i,j)+0.193*(Told(i-1,j)+Told(i+1,j)+Told(i,j-1)+Told(i,j+1));
                
            end

            
            
                
    
        end 
    end    
        
    Nc = 100;                    % Number of contours for plot
    dT = 1000/Nc;          % Temperature step between contours
    v = 0:dT:1000;               % Sets temperature levels for contours
    colormap(jet)               % Sets colors used for contour plot
    contourf(x, y, T',v, 'LineStyle', 'none') 
    colorbar                    % Adds a scale to the plot
    axis equal tight            % Makes the axes have equal length
    title(['Contour Plot of Temperature in deg. C at time = ',...
        num2str(deltaT*L/3600),' h']) 
    xlabel('x (m)') 
    ylabel('y (m)')        
    set(gca,'XTick',0:.1:Lx)    % Sets the x-axis tick mark locations
    set(gca,'YTick',0:.1:Ly)    % Sets the y-axis tick mark locations
    pause(0.001)                % Pause between time steps to display graph
        
    %if L == 55 || L == 65 || L == 80 % Chosen time steps to save plot
    %    saveas(gcf, ['Transient_Plot_Unstable_',num2str(L)], 'jpg'); % save plot
    %end    
end



