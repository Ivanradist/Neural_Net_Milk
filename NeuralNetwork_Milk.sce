//Neural Network determines the parameters of milk
// on the basis of infrared spectroscopy 
clc;
PTH='D:\zProjects\2019_Neural_Milk\';

dirFiles='Data\';
exec(PTH + 'readFile.sci');
exec(PTH + 'normir.sci');
exec(PTH + 'f_act_sigmoid.sci');
exec(PTH + 'f_act_gtangens.sci');
exec(PTH + 'f_act_desigmoid.sci');
exec(PTH + 'f_act_degtangens.sci');

disp('Reading files...');
file = PTH + dirFiles + 's1.txt';
s1 = readFile(file)';
file = PTH + dirFiles + 's2.txt';
s2 = readFile(file)';
file = PTH + dirFiles + 's3.txt';
s3 = readFile(file)';
file = PTH + dirFiles + 's4.txt';
s4 = readFile(file)';
file = PTH + dirFiles + 'y1_fat.txt';
y1 = readFile(file)';
file = PTH + dirFiles + 'y2_protein.txt';
y2 = readFile(file)';
file = PTH + dirFiles + 'y3_COMO.txt';
y3 = readFile(file)';
file = PTH + dirFiles + 'y4_density.txt';
y4 = readFile(file)';
disp('Program read files successfully.');

listFAct  = list('Функция активации',1,['Линейная','Сигмоида','Гиперболический тангенс']);
listNormir  = list('Применить нормирование перед активацией',1,['Да','Нет']);
rep = x_choices('Toggle Menu',list(listFAct,listNormir));
if sum(size(rep))~=0 then
    f_act=rep(1);
    hasNormir=rep(2);
else
    return; //Пользователь нажал отмену
end

//Список меню начальных установок
txt_1 = ['Разброс выходных данных в % ';...
'Граница разделения данных на обучение и тест '];
    
//Список значений (по умолчанию) начальных установок
txt_2 = ['5';...
'30'];
//Окно меню начальных установок  
sig = x_mdialog('Начальные установки параметров обработки',txt_1,txt_2);
if sum(size(sig))~=0 then
    //Чтение введенных в меню начальных установок
    interval=evstr(sig(1));
    b=evstr(sig(2));
else
    return; //Пользователь нажал отмену
end

//Выходные данные представляем в виде интервала
// n - нижний порог, v - верхний порог
// Точность в %
y1n = y1 - (max(y1)*interval)/(2*100);
y1v = y1 + (max(y1)*interval)/(2*100);
y2n = y2 - (max(y2)*interval)/(2*100);
y2v = y2 + (max(y2)*interval)/(2*100);
y3n = y3 - (max(y3)*interval)/(2*100);
y3v = y3 + (max(y3)*interval)/(2*100);
y4n = y4 - (max(y4)*interval)/(2*100);
y4v = y4 + (max(y4)*interval)/(2*100);

//Нормирование данных
if hasNormir == 1 then
    disp('Data normir.');
    s1 = normir(s1);
    s2 = normir(s2);
    s3 = normir(s3);
    s4 = normir(s4);
    y1n = normir(y1n);
    y1v = normir(y1v);
    y2n = normir(y2n);
    y2v = normir(y2v);
    y3n = normir(y3n);
    y3v = normir(y3v);
    y4n = normir(y4n);
    y4v = normir(y4v);
end

//Нормализация входных данных
// Функции активации
if (f_act == 1) then
    // 1. Линейная. Достаточно только нормирования
elseif (f_act == 2) then
    // 2. Сигмоид
    s1 = f_act_sigmoid(s1);
    s2 = f_act_sigmoid(s2);
    s3 = f_act_sigmoid(s3);
    s4 = f_act_sigmoid(s4);
    y1n = f_act_sigmoid(y1n);
    y1v = f_act_sigmoid(y1v);
    y3n = f_act_sigmoid(y3n);
    y3v = f_act_sigmoid(y3v);
    y4n = f_act_sigmoid(y4n);
    y4v = f_act_sigmoid(y4v);
elseif (f_act == 3) then
    // 3. Гиперболический тангенс
    s1 = f_act_gtangens(s1);
    s2 = f_act_gtangens(s2);
    s3 = f_act_gtangens(s3);
    s4 = f_act_gtangens(s4);
    y1n = f_act_gtangens(y1n);
    y1v = f_act_gtangens(y1v);
    y3n = f_act_gtangens(y3n);
    y3v = f_act_gtangens(y3v);
    y4n = f_act_gtangens(y4n);
    y4v = f_act_gtangens(y4v);
end

// Разделение данных на данные для обучения ИНС и данные для проверки ИНС
s1_u = s1(1,1:b); 
s2_u = s2(1,1:b);  
s3_u = s3(1,1:b); 
s4_u = s4(1,1:b); 
y1n_u = y1n(1,1:b); 
y1v_u = y1v(1,1:b);  
y2n_u = y2n(1,1:b); 
y2v_u = y2v(1,1:b);  
y3n_u = y3n(1,1:b); 
y3v_u = y3v(1,1:b);  
y4n_u = y4n(1,1:b); 
y4v_u = y4v(1,1:b); 
//---------------
s1_t = s1(1,b:36); 
s2_t = s2(1,b:36); 
s3_t = s3(1,b:36); 
s4_t = s4(1,b:36); 
y1n_t = y1n(1,b:36); 
y1v_t = y1v(1,b:36); 
y2n_t = y2n(1,b:36); 
y2v_t = y2v(1,b:36); 
y3n_t = y3n(1,b:36); 
y3v_t = y3v(1,b:36); 
y4n_t = y4n(1,b:36); 
y4v_t = y4v(1,b:36); 
//---------------

//------------
//Обучение ИНС
//------------
//clear W;
//входные параметры
FINteach = [s1_u;s2_u;s3_u;s4_u];
//целевые параметры 
FOUTteach = [y1n_u;y1v_u;y2n_u;y2v_u;y3n_u;y3v_u;y4n_u;y4v_u];
//число нейронов в каждом слое, включая входной  и  выходной  слой
numNeurons = [4 8 8];
//активация  функции  от  1-го скрытого  слоя  к выходному слою
// 'ann_purelin_activ' - Линейная
// 'ann_log_activ' - logistic activation function (Сигмоид)
// 'ann_compet_activ' - Competitive Activation Functio
// 'ann_hardlim_activ' - Hardlimit activation function
// 'ann_logsig_activ' - Logistic Sigmoid activation function (Сигмоид)
// 'ann_d_tansig_activ' - Derivative of Tangent Sigmoid activation function
// 'ann_tansig_activ' - Tangent Sigmoid activation funct (Гиперболический тангенс)
// 'ann_d_logsig_activ' - Derivative of Logistic activation function
// 'ann_d_purelin_activ' - Derivative of Linear activation function (=1)

af = ['ann_log_activ','ann_purelin_activ'];

// это скорость обучения
lr = 0.2;
//максимальное эпоха для тренировок
itermax = 1000;
//минимальная ошибка (задача)
mse_min = 0.0001;
//минимальный градиент  для  подготовки  к  остановке
gd_min = 0.0001;
W = ann_FFBP_gd(FINteach,FOUTteach,numNeurons);
//W = ann_FFBP_gd(FINteach,FOUTteach,numNeurons,af,lr,itermax,mse_min,gd_min);
//------------
//Тест ИНС
//------------
FINtest = [s1_t;s2_t;s3_t;s4_t];
y = ann_FFBP_run(FINtest,W); // Использование ИНС
//y = ann_FFBP_run(FINtest,W,af); // Использование ИНС. Расширенная функция

