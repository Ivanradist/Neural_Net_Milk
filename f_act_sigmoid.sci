function f=f_act_sigmoid(x)
    // Функция активации Сигмоид
    // f(x)=1/(1+e^-x)
    //x - входной массив
    //f - нормализованный массив
    
f = 1/(1+%e^(-x));
f = f';
endfunction
