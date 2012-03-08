function mrowka2(action, arg1, arg2)
% MROWKA2 hjkgjiiiiiiiiiii
if nargin<1
   % set up a working figure window and store it in the userdata for
   % action 'setup' to use
   action='initialize';
end

global TabSwiat;
global TabSwiatStart;		% oryginalna niezmienna tablica TabSwiat
global TabKolor;
global rozmiar_planszy;
global posmrowki;
global chromosom;
global zwrot;
global pola_zajete;
global warunek_stop;
global populacja;
global prawd_mutacji;
global prawd_krzyzowania;
global max_los;
global kierunki;
global zwroty;
global TabKierunekAdd;

if strcmp(action,'initialize')
	posmrowki = [16 16];
   zwrot = 0;			% 0-do góry, 1-w prawo, 2-w dó³, 3-w lewo
   load 'TabSwiat.txt';
   TabSwiatStart = TabSwiat;
   rozmiar_planszy = size(TabSwiat);
   rozmiar_planszy = rozmiar_planszy(1);
   load 'TabKolor.txt';
   populacja = 10;
   chromosom = ones(populacja, 20) + round([rand(populacja, 10) .* 7, rand(populacja, 10) .* 9]);
   warunek_stop = 0;
   prawd_mutacji = 0.001;
   prawd_krzyzowania = 0.7;
   max_los = [7 * ones(1, 10) 9 * ones(1, 10)];
   for i = 0:3		%dla ka¿dego zwrotu
      kierunki(i+1, :) = ones(1,8) + rem(ones(1,8) * i + [0 3 1 0 2 0 0 0], 4);
      zwroty(i+1, :) = rem(ones(1,8) * i + [0 0 0 0 0 3 1 2], 4);
   end;
	TabKierunekAdd = [0 1; 1 0; 0 -1; -1 0];
   
   figNumber = figure('Color', [.88 .88 1], 'Menubar', 'none',...
      'Name', 'Œwiat mrówki', 'NumberTitle', 'off',...
      'Position', [20 20 700 530], 'Resize', 'off',...
      'Units', 'centimeters');
  
   % start 
   start_h = uicontrol('Callback', 'mrowka2 start',...
      'FontSize', 12, 'Units', 'points',...
      'Position', [445 338 65 30], 'String', 'Start',...
      'Style', 'pushbutton', 'Interruptible', 'yes');
  
   % help
   info_h = uicontrol('Callback', 'mrowka2 informacje',...
      'Fontsize', 12, 'Units', 'points', 'Position', [445 288 65 30],...
      'String', 'Informacje', 'Style', 'pushbutton');
  
   % close
   close_h = uicontrol('Callback', 'close(gcf)',...
      'Fontsize', 12, 'Units', 'points', 'Position', [445 188 65 30],...
      'String', 'Zamknij', 'Style', 'pushbutton');
 
   %stop
   stop_h = uicontrol('Callback', 'set(gca, ''Userdata'', -1)',...
      'Fontsize', 12, 'Units', 'points', 'Position', [445 238 65 30],...
      'String', 'Stop', 'Style', 'pushbutton');

   % krzy¿owanie
   krz_h = uicontrol('Fontsize', 12, 'Units', 'points',...
      'Position', [25 338 65 18], 'String', 'Krzy¿owanie',...
      'BackgroundColor', [.88 .88 1], 'Style', 'text');
   
	krzowa_h = uicontrol('Callback', 'close(gcf)', 'Fontsize', 12,...
   	'Units', 'points', 'Position', [25 321 65 18], 'Style', 'edit');
 
	% mutacja
   mut_h = uicontrol('Fontsize', 12, 'Units', 'points',...
      'Position', [25 282 65 18], 'String', 'Mutacja',...
      'BackgroundColor', [.88 .88 1], 'Style', 'text');
 
	mut_h = uicontrol('Callback', 'close(gcf)', 'Fontsize', 12,...
		'Units', 'points', 'Position', [25 265 65 18], 'Style', 'edit');
 
   % populacja
   pop_h = uicontrol('Fontsize', 12, 'Units', 'points',...
      'Position', [25 226 65 18], 'String', 'Populacja',...
      'BackgroundColor', [.88 .88 1], 'Style', 'text');
	pop_h2 = uicontrol('Fontsize', 12,...
      'Units', 'points', 'Position', [25 209 65 18], 'Style', 'edit',...
      'String', '20', 'Callback', 'eval(sprintf(''populacja = %s'', get(pop_h2, ''String'')))');

	redraw('wszystko');
    
