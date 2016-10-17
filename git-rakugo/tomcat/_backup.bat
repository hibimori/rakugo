SET DT=%date:~,10%
SET DT=%DT:/=%
SET TM=%time:~,8%
SET TM=%TM: =0%
SET TM=%TM::=%
SET DN=backup%DT%_%TM%

ECHO %DN%

CD %PT%
MKDIR %DN%

COPY *.css %DN%
COPY *.dat %DN%
COPY *.htm? %DN%
COPY *.js? %DN%
COPY *.txt %DN%
COPY *.x?? %DN%
