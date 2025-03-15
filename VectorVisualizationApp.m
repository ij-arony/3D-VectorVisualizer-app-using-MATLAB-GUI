classdef VectorVisualizationApp < handle
    properties
        Figure
        XInput
        YInput
        ZInput
        DoneButton
    end
    
    methods
       
        function app = VectorVisualizationApp()
            app.buildGUI();
        end
        
        function buildGUI(app)
            
            app.Figure = figure('Position', [600 150 800 500], 'Color', [0.6471 0.898 1], 'Name', '3D Vector Visualization', 'NumberTitle', 'off', 'Resize', 'off');
          
            uicontrol(app.Figure, 'Style', 'text', 'Position', [250 330 300 40], 'String', 'Enter the values for (𝚡, 𝚢, 𝚣) :  ', 'FontSize', 14, 'Fontweight', 'bold', 'BackgroundColor',[0.6471 0.898 1], 'ForegroundColor', [0 0.4 0.8]);
           
            uicontrol(app.Figure, 'Style', 'text', 'Position', [245 400 300 30], 'String', '◦•●◉✿  𝚈𝚘, 𝚋𝚞𝚍𝚍𝚢!  ✿◉●•◦', 'FontSize', 12, 'Fontweight', 'bold', 'ForegroundColor', [1 1 1], 'BackgroundColor', [0 0.4667 0.7118]);
            uicontrol(app.Figure, 'Style', 'text', 'Position', [240 450 300 30], 'String', '👻', 'FontSize', 20, 'Fontweight', 'bold', 'BackgroundColor',[0.6471 0.898 1], 'ForegroundColor', [0 0.4 0.76]);
            %uicontrol(app.Figure, 'Style', 'text', 'Position', [260 340 300 40], 'String', '𝓔𝓷𝓽𝓮𝓻  𝓽𝓱𝓮   𝓿𝓪𝓵𝓾𝓮𝓼  𝓯𝓸𝓻  (𝚡, 𝚢, 𝚣) :  ', 'FontSize', 13, 'Fontweight', 'bold', 'BackgroundColor',[0.6471 0.898 1], 'ForegroundColor', [0 0.4 0.8]);
            %uicontrol(app.Figure, 'Style', 'text', 'Position', [550 335 40 30], 'String', '🔜', 'FontSize', 20, 'Fontweight', 'bold', 'BackgroundColor',[0.6471 0.898 1]);
           
            


            uicontrol(app.Figure, 'Style', 'text', 'Position', [270 290 50 20], 'String', 'X:'); % x input
            app.XInput = uicontrol(app.Figure, 'Style', 'edit', 'Position', [320, 290, 200, 20], 'BackgroundColor', [0.8 0.8 0.8]);
          
            uicontrol(app.Figure, 'Style', 'text', 'Position', [270 260 50 20], 'String', 'Y:'); % y input
            app.YInput = uicontrol(app.Figure, 'Style', 'edit', 'Position', [320 260 200 20], 'BackgroundColor', [0.8 0.8 0.8]);
          
            uicontrol(app.Figure, 'Style', 'text', 'Position', [270 230 50 20], 'String', 'Z:'); % z input
            app.ZInput = uicontrol(app.Figure, 'Style', 'edit', 'Position', [320 230 200 20], 'BackgroundColor', [0.8 0.8 0.8]);
           
            app.DoneButton = uicontrol(app.Figure, 'Style', 'pushbutton', 'Position', [470 140 100 30], 'BackgroundColor', [1 0.5 0.7], 'String', '𝙳𝙾𝙽𝙴','FontSize', 14 , 'Fontweight','bold','Callback', @app.onDoneButtonClick);
        end
        
        function onDoneButtonClick(app,~,~)
            
            x = str2double(get(app.XInput,'String'));
            y = str2double(get(app.YInput,'String'));
            z = str2double(get(app.ZInput,'String'));
            
            if isnan(x)||isnan(y)||isnan(z)
                errordlg('Ops! Something went wrong. Please recheck your inputs.', 'Input Error');
                return;
            end
            
            app.plot3DVector(x, y, z);
        end
       

        function plot3DVector(~, x_coord, y_coord, z_coord)
           
            vector = [x_coord, y_coord, z_coord];
            magnitude = norm(vector);
            
            l = x_coord/magnitude;
            m = y_coord/magnitude;
            n = z_coord/magnitude;
            
            alpha = acosd(l);  % angle with X-axis
            beta = acosd(m);   % angle with Y-axis
            gamma = acosd(n);  % angle with Z-axis

             % cylindrical coordinates
            rho = sqrt(x_coord^2 + y_coord^2);
            phi = atan2d(y_coord, x_coord);  % Angle in degrees (use atan2d for full 360°)

            r = sqrt(x_coord^2 + y_coord^2 + z_coord^2);
            theta = atan2d(rho, z_coord);  % spherical theta
            phi_sph = atan2d(y_coord, x_coord);  % spherical phi
            
            
            octant_colors = [
                1 0 0;   % 1st octant - Red
                0 0 1;   % 2nd octant - Blue
                0 0.5 0.5; % 3rd octant - Teal
                1 1 0;   % 4th octant - Yellow
                1 0.5 0; % 5th octant - Orange
                0.5 0 0.5; % 6th octant - Purple
                0.5 0.75 1; % 7th octant - Sky Blue
                0 1 0;   % 8th octant - Green
            ];
            
            figure;
            hold on;
            axis equal;
            grid on;
            xlabel('X-axis');
            ylabel('Y-axis');
            zlabel('Z-axis');
            title('3D Cartesian Point with Angles α, β, γ');
            
            max_limit = max(abs([x_coord, y_coord, z_coord])) * 1.2;
            axis([-max_limit max_limit -max_limit max_limit -max_limit max_limit]);
            
            % Transparency for the octants
            alpha_value = 0.5;
            
            % Plot the octants (1st to 8th)
            fill3([0 max_limit max_limit 0], [0 0 max_limit max_limit], [max_limit max_limit max_limit max_limit], octant_colors(1, :), 'FaceAlpha', alpha_value);
            fill3([-max_limit 0 0 -max_limit], [0 0 max_limit max_limit], [max_limit max_limit max_limit max_limit], octant_colors(2, :), 'FaceAlpha', alpha_value);
            fill3([-max_limit 0 0 -max_limit], [-max_limit -max_limit 0 0], [max_limit max_limit max_limit max_limit], octant_colors(3, :), 'FaceAlpha', alpha_value);
            fill3([0 max_limit max_limit 0], [-max_limit -max_limit 0 0], [max_limit max_limit max_limit max_limit], octant_colors(4, :), 'FaceAlpha', alpha_value);
            fill3([0 max_limit max_limit 0], [0 0 max_limit max_limit], [-max_limit -max_limit -max_limit -max_limit], octant_colors(5, :), 'FaceAlpha', alpha_value);
            fill3([-max_limit 0 0 -max_limit], [0 0 max_limit max_limit], [-max_limit -max_limit -max_limit -max_limit], octant_colors(6, :), 'FaceAlpha', alpha_value);
            fill3([-max_limit 0 0 -max_limit], [-max_limit -max_limit 0 0], [-max_limit -max_limit -max_limit -max_limit], octant_colors(7, :), 'FaceAlpha', alpha_value);
            fill3([0 max_limit max_limit 0], [-max_limit -max_limit 0 0], [-max_limit -max_limit -max_limit -max_limit], octant_colors(8, :), 'FaceAlpha', alpha_value);
            
            % Label the octants
            text(max_limit/2, max_limit/2, max_limit, '1st', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(-max_limit/2, max_limit/2, max_limit, '2nd', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(-max_limit/2, -max_limit/2, max_limit, '3rd', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(max_limit/2, -max_limit/2, max_limit, '4th', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(max_limit/2, max_limit/2, -max_limit, '5th', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(-max_limit/2, max_limit/2, -max_limit, '6th', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(-max_limit/2, -max_limit/2, -max_limit, '7th', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            text(max_limit/2, -max_limit/2, -max_limit, '8th', 'Color', 'k', 'FontSize', 12, 'FontWeight', 'bold');
            
            % separating planes for octants
            fill3([0 0 0 0], [-max_limit max_limit max_limit -max_limit], [-max_limit -max_limit max_limit max_limit], [0.7 0.7 0.7], 'FaceAlpha', 0.5);
            fill3([-max_limit max_limit max_limit -max_limit], [0 0 0 0], [-max_limit -max_limit max_limit max_limit], [0.7 0.7 0.7], 'FaceAlpha', 0.5);
            fill3([-max_limit max_limit max_limit -max_limit], [-max_limit -max_limit max_limit max_limit], [0 0 0 0], [0.7 0.7 0.7], 'FaceAlpha', 0.5);
            
            % plot the vector
            quiver3(0, 0, 0, x_coord, y_coord, z_coord, 'k', 'LineWidth', 2, 'MaxHeadSize', 1);
            
            % Display the angles on the graph
            text(0, 0, 0, ['\alpha = ' num2str(alpha, '%.1f') '^\circ'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'Color', 'k');
            text(0, 0, 0, ['\beta = ' num2str(beta, '%.1f') '^\circ'], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'Color', 'k');
            text(0, 0, 0, ['\gamma = ' num2str(gamma, '%.1f') '^\circ'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 10, 'Color', 'k');

           % text for cylindrical and spherical coordinates beside the graph
            text(max_limit * 1.6, max_limit * 0.7, max_limit * 0.6, ['\rho = ' num2str(rho, '%.2f')], 'FontSize', 12, 'Color', 'b');
            text(max_limit * 1.6, max_limit * 0.7, max_limit * 0.5, ['\Phi = ' num2str(phi, '%.2f') '^\circ'], 'FontSize', 12, 'Color', 'b');
            text(max_limit * 1.6, max_limit * 0.7, max_limit * 0.4, ['z = ' num2str(z_coord, '%.2f')], 'FontSize', 12, 'Color', 'b');
           
            text(max_limit * 1.2, max_limit * 0.7, max_limit * 0.8, ['r = ' num2str(r, '%.2f')], 'FontSize', 12, 'Color', 'r');
            text(max_limit * 1.2, max_limit * 0.7, max_limit * 0.7, ['\theta = ' num2str(theta, '%.2f') '^\circ'], 'FontSize', 12, 'Color', 'r');
            text(max_limit * 1.2, max_limit * 0.7, max_limit * 0.6, ['\Phi = ' num2str(phi_sph, '%.2f') '^\circ'], 'FontSize', 12, 'Color', 'r');
            
            hold off;
        end
    end
end
