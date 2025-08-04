@echo off
REM Beyond Flutter CLI - Windows Batch Script
REM Place this file in a directory that's in your PATH

set CLI_PATH=%~dp0..
dart run "%CLI_PATH%\bin\beyond_flutter_cli.dart" %*