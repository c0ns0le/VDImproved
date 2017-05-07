::Used to delay(sleep) execution of classque file(s) until defined time
:: Paramters passed: name of file to execute, the duration till execution.

@ECHO OFF
v:
SETLOCAL ENABLEDELAYEDEXPANSION
SLEEP %2
CALL %0
CALL v:\VDImproved\writeEvent.bat %~nx0 "ClassQue%1 delayed for %2"

