: << 'CMDBLOCK'
@echo off
REM Wrapper polyglot cross-platform para scripts de hook.
REM No Windows: o cmd.exe roda a parte batch, que localiza e chama o bash.
REM No Unix: o shell interpreta como script (: é no-op em bash).
REM
REM Os scripts de hook usam nome sem extensão (ex.: "session-start") para
REM evitar a auto-detecção de .sh do Claude Code no Windows.
REM
REM Uso: run-hook.cmd <nome-do-script> [args...]

if "%~1"=="" (
    echo run-hook.cmd: missing script name >&2
    exit /b 1
)

set "HOOK_DIR=%~dp0"

REM Git for Windows bash em locais padrão
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    exit /b %ERRORLEVEL%
)
if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    "C:\Program Files (x86)\Git\bin\bash.exe" "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    exit /b %ERRORLEVEL%
)

REM bash no PATH (Git Bash, MSYS2, Cygwin)
where bash >nul 2>nul
if %ERRORLEVEL% equ 0 (
    bash "%HOOK_DIR%%~1" %2 %3 %4 %5 %6 %7 %8 %9
    exit /b %ERRORLEVEL%
)

REM Sem bash - sair em silêncio (o plugin segue funcionando, sem a injeção de contexto)
exit /b 0
CMDBLOCK

# Unix: roda o script nomeado diretamente
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$1"
shift
exec bash "${SCRIPT_DIR}/${SCRIPT_NAME}" "$@"