elseif strcmp(action, 'start')
   do_krzyzowania = floor(populacja / 2) * 2;
   while ~warunek_stop
   	for k = 1:populacja
      	mrowka2('ruchy', k);
      	suma(k) = length(find(pola_zajete));
   	end;
      maksimum = find(suma == max(suma));
   	if max(suma) >= 800
      	warunek_stop = 1;
      else
         % selekcja
         suma_procentowa = suma ./ sum(suma);
         pula_rodzicielska = zeros(populacja, 20);
         for i = 1:populacja
            counter = find(cumsum(suma_procentowa) > rand(1));
            pula_rodzicielska(i, :) = chromosom(counter(1), :);
         end;
         clear [counter suma_procentowa];
         % krzy¿owanie z prawdopodobieñstwem 'prawd_krzyzowania'
         for i = 1:2:do_krzyzowania
            punkt_krzyzowania = 1 + round(rand(1) * 19);
            temp = pula_rodzicielska(i + 1, punkt_krzyzowania:20);
            pula_rodzicielska(i + 1, punkt_krzyzowania:20) = pula_rodzicielska(i, punkt_krzyzowania:20);
            pula_rodzicielska(i, punkt_krzyzowania:20) = temp;
         end;
         % mutacja z prawdopodobieñstwem 'prawd_mutacji'
         for i = 1:populacja
            for j = 1:20
               if rand(1) < prawd_mutacji
                  nowa_wartosc = 1 + round(rand(1) * max_los(j));
                  while nowa_wartosc == pula_rodzicielska(i, j)
                     nowa_wartosc = 1 + round(rand(1) * max_los(j));
                  end;
                  pula_rodzicielska(i, j) = nowa_wartosc;
               end;
            end;
         end;
         clear nowa_wartosc;
         % stworzenie nowej populacji
         chromosom = pula_rodzicielska;
         clear pula_rodzicielska;
      end;
		max(suma)
   end;
   
   max(suma)
%   suma(maksimum(1))
   mrowka2('ruchy', maksimum(1));
   redraw('wszystko');
   
elseif strcmp(action, 'informacje')
   helpwin(mfilename);

% ruch mrówki o chromosomie 'arg1' na planszy w 'arg2' ruchach
elseif strcmp(action, 'ruchy')
if nargin < 2
   arg1 = 1;
elseif nargin < 3
   arg2 = 1000;
end
	clear [pola_zajete TabSwiat];
	posmrowki = [1 1] * ((rozmiar_planszy + 1) / 2);
   zwrot = 0;			% 0-do góry, 1-w prawo, 2-w dó³, 3-w lewo
   TabSwiat = TabSwiatStart;
	pola_zajete = zeros(31);
   pola_zajete(posmrowki(2), posmrowki(1)) = 1;
   for i = 1:arg2
      oldpos = posmrowki;
      x = chromosom(arg1, TabSwiat(posmrowki(2), posmrowki(1)));
		kierunek = kierunki(zwrot+1, x);
		zwrot = zwroty(zwrot+1, x);
		posmrowki = [1 1] + rem(posmrowki + TabKierunekAdd(kierunek, :) - [1 1], rozmiar_planszy);
		posmrowki(find(posmrowki == 0)) = rozmiar_planszy;
      TabSwiat(oldpos(2), oldpos(1)) = chromosom(arg1, 10 + TabSwiat(oldpos(2), oldpos(1)));
	   pola_zajete(posmrowki(2), posmrowki(1)) = 1;
	end;
end;
