
img1 = im2double(imread('trucka.bmp'));
img2 = im2double(imread('truckb.bmp'));
blockall = [8,11,15,21,31];
range = 50;

for time = 1:length(blockall)
    block = blockall(time);
    img2_position = [];
    img2_block = [];
    count1 = 1;
    for i = 1:block:size(img2,2)-block+1
        for j = 1:block:size(img2,1)-block+1
            img2_position{count1,1} = [i,j];
            img2_block{count1,1} = img2(i:i+block-1,j:j+block-1);
            count1 = count1 + 1;
        end
    end

    img1_position = [];
    img1_block = [];
    count1 = 1;
    for i = 1:size(img1,1)-block+1
        for j = 1:size(img1,2)-block+1
            img1_position{count1,1} = [i,j];
            img1_block{count1,1} = img1(i:i+block-1,j:j+block-1);
            count1 = count1 + 1;
        end
    end

    motion_vector = [];
    count = 0;
    for i = 1:length(img2_block)
        for j = 1:length(img1_block)
            count = count + 1;
            if j == 1
                record_minvalue = sum(abs(img1_block{j,1}-img2_block{i,1}),'all');
                record_position = img1_position{j,1};    
    %             disp(count)
            end
            if norm(img2_position{i,1} - img1_position{j,1}) <= range...
                && sum(abs(img1_block{j,1}-img2_block{i,1}),'all') <= record_minvalue
                record_minvalue = sum(abs(img1_block{j,1}-img2_block{i,1}),'all');
                record_position = img1_position{j,1};
    %             disp(count)
            end
        end
        motion_vector{i,1} = record_position-img2_position{i,1};
    end

    figure(time)
    x = cellfun(@(v)v(1),img2_position);
    y = cellfun(@(v)v(2),img2_position);
    u = cellfun(@(v)v(1),motion_vector);
    v = cellfun(@(v)v(2),motion_vector);
    quiver(-x, y, -u, v)
end





