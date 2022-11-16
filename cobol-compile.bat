@echo off
FOR /F "tokens=* USEBACKQ" %%F IN (`python3 gen-rand.py`) DO (
SET val=%%F.tmp
)
rem %1 == source file
rem %2 == output binary
rem %3 == -m library, -x executable
python3 PreCompile.py "%cd%\%1" "%cd%\%val%" %3 %2
cobc %val% -o %2 %3
rem type %val%
del %cd%\%val%