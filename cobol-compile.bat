@echo off
FOR /F "tokens=* USEBACKQ" %%F IN (`python3 gen-rand.py`) DO (
SET val=%%F
)

python3 PreCompile.py "%cd%\%1" "%cd%\%val%"
cobc %3 -o %2 %val%
del %cd%\%val%