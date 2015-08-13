@echo off

if exist capstone.zip del capstone.zip
"%PROGRAMFILES%\7-Zip\7z.exe" a -tzip capstone.zip *.exe *.dll *.pas *.bin *.lpi *.lpr *.bat README.md LICENSE
