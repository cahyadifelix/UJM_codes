%%,OTDR

clear all;
close all;

%%,Import 1550 data
liste_fichier=dir('*Line01_1550*');
Date=liste_fichier.date;

[Nfichier,m]=size(liste_fichier);

%% Ranger les data dans un tableau colonne = t      % 1 mesure toutes les 100 mins
%% OBJ : calculer la longueur FO 
Data=[];
Increment=double(3.996806e-2); 

%% Creer une matric de valeurs
for ii=1:Nfichier
    ValInter=readmatrix(liste_fichier(ii).name);
    Data=[Data ValInter];
end

Lengthm=0:Increment:(length(Data)*Increment-Increment); % calcul de la Longueur de la FO

%% Afficher une figure pour les différentes zones d'analyse
figure
plot(Data(:,1))
xlabel('Data number')
ylabel('Reflected power [dB]')
%% Choix de la zone de fitting 

% Prendre large pour éviter les réflexions liées aux soudures
L=Lengthm(1070:1758); % ZoneInteret
% Fitting
LinearFit=[];

for j=1:1:Nfichier-1
P = polyfit(L,Data(1070:1758,j),1);
% yfit = polyval(P,L);
% plot(L,yfit,'r-.');
LinearFit(1,j)=P(1); % coeff a
end

%% figure dB/m en fonction du temps
Time =1:100:385*100;
figure
plot(Time,LinearFit(1,:))
title('Attenuation OTDR')
xlabel('Time (min)')
ylabel('Attenuation [dB/m]')
%% Calcul de RIA 
Dose=Time*833/60;
RIA=LinearFit(1,:)-LinearFit(1,8);%

figure
plot(Dose,-RIA)
title('Test OTDR')
xlabel('Dose (Gy)')
ylabel('RIA [dB/m]')

%%
% figure
% plot(L,Data(1070:1758,10))
% hold on 
% plot(L,Data(1070:1758,200))
% title('Test OTDR')
% xlabel('Length(m)')
% ylabel('Reflected Amplitude dB')

