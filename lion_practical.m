%4#测点 CEEMDAN-MPE处理
clear;
% fs=1e4;
% T=2;
% N=fs*T;
% t=0:1/fs:2-1/fs;
% y1=25e-2*cos(0.875*pi*50*t);
% y2=30e-2*sin(2*pi*50*t).*(1+1.5*sin(0.5*pi*40*t));
% y3=15e-2*exp(-15*t).*sin(200*pi*t);
% x=y1+y2+y3+0.2*randn(size(t));
fs=5120;
% t=0:1/fs:1.6-1/fs;
x=csvread('C:\Users\raoxiaokang\Desktop\235752-5.csv', 1, 1);
x=x(:,1);
x=x';%数据按行
N=length(x);
t=0:1/fs:N/fs-1/fs;
% hhtSpec(x',fs,1);xlabel('Time(s)');ylabel('Frequency(Hz)');title('');
% figure;
[modes its]=ceemdan(x,0.2,50,1500);
imf=modes;
cnt=length(imf(:,1));

for i=1:cnt
    mpe(i)=MPE(imf(i,:),6,1);
end
A=imf(4,:);
for i=5:cnt
    A=A+imf(i,:);
end
figure('Color','white');
subplot(211);plot(t,x);xlabel('Time(s)');ylabel('Amplitude(cm/s)')
subplot(212);plot(t,A);xlabel('Time(s)');ylabel('Amplitude(cm/s)')
% figure;hht(A,fs);xlabel('Time(s)');ylabel('Frequency(Hz)');title('');
% figure;hht(x,fs);xlabel('Time(s)');ylabel('Frequency(Hz)');title('original hht');

imf=kEMD(A);
% imf=emd(A);
cnt=length(imf(:,1));
f=(1:N-2)/N*(fs/2);
% for i=1:cnt-1
%         subplot(cnt-1,2,2*i-1);plot(t,imf(i,:)); ylabel(['IMF',num2str(i)]);
%         if(i==cnt-1)
%             xlabel('Time(s)');
%         end
%         bjp=base_marginal(imf(i,:),fs);%每一行是一个分量
%         subplot(cnt-1,2,2*i);plot(f,bjp); ylabel('Amp.');
%         if(i==cnt-1)
%             xlabel('Frequency(Hz)');
%         end
% end
%计算HHT时频谱和边际谱
figure('Color','white');
for i=1:cnt
    subplot(cnt,1,i);plot(t,imf(i,:)); ylabel(['IMF',num2str(i)]);
    set(gca,'yticklabel',get(gca,'ytick'));%不显示科学计数
    if(i<cnt)
            set(gca,'xtick',[]); %这两句话可以去掉x轴的刻度和坐标值。
    end
    if(i==cnt)
        xlabel('Time(s)');
        ylabel('R');
    end
end
figure('Color','white');

for i=1:cnt
    bjp=base_marginal(imf(i,:),fs);%每一行是一个分量
    subplot(cnt,1,i); plot(f,bjp);
    set(gca,'yticklabel',get(gca,'ytick'));%不显示科学计数
    if(i<cnt)
            set(gca,'xtick',[]); %这两句话可以去掉x轴的刻度和坐标值。
    end
    if(i==cnt)
        xlabel('Frequency(Hz)');
    end
    ylabel('Amp.');
end
%累加边际谱
% BB=base_marginal(imf(1,:),fs);
% for i=2:cnt
%     BB=BB+base_marginal(imf(i,:),fs);
% end
% figure('Color','white');plot(f,BB);xlabel('Frequency(Hz)');ylabel('Amplitude(cm/s)');title('add marginal');

% hhtSpec(A',fs,1);xlabel('Time(s)');ylabel('Frequency(Hz)');title('');
% marginalSpec(A,fs,1);xlabel('Frequency(Hz)');ylabel('Amplitude(cm/s)');title('');
% marginalSpec(imf(1,:),fs,1);title('边际谱imf1');%第一个参数：每行一个信号分量
% marginalSpec(imf(2,:),fs,1);title('边际谱imf2');
% marginalSpec(imf(3,:),fs,1);title('边际谱imf3');
B=base_marginal(imf,fs);
% B(length(B)-2000:length(B))=0;
figure('Color','white');plot(f,B);xlabel('Frequency(Hz)');ylabel('Amplitude(cm/s)');title('');

[insF,insP,insA]=InsFPA(A,fs);
figure('Color','white');plot(t,insA.^2);xlabel('Times(s)');ylabel('Instantaneous energy');title('');

% f_index50=find(f==50);
% f_index100=find(f==100);
% f_index200=find(f==200);
% f_index300=find(f==300);
% f_index400=find(f==400);
% f_index500=find(f==500);
% nb(1)=sum(BB(1:f_index50).^2);
% nb(2)=sum(BB(f_index50:f_index100).^2);
% nb(3)=sum(BB(f_index100:f_index200).^2);
% nb(4)=sum(BB(f_index200:f_index300).^2);
% nb(5)=sum(BB(f_index300:f_index400).^2);
% nb(6)=sum(BB(f_index400:f_index500).^2);
% for i=1:6
%     nb_p(i)=nb(i)/sum(nb);
% end
% figure('Color','white');plot((1:6),nb_p);xlabel('Frequency interval');ylabel('Energy ratio');