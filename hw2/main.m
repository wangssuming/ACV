focalpath = {'18mm'; '53mm'; '135mm'};
obj = {'600mm'; '1200mm'; '1800mm'};
shi = {'0mm'; '1mm'; '5mm'; '10mm'; '20mm'};
objmm = [600, 1200, 1800];
shimm = [0, 1, 5, 10, 20];
focalmm = [18, 53, 135];
Allrange = {[5 45]; [3 45]; [5 45]};

AllinterstArea(:,:,1) = [1250 1530 2000 2650; 1400 1550 2200 2500; 1400 1535 2250 2450];
AllinterstArea(:,:,2) = [1820 2030 2180 2550; 1700 1900 2350 2550; 1390 1460 2350 2500];
AllinterstArea(:,:,3) = [1850 2300 2050 2680; 1750 2050 2380 2800; 1280 1450 2200 2500];

count = 1;
for f = 1:3
    interstArea = AllinterstArea(:,:,f);
    focal = focalmm(f);
    Focal = sprintf('%s_%d','Focal',focal);
    range = Allrange{f,1};
    
    img = [];
    imgbound = [];
    for i = 1:3
        for j = 1:5
            temp = rgb2gray(imread(['Photo/' focalpath{f} '/' obj{i} '_' shi{j} '.jpg']));
            img{i,j} = temp;
            imgbound{i,j} = temp(interstArea(i,1):interstArea(i,2), interstArea(i,3):interstArea(i,4));
        end
    end

    allcenter = [];
    allradius = [];
    allmetric = [];
    if f == 1
        for i = 1:3
            for j = 1:5
                [centers, radii, metric] = imfindcircles(imgbound{i,j},range);
                centersStrong5 = centers(1,:); 
                radiiStrong5 = radii(1,:);
                metricStrong5 = metric(1,:);
                allcenter{i,j} = centersStrong5;
                allradius{i,j} = radiiStrong5;
                allmetric{i,j} = metricStrong5;
                figure(count)
                imshow(imgbound{i,j})
                viscircles(centersStrong5, radiiStrong5,'EdgeColor','b')
                count = count + 1;
            end
        end
    else
        for i = 1:3
            for j = 1:5
                [centers, radii, metric] = imfindcircles(imgbound{i,j},range);
                centersStrong5 = centers(1:5,:); 
                radiiStrong5 = radii(1:5,:);
                metricStrong5 = metric(1:5,:);
                allcenter{i,j} = centersStrong5;
                allradius{i,j} = radiiStrong5;
                allmetric{i,j} = metricStrong5;
                figure(count)
                imshow(imgbound{i,j})
                viscircles(centersStrong5, radiiStrong5,'EdgeColor','b')
                count = count + 1;
            end
        end
    end

    move = [];
    moveavg_X = [];
    moveavg_Y = [];
    for i = 1:3
        for j = 1:4
            move{i,j} = abs(allcenter{i,j+1} - allcenter{i,1});
            if f == 1
                avg = abs(allcenter{i,j+1} - allcenter{i,1});
            else
                avg = mean(abs(allcenter{i,j+1} - allcenter{i,1}));
            end
            moveavg_X(i,j) = avg(1,1);
            moveavg_Y(i,j) = avg(1,2);
        end
    end
    
    mm_pixel = [];
    for i = 1:3
        mm_pixel(i,:) = shimm(1,2:5) ./ moveavg_X(i,:);
    end

    FOV_measure = [];
    for i = 1:3
        FOV_measure(i,:) = 2*atan(size(img{1,1},2).*mm_pixel(i,:)./(2*objmm(i)))*180/pi;
    end

    FOV_theory = 2*atan(23.4/2/focal)*180/pi;
    
    All_data.(Focal).pixel = moveavg_X;
    All_data.(Focal).mmpixel = mm_pixel;
    All_data.(Focal).FOV.measure = FOV_measure;
    All_data.(Focal).FOV.theory = FOV_theory;
end

save('r07945029_hw2_data','All_data','-v7.3')


