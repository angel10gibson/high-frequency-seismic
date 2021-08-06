% Adquisición con Micrófonos Bheringer ECM8000 y Arduino Due
clear all; close all; clc
%borrar previos
delete(instrfind({'Port'},{'COM7'})); % Programming Port
%crear objeto serie
s = serial('COM7','BaudRate',9600,'Terminator','CR/LF');
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%abrir puerto
fopen(s);

% Parámetros de adquisición
tmax=10; % tiempo de adquisición en segundos
rate=15; % frecuencia de muestreo
% preparar la figura
f = figure('Name','Captura');
a = axes('XLim',[0 tmax],'YLim',[-1000 1000]);
l1 = line(nan,nan,'Color','r','LineWidth',2);
l2 = line(nan,nan,'Color','b','LineWidth',2);

xlabel('Tiempo (s)')
ylabel('Voltaje (V)')
title('Captura de voltaje')
grid on
hold on

% inicializar
v1 = zeros(1,tmax*rate);
v2 = zeros(1,tmax*rate);
i = 1;
t = 0;

% ejecutar bucle cronometrado
tic
while t<tmax
    t = toc;
    % leer del puerto serie
    a = fscanf(s,'%d,%d')';
    v1(i)=a(1);  %*5/1024;
    v2(i)=a(2)*-1;  %*5/1024;
    % dibujar en la figura
    x = linspace(0,i/rate,i);
    set(l1,'YData',v1(1:i),'XData',x);
    set(l2,'YData',v2(1:i),'XData',x);
    drawnow
    % seguir
    i = i+1;
end
% resultado del cronómetro
clc;
fprintf('%g s de captura a %g cap/s \n',t,i/t);