//------------
//Обработка результата
//------------
y1n_rez = y(1,:);
y1v_rez = y(2,:);
y2n_rez = y(3,:);
y2v_rez = y(4,:);
y3n_rez = y(5,:);
y3v_rez = y(6,:);
y4n_rez = y(7,:);
y4v_rez = y(8,:);

if (f_act == 1) then
    // 1. Денормализация. Линейная. Достаточно только нормирования
elseif (f_act == 2) then
    // 2. Денормализация. Сигмоид
    y1n_rez = f_act_desigmoid(y1n_rez);
    y1v_rez = f_act_desigmoid(y1v_rez);
    y3n_rez = f_act_desigmoid(y3n_rez);
    y3v_rez = f_act_desigmoid(y3v_rez);
    y4n_rez = f_act_desigmoid(y4n_rez);
    y4v_rez = f_act_desigmoid(y4v_rez);
elseif (f_act == 3) then
    // 3. Денормализация. Гиперболический тангенс
    y1n_rez = f_act_degtangens(y1n_rez);
    y1v_rez = f_act_degtangens(y1v_rez);
    y3n_rez = f_act_degtangens(y3n_rez);
    y3v_rez = f_act_degtangens(y3v_rez);
    y4n_rez = f_act_degtangens(y4n_rez);
    y4v_rez = f_act_degtangens(y4v_rez);
end
//Денормирование
if hasNormir == 1 then
    y1n_rez = y1n_rez*max(y1n);
    y1v_rez = y1v_rez*max(y1v);
    y2n_rez = y2n_rez*max(y2n);
    y2v_rez = y2v_rez*max(y2v);
    y3n_rez = y3n_rez*max(y3n);
    y3v_rez = y3v_rez*max(y3v);
    y4n_rez = y4n_rez*max(y4n);
    y4v_rez = y4v_rez*max(y4v);
end

//------------
//Подбор коэффициентов коррекции
//------------
y_cor = ann_FFBP_run(FINteach,W); // Использование ИНС. Расширенная функция

//------------
//Обработка результата
//------------
y1n_cor = y_cor(1,:);
y1v_cor = y_cor(2,:);
y2n_cor = y_cor(3,:);
y2v_cor = y_cor(4,:);
y3n_cor = y_cor(5,:);
y3v_cor = y_cor(6,:);
y4n_cor = y_cor(7,:);
y4v_cor = y_cor(8,:);

if (f_act == 1) then
    // 1. Денормализация. Линейная. Достаточно только нормирования
elseif (f_act == 2) then
    // 2. Денормализация. Сигмоид
    y1n_cor = f_act_desigmoid(y1n_cor);
    y1v_cor = f_act_desigmoid(y1v_cor);
    y3n_cor = f_act_desigmoid(y3n_cor);
    y3v_cor = f_act_desigmoid(y3v_cor);
    y4n_cor = f_act_desigmoid(y4n_cor);
    y4v_cor = f_act_desigmoid(y4v_cor);
elseif (f_act == 3) then
    // 3. Денормализация. Гиперболический тангенс
    y1n_cor = f_act_degtangens(y1n_cor);
    y1v_cor = f_act_degtangens(y1v_cor);
    y3n_cor = f_act_degtangens(y3n_cor);
    y3v_cor = f_act_degtangens(y3v_cor);
    y4n_cor = f_act_degtangens(y4n_cor);
    y4v_cor = f_act_degtangens(y4v_cor);
end
//Денормирование
if hasNormir == 1 then
    y1n_cor = y1n_cor*max(y1n);
    y1v_cor = y1v_cor*max(y1v);
    y2n_cor = y2n_cor*max(y2n);
    y2v_cor = y2v_cor*max(y2v);
    y3n_cor = y3n_cor*max(y3n);
    y3v_cor = y3v_cor*max(y3v);
    y4n_cor = y4n_cor*max(y4n);
    y4v_cor = y4v_cor*max(y4v);
end

