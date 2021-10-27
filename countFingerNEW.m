 function [angles, distance, fingers] = countFingerNEW();
% demoted this file so it is not a function so that it shows all the
% variables
%% this part just declares and holds the variables we decide to go with

% totalArray first row is angle, second row is distance
% calls the function LiveData and takes out the diatance and angle
totalArray = LiveData();

% defining the wheel, and the confidence interval in which we still think
% it is the steering wheel
distanceWheel = 200;
distanceConfidence = 30;
distanceTop = distanceWheel + distanceConfidence;
distanceBot = distanceWheel - distanceConfidence;
% finger max and min width
fingerMin = 8;
fingerMax = 23;
% angle is the angle of which the the distance has to be within the range
% to be counted as valid, using tan thetha = o/a
angleMin = rad2deg(atan(fingerMin/distanceTop));
angleMax = rad2deg(atan(fingerMax/distanceBot));
maxAngle = 3;

%% filtering and keeping only the values within distanceTop and distanceBot
% only keeping the values in range
% initializing the starting values so that it is able to enter the loop
angles = 0;
distance = 0;
j = 1;

% checks the second column of totalArray (which is the distance,
% and takes out ONLY the distance that fits the distance criteria,
% and moves the values into angles and distance
for i = 1:length(totalArray)
    if ((totalArray(i,2) > distanceBot) && (totalArray(i,2) < distanceTop))
        angles(j) = totalArray(i,1);    % putting the angle values into angle
        distance(j) = totalArray(i,2);  % putting the dis values into distance
        j = j + 1;
    end
end

% plots all the data on a figure
figure(2)
polarplot(deg2rad(angles), distance, 'o');

%% processing and checking for number of fingers based on difference in angles of datapoints
% defines the variables used in determining the criteria
startAngle = angles(1);
fingers = 0;

for i = 2:length(angles)
    if (abs(angles(i-1) - angles(i)) > 1.5) % if angle diff less then 1.5, continue looping
        
        fprintf("finger that lasts with angle: " +   angles(i-1) + " angle is more than 3\n")
        % if angle is more than 3, and if it is within the finger size,
        % fingers plus 1, and start angle changes 
        if ( (abs(startAngle - angles(i-1)) > angleMin) && (abs(startAngle - angles(i-1)) < angleMax))
            fingers = fingers + 1;
        elseif (abs(startAngle - angles(i-1)) < angleMin)
            fprintf("finger too slim\n")
        elseif (abs(startAngle - angles(i-1)) > angleMax)
            fprintf("finger too fat\n")
        end
        startAngle = angles(i);
    elseif (i == length(angles))
        fprintf(angles(i) + " the last element\n")
        % if its the last element, and if it is within the finger size, fingers plus 1
        if ( (abs(startAngle - angles(i-1)) > angleMin) && (abs(startAngle - angles(i-1)) < angleMax))
            fingers = fingers + 1;
        elseif (abs(startAngle - angles(i-1)) < angleMin)
            fprintf("finger too slim\n")
        elseif (abs(startAngle - angles(i-1)) > angleMax)
            fprintf("finger too fat\n")
        end
    end
end
