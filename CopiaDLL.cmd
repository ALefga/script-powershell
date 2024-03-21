query session >.\session.txt  
for /f "skip=1 tokens=3," %%i in (.\session.txt) DO logoff %%i  
del session.txt 


ROBOCOPY e:\tlmp11\dll \\vm-co02\c$\tlmp11\dll *.* /COPY:DT /MIR /IT /NP /NFL /R:10 /W:1 /UNILOG+:G:\CopiaGO!Manage\CopiaDLL_LOG1.txt
ROBOCOPY e:\tlmp11\dll \\vm-co03\c$\tlmp11\dll *.* /COPY:DT /MIR /IT /NP /NFL /R:10 /W:1 /UNILOG+:G:\CopiaGO!Manage\CopiaDLL_LOG2.txt