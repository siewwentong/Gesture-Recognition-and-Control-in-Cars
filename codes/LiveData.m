function totalArray = LiveData()

% this function file captures live data form the sensor.
% this is done by 

% specify the serial port that the thing is connected to, check with serial
% port monitor 
s = serial('COM5');
set(s,'BaudRate',115200);
fopen(s);

% this specifies how much data to take in, we tested it and 2k data points
% was enough
% note that this data is the RAW data of the sensor, meaning it is the
% distance, angle, and 
i = 1;
myArray = strings(2000,1);
while ( i < 2000)
myArray(i) = fscanf(s);
i = i + 1;
end

index = find(contains(myArray,'new'));
if (index ~= NaN)
distance = myArray([index+3 :6: 2000]);
angle = myArray([index+4 :6: 2000]);
% startBit = myArray([index+4 :6: 2000]);
end

if (length(distance) ~= length(angle))
    if (length(distance) > length(angle))
        distance(end)=[];
    else 
        angle(end)=[];
    end
end
numAngle = double(angle);
numDistance = double(distance);
numAngleRad = deg2rad(numAngle);

%% uncomment to see plots
figure(1);
polarplot(numAngleRad, numDistance, 'o');
% rlim([0 300]);
% 
% x = 1:length(numAngle);
% figure;
% plot(x, numAngle)

%% uses sortAngle2 to sort the angles 
totalArray = [numAngle'; numDistance']';
totalArray = sortrows(totalArray, 1);

fclose(s);


end