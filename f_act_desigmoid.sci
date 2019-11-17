function f=f_act_desigmoid(x)
    // Обратная функция активации Сигмоид
    // f(x)=-ln((1/y)-1)
    //x - входной массив
    //f - денормализованный массив
    
f = -log((1/x)-1);

f = f';
endfunction
