# fb2-scripts
Набор скриптов для починки и обработки и валидации fb2 файлов в bash (Linux и другие Unix-подобные)
Дублирует некоторые возможности скриптов из набора FictionBook Reader
Сделано на основе скриптов, написанных Sclex и Jurgennt:
- "генеральная уборка": более-менее полное повторение, но функционал расширен и дополнен
- "кирилица в латинице": пока только для букв, которые однозначно входят в слово

Скрипт "генеральная уборка" также выполняет валидацию файла fb2 и сравнивает в vim исходный и обработанный файлы.

Скрипты в работе, могут быть ошибки.


Запуск ./fb2fix.sh [ключ] book.fb2

Возможные ключи:

-gc   | -06 	- "генеральная уборка", немного расширенная версия оригинального скрипта от Sclex + валидатор
                  Также ищет и исправляет латиницу в кириллице и "чинит" римские цифры.
-lnun | -lu 	- сквозная сортировка сносок типа n_[0-9]+ и их <section id=, базовая проверка ссылок
-stal | -st0	- вывести структуру fb2: основные тэги + заголовки + сноски тексте + картинки
-ston | -st1	- вывести структуру fb2: основные тэги + заголовки
-stln | -st3	- вывести структуру fb2: только сноски в тексте
-stim | -st4	- вывести структуру fb2: только тэги картинок
-ch   | -char	- вывести список всех символов в файле - для вывода в консоль
-ch0  | -chnc	- вывести список всех символов в файле (без цвета) - для записи в файл

