function seriesSmoothed1=smoothPartially2(seriesOrginal)

% level2=[1,65,155,384,476];%476 level1
% level2=[1,65,155,256,384,476];%livello2
% level2=[1,65,127,155,190,256,384,476];%level6
  
   seriesSmoothed1=[];
for i=1:6
    

    
    yfilt1=potionSmooth(seriesOrginal,i*6);
%     diff=level2(i+1)-level2(i);
    

    seriesSmoothed1=cat(1,seriesSmoothed1,yfilt1);
    size(seriesSmoothed1)

end


%  yfilt2=potionSmooth([seriesOrginal(25:end),seriesOrginal(25:end)]);
%  
% 
% %   yfilt3=[seriesOrginal(1:25),yfilt2(25:476)];
% 
%     plot(seriesSmoothed1,'b','LineWidth',7)
%     hold on;
%     plot(seriesOrginal,'g','LineWidth',2)
%      set(gca, 'YTick', [])
%     hold off;
% %      set(gca, 'YTick', [])
%      
%      
% % end
    
    
function yfilt=potionSmooth(portion,smooth)



% G = fspecial('gaussian',[1 round(length(portion/4))],3);
% %# Filter it
% yfilt = imfilter(portion,G,'same');

sigma = smooth;%35;level1 15 level2 5 level6
% size = length(portion/2);%level1
size= 3*smooth%round(length(portion)/());%level2
% size= 5;%level2

x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize

% yfilt = filter (gaussFilter,1, y);

yfilt = conv (portion, gaussFilter, 'same');




