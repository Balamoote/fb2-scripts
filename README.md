# fb2-scripts
Набор скриптов для починки и обработки и валидации fb2 файлов в bash (Linux и другие Unix-подобные)</br>
Дублирует некоторые возможности скриптов из набора FictionBook Reader</br>
Сделано на основе скриптов, написанных Sclex и Jurgennt:</br>
- "генеральная уборка": более-менее полное повторение, но функционал расширен и дополнен</br>
- "кирилица в латинице": пока только для букв, которые однозначно входят в слово</br>

Скрипт "генеральная уборка" также выполняет валидацию файла fb2 и сравнивает в vim исходный и обработанный файлы.

Скрипты в работе, могут быть ошибки.


Запуск ./fb2fix.sh [ключ] book.fb2

Возможные ключи:

-gc   | -06 	- "генеральная уборка", немного расширенная версия оригинального скрипта от Sclex + валидатор</br>
                  Также ищет и исправляет латиницу в кириллице и "чинит" римские цифры.</br>
-lnun | -lu 	- сквозная сортировка сносок типа n_[0-9]+ и их <section id=, базовая проверка ссылок</br>
-stal | -st0	- вывести структуру fb2: основные тэги + заголовки + сноски тексте + картинки</br>
-ston | -st1	- вывести структуру fb2: основные тэги + заголовки</br>
-stln | -st3	- вывести структуру fb2: только сноски в тексте</br>
-stim | -st4	- вывести структуру fb2: только тэги картинок</br>
-ch   | -char	- вывести список всех символов в файле - для вывода в консоль</br>
-ch0  | -chnc	- вывести список всех символов в файле (без цвета) - для записи в файл</br>


Требования

1. bash, т.е. любая из unix-пободных консолей.</br>
В том числе Termux на Андроиде, linux-консоль в Windows или GygWin там же, разные Linux'ы, MacOS и т.д. и т.п.

2. GNU sed, GNU awk, vim или neovim, xmllint, gettext, dos2unix</br>
Всё это или уже есть в системе или его нужно доустановить.</br>
- xmllint, как его поставить смотрим тут https://command-not-found.com/xmllint</br>

Некоторые системы (например, MacOS) по умолчанию имеют свои вариации sed и awk. Обязательно установите именно GNU sed и GNU awk.

3. в scriptdb/settings.ini должен быть установлен один из редакторов vim или nvim</br>
(Параметр termcorrection пока не используется - это настройка для скриптов из соседнего репозитария)

