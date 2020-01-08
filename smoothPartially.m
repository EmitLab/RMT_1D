function seriesSmoothed1=smoothPartially(seriesOrginal)

level2=[1,65,155,384,476];%476 level1
% level2=[1,65,155,256,384,476];%livello2
% level2=[1,65,127,155,190,256,384,476];%level6
  
   
% for j=1:
yfil=potionSmooth([seriesOrginal(25:65),seriesOrginal(25:65)],seriesOrginal);

  seriesSmoothed1=[seriesOrginal(1:25),yfil(26:65)];%
  
%   
%   plot(yfil)
%   ffff
  
for i=2:length(level2)-1
    
    if i==length(level2)-1
        portion=[seriesOrginal(level2(i)-39:level2(i+1)),seriesOrginal(level2(i)-39:level2(i+1))];
        diff=level2(i+1)-level2(i)+44;%
        startdiff=45;
%         seriesSmoothed1(end)
        else
        portion=seriesOrginal(level2(i)-40:level2(i+1)+40);
         startdiff=40;%
        diff=level2(i+1)-level2(i)+startdiff-1;
       
    end
    
    yfilt1=potionSmooth(portion,seriesOrginal);
%     diff=level2(i+1)-level2(i);
    

    seriesSmoothed1=cat(2,seriesSmoothed1,yfilt1(startdiff:diff));
    size(seriesSmoothed1)
%     if i==2
%         yfilt1
%         yfilt1(1:diff)
%         portion
%         kkkk
%     end
end

%     chk=find(seriesSmoothed1<min(seriesOrginal))
%     if sum(chk)
%         seriesSmoothed1(chk)=seriesOrginal(chk)
%     end
% seriesSmoothed1=seriesSmoothed1(1:length(seriesOrginal));
    % size(seriesSmoothed1(469:end))
    % size(seriesOrginal(469:end)')
% seriesSmoothed1(469:end)=seriesOrginal(469:end);

 yfilt2=potionSmooth([seriesOrginal(25:end),seriesOrginal(25:end)]);
 

%   yfilt3=[seriesOrginal(1:25),yfilt2(25:476)];

    plot(seriesSmoothed1,'b','LineWidth',7)
    hold on;
    plot(seriesOrginal,'g','LineWidth',2)
     set(gca, 'YTick', [])
    hold off;
%      set(gca, 'YTick', [])
     
     
% end
    
    
function yfilt=potionSmooth(portion,part)



% G = fspecial('gaussian',[1 round(length(portion/4))],3);
% %# Filter it
% yfilt = imfilter(portion,G,'same');

sigma = 25;%35;level1 15 level2 5 level6
% size = length(portion/2);%level1
size= length(portion/4);%level2
% size= 5;%level2

x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize

% yfilt = filter (gaussFilter,1, y);

yfilt = conv (portion, gaussFilter, 'same');