y1cor = ((y1n_cor+y1v_cor)/2)';
y2cor = ((y2n_cor+y2v_cor)/2)';
y3cor = ((y3n_cor+y3v_cor)/2)';
y4cor = ((y4n_cor+y4v_cor)/2)';

// Подбор коэффициентов коррекции
cor1 = mean(y1)/mean(y1n_cor);
cor2 = mean(y2)/mean(y2n_cor);
cor3 = mean(y3)/mean(y3n_cor);
cor4 = mean(y4)/mean(y4n_cor);

disp('---------------Ошибка результата------------------');
y1rez = (cor1*(y1n_rez+y1v_rez)/2)';
y2rez = (cor2*(y2n_rez+y2v_rez)/2)';
y3rez = (cor3*(y3n_rez+y3v_rez)/2)';
y4rez = (cor4*(y4n_rez+y4v_rez)/2)';

y1_t = y1(1,b:36)'; 
y2_t = y2(1,b:36)';
y3_t = y3(1,b:36)';
y4_t = y4(1,b:36)';

//------------------------------------------
//Подбор коэффициентов коррекции. Шаг №2
//-------------------------------------------
const1 = y1rez(1,1)-y1_t(1,1);
const2 = y2rez(1,1)-y2_t(1,1);
const3 = y3rez(1,1)-y3_t(1,1);
const4 = y4rez(1,1)-y4_t(1,1);

y1rez = y1rez-const1;
y2rez = y2rez-const2;
y3rez = y3rez-const3;
y4rez = y4rez-const4;
//-------------------------------------------

y1mis=y1rez-y1_t;
//y1mispercent=(y1mis*100)/max(y1_t);
y1mispercent = [(y1mis(1,1)*100)/y1_t(1,1)]
for i = 2:size(y1mis,1)
    y1mispercent = [y1mispercent;(y1mis(i,1)*100)/y1_t(i,1)]
end
tbly1 = [y1_t,y1rez,y1mis,y1mispercent];
disp('y1');
disp('Ожидаемое|Рассчитанное|Ошибка |Ошибка %');
disp(tbly1(2:size(tbly1,1),:));
//--------------------------
y2mis=y2rez-y2_t;
//y2mispercent=(y2mis*100)/max(y2_t);
y2mispercent = [(y2mis(1,1)*100)/y2_t(1,1)]
for i = 2:size(y2mis,1)
    y2mispercent = [y2mispercent;(y2mis(i,1)*100)/y2_t(i,1)]
end
tbly2 = [y2_t,y2rez,y2mis,y2mispercent];
disp('y2');
disp('Ожидаемое|Рассчитанное|Ошибка |Ошибка %');
disp(tbly2(2:size(tbly2,1),:));
//---------------------------
y3mis=y3rez-y3_t;
//y3mispercent=(y3mis*100)/max(y3_t);
y3mispercent = [(y3mis(1,1)*100)/y3_t(1,1)]
for i = 2:size(y3mis,1)
    y3mispercent = [y3mispercent;(y3mis(i,1)*100)/y3_t(i,1)]
end
tbly3 = [y3_t,y3rez,y3mis,y3mispercent];
disp('y3');
disp('Ожидаемое|Рассчитанное|Ошибка |Ошибка %');
disp(tbly3(2:size(tbly3,1),:));
//----------------------------
y4mis=y4rez-y4_t;
//y4mispercent=(y4mis*100)/max(y4_t);
y4mispercent = [(y4mis(1,1)*100)/y4_t(1,1)]
for i = 2:size(y4mis,1)
    y4mispercent = [y4mispercent;(y4mis(i,1)*100)/y4_t(i,1)]
end
tbly4 = [y4_t,y4rez,y4mis,y4mispercent];
disp('y4');
disp('Ожидаемое|Рассчитанное|Ошибка |Ошибка %');
disp(tbly4(2:size(tbly4,1),:));
