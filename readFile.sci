function N=readFile(filePath)
    //Функция читает данные из файла
    //filePath - путь к файлу
    //N - выходной массив с данными файла
    
mode = 'r';
f=mopen(file, mode);
N=mfscanf(-1, f,'%g');
mclose(f);

endfunction
