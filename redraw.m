function redraw(action)

global rozmiar_planszy;
global TabSwiat;
global TabKolor;
global posmrowki_x;
global posmrowki_y;
global zwrot;

if nargin < 1
  action = 'niewszystko';
end

cla reset;
axis([0 rozmiar_planszy 0 rozmiar_planszy]);
axis('equal')
axis('off')
     
if strcmp(action, 'wszystko')
   xmin = 0;
   xmax = rozmiar_planszy-1;
   ymin = 0;
   ymax = rozmiar_planszy-1;
else
   xmin = posmrowki_x - 1;
   xmax = posmrowki_x + 1;
   ymin = posmrowki_y - 1;
   ymax = posmrowki_y + 1;   
end;

for i = ymin:1:ymax
   for j = xmin:1:xmax
      patch([j, j, j+1, j+1], [i, i+1, i+1, i],...
         [TabKolor(TabSwiat(rozmiar_planszy-i, 1+j), 1),...
         	TabKolor(TabSwiat(rozmiar_planszy-i, 1+j), 2),...
         	TabKolor(TabSwiat(rozmiar_planszy-i, 1+j), 3)]);
   end;
end;

pmx = posmrowki_x;
pmy = posmrowki_y;
if zwrot == 0		% zwrot w góre
   patch(...
      [pmx-0.5, pmx-0.5,  pmx-0.8, pmx-0.2, pmx-0.5 ],...
      [pmy-0.8, pmy-0.15, pmy-0.6, pmy-0.6, pmy-0.15],...
      [.2, .9, 1], 'LineWidth', 1);
elseif zwrot == 1	% zwrot w prawo
   patch(...
      [pmx-0.8, pmx-0.15, pmx-0.6, pmx-0.6, pmx-0.15],...
      [pmy-0.5, pmy-0.5,  pmy-0.8, pmy-0.2, pmy-0.5 ],...
      [.2, .9, 1], 'LineWidth', 1);
elseif zwrot == 2	% zwrot w dó³
   patch(...
      [pmx-0.5,  pmx-0.5, pmx-0.8, pmx-0.2, pmx-0.5],...
      [pmy-0.15, pmy-0.8, pmy-0.4, pmy-0.4, pmy-0.8],...
      [.2, .9, 1], 'LineWidth', 1);
elseif zwrot == 3	% zwrot w lewo
   patch(...
      [pmx-0.15, pmx-0.8, pmx-0.4, pmx-0.4, pmx-0.8],...
      [pmy-0.5,  pmy-0.5, pmy-0.8, pmy-0.2, pmy-0.5],...
      [.2, .9, 1], 'LineWidth', 1);
end;