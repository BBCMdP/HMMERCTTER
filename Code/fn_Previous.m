function fn_Previous(File_temp,File_group)
   

%a=lib_loadtext(File_temp);
File = File_temp;
%%%%
fFileName = fopen(File);
if isempty(fFileName)
   error(['Can not open ' File ' for reading']);
end
Text = textscan(fFileName,'%s','delimiter','\n','whitespace','', 'BufSize', 20000);
fclose(fFileName);
Text = Text{1};
%%%%%
a=Text;


if isempty(a)
    errordlg('Previous Button not run');
    pause(2); close;
else
[f1,c1]=size(a);
b=a(1:f1-1,:);

lib_savetext(File_temp,b);

if (f1-1 < 1)
    errordlg('Previous Button not run');
    pause(2); close;
else
    c=b{f1-1,:};
    [f1,c1]=size(c);

    File_group=fopen(File_group,'w');

     for i=1:c1
        if i==1
        [aux,remain]=strtok(c);
        else
            [aux,remain]=strtok(remain);
        end
        if ~isempty(aux)
        fprintf(File_group, aux);
        fprintf(File_group,'\n');
        end
     end
     fclose all;
end
end