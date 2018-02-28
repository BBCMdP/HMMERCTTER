function [File_tree_new]=fn_dendroscope_midpoint(Folder_Out,File_tree)


File_Script='scriptMidPointTree';
File_tree_new=[Folder_Out '/MidPoint_Tree'];

Text = {};
Posi = 0;
Posi = Posi + 1; Text{Posi} = '#!/bin/csh';
Posi = Posi + 1; Text{Posi} = 'Dendroscope -g -E <<END';
Posi = Posi + 1; Text{Posi} = ['open file=''' File_tree ''''];
Posi = Posi + 1; Text{Posi} = 'midpointroot';

Posi = Posi + 1; Text{Posi} = ['save format=newick file=''' File_tree_new '''']; 
Posi = Posi + 1;Text{Posi} = 'quit';
Posi = Posi + 1;Text{Posi} = 'END';

lib_savetext([Folder_Out '/' File_Script],Text);
    
fn_run_tcsh(Folder_Out,File_Script);