@echo off
FOR /F "tokens=* USEBACKQ" %%F IN (`python3 gen-rand.py`) DO (
SET val=%%F.tmp
)

python3 PreCompile.py "%cd%\%1" "%cd%\%val%" %3
cobc %val% -o %2 %3
rem type %val%
del %cd%\%val%