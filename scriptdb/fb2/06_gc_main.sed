#==============================================================
# На основе «Генеральная уборка» v.2.2 от jurgennt
# Engine by ©Sclex 01.05.2007 – 07.05.2008
#==============================================================
# Последняя версия тут https://github.com/Balamoote/fb2-scripts

#~~~~~~~~~~ Регулярные выражения ~~~~~~~~~~~~
# Удаление пробелов в начале и конце строки
s=^[[:space:]\xc2\xa0]+==g
s=[[:space:]\xc2\xa0]+$==g
/^[[:space:]]*$/d

# Эскейпим &...;
s=\&(gt|lt|amp);=\x01\1\x02=gI

# Перевести тэги в нижний регистр
s=(</?)([- a-z]+)(/?[ >])=\1\L\2\E\3=gI
s=(/a)(>)=\l\1\2=gI
2 s=<fictionbook\s=<FictionBook =gI
$ s=</fictionbook>=</FictionBook>=gI
#s=($aib)=\L&=gI

# удаление двойных emphasis и strong
s=<emphasis><emphasis>=<emphasis>=gI
s=</emphasis></emphasis>=</emphasis>=gI
s=<strong><strong>=<strong>=gI
s=</strong></strong>=</strong>=gI

# Разделение тэгов, починка и удаление лишних
s=<empty-line></empty-line>=<empty-line/>=gI
s=<(first|middle|last)-(name)\s?/>=<\1-name></\1-\2>=gI
s=<p />=<empty-line/>=gI

/^<sequence/ s~(<sequence)( number="[0-9]+")( name="[^"]+")(/>)~\1\3\2\4~gI

# Перевести название боди в title из body
/^<\x2fdescription>$/ {n; s|(^<body)\sname="([^"]+)">$|\1>\n<title>\n<p>\2</p>\n</title>|}

# замена неразрывных пробелов на обычные
s=([[:alpha:]].—])($aib)?([?!.:,]?)\xc2\xa0($sib)?([[:lower:]][^.])=\1\2\3 \4\5=g

# удаление точки между строчными после пробела, чтобы не цеплялись url'ы — латиница только до
s=([[:lower:]])\s\.([[:lower:]])=\1 \2=g

# удаление непонятной оторванной точки
s=\.\s\.\s\.=…=g
s=([.,]) \.=\1 =gI

# Удаление пробела внутри слова с дефисом
s=(\w|\xcc\x81)[ \xc2\xa0]?-[ \xc2\xa0]?(то|либо|нибудь|кое|ка|таки)\b=\1-\2=gI
s=\b(во?)[ \xc2\xa0]?-[ \xc2\xa0]?(\w)=\1-\2=gI

# удаление лишнего пробела перед закрывающими кавычками, скобками и знаками препинания
s=[ \xc2\xa0]([].,;:!?)»])=\1=g

# удаление лишнего пробела после открывающих кавычек и скобок
s=([[«(„])([ \xc2\xa0])=\1=gI

#  удаление пробела перед кавычкой после которой стоит знак препинания
s=([[:alnum:]!?+.”])([ \xc2\xa0])(\x22)([;:,.?!])=\1\3\4=gI

# замена троеточия и его производных (или знака, например, точка-точка-запятая, которого в русском языке не существует) на многоточие
s=[.,]{3}=…=gI

# короткие тире на длинные
s=([^0123456789])–([^0123456789])=\1—\2=gI

# лидирующее тире с неразрывным пробелом в диалогах; удаление случайного мусора после скана: точка в начале диалога
s=^($sib)?([«\x22]?)[-–—~]{1,2}($sib)?([ \xc2\xa0])?\.?($sib)?([[:alnum:]«\x22„(?!…])=\1\2—\xc2\xa0\3\5\6=gI

# нормализация одиночных курсивных знаков препинания
s=($sib)([- ,.–—;!?:/~])([ \xc2\xa0])?($fib)=\2\3=gI

# денормализация одиночных знаков препинания
s=($sib)([ \xc2\xa0])?([- –—])([ \xc2\xa0])?($fib)=\2\3\4=gI

# удаление стыков эмфазиса и стронга
s=</emphasis>([ \xc2\xa0«])*<emphasis>=\1=gI
s=</strong>([ \xc2\xa0«])*<strong>=\1=gI

# правильнописание сокращений типа "так далее" — т. д.
s=([^[:alnum:].])([Тт])\.\s?([дпеконч])\.=\1\2.\xc2\xa0\3.=g

# правильнописание сокращений "новой эры" — н. э.
s=(н)\.\s?(э)\.=\1.\xc2\xa0\2.=g

# тире после препинаний
s=([[:alnum:]\x22“»)? ])[ \xc2\xa0]?($aib)?([,!?…])[ \xc2\xa0]?($aib)?-{1,2}($aib)?[ \xc2\xa0]?($sib)?(.[^.])=\1\3\2\4\xc2\xa0— \5\6\7=gI

# тире после препинаний — (!..) и (?..)
s=([!?]\.\.)($aib)?[ \xc2\xa0]?[-–—]{1,2}($aib)?[ \xc2\xa0]?($aib)?(.[^.])=\1\2\3\xc2\xa0— \4\5=gI

# тире после препинаний /!).-/
s=([!?]\x22)($aib)?[ \xc2\xa0]?[-–—]{1,2}($aib)?[ \xc2\xa0]?($aib)?(.[^.])=\1\2\3\xc2\xa0— \4\5=gI

# тире после препинаний
s=([!?)])($aib)?[ \xc2\xa0]?[-–—]{1,2}($aib)?[ \xc2\xa0]?($aib)?(\w)=\1\2\3\xc2\xa0— \4\5=gI

# замена дефисов на тире не после препинаний
s=([[:alpha:]])[ \xc2\xa0]?($aib)?-{1,2}[ \xc2\xa0]($aib)?[ \xc2\xa0]?(и|или|and|or|und|oder|і|та|або)\s=\1\2\x03-\x04 \3\4 =gI
s=([^.,!?…])[ \xc2\xa0]?($aib)?[-–]{1,2}[ \xc2\xa0]($aib)?[ \xc2\xa0]?([^0-9<])=\1\2 — \3\4=gI
s=\x03-\x04=-=g

# замена дефисов на тире "A": после !..-, с пробелом или без
s=(!\.\.)($aib)?[ \xc2\xa0]?[-–]{1,2}($aib)?($sib)?[ \xc2\xa0]?($sib)?([^0-9<])=\1\2\3 — \4\5\6=gI

# замена дефисов на тире "Б": после букв и точки, с пробелом
s=([[:lower:]\xcc\x81]\.)($aib)?[ \xc2\xa0][-–]{1,2}($aib)?($sib)?[ \xc2\xa0]?($sib)?([^0-9<])=\1\2\xc2\xa0— \3\4\5\6=g

# замена дефисов на тире "В": после букв и точки перед буквой без точки
s=([[:lower:]\xcc\x81]\.)($aib)?[-–]{1,2}($aib)?($sib)?[ \xc2\xa0]?($sib)?(\w[^.])=\1\2\xc2\xa0— \3\4\5\6=g

# кавычки одиночного символа или небольшого слова
#s=([ \xc2\xa0])\x22[ \xc2\xa0]?([[:alnum:]-\xcc\x81]){1,20}[ \xc2\xa0]?\x22([,.:;?!…])?([ \xc2\xa0])=\1«\2»\3\4=gI

# дубли препинаний
s=,[,.:;]=,=gI

# попытка вернуть кавычки на место, после пробела
#s=\x22([[:alnum:]-\xcc\x81]){1,20})([^:])[ \xc2\xa0]\x22([ \xc2\xa0])=«\1\2»\3=gI

# замыкающие кавычки в конце строки после пробела
s=([ \xc2\xa0])\x22$=»=gI

# замена конечных дефисов на тире !!!Только в стихах!!!
s=[ \xc2\xa0]?[-–]{1,2}[ \xc2\xa0]?(</(emphasis|strong)>)?(</v>)$=\xc2\xa0—\1\2=gI

# удаление сдвоенных тире
s=([-–—])[ \xc2\xa0]?[-–—]=\1=gI

# удаление непонятной запятой после восклицания и вопроса
s=([!?]),=\1=gI

# градусы с секундами и минутами  23°8'48"
s=([0-9]{1,2})°\s?([0-9]{1,2})\x22\s?([0-9]{1,2})\x22=\1°\2′\3″=gI

# градусы с секундами  23°8'
s=([0-9]{1,2})°\s?([0-9]{1,2})\x22=\1°\2′=gI

# удаление сдвоенных открывающих эмфазисов
s=<emphasis><emphasis>=<emphasis>=gI

# удаление сдвоенных закрывающих эмфазисов
s=</emphasis></emphasis>=</emphasis>=gI

# пропущенный пробел перед тире после букв
s=([[:alpha:])»:])($aib)?—[ \xc2\xa0]?([^[:digit:]])=\1\2 — \3=gI

# пропущенный пробел после двоеточия вслед за буквами
s=([[:alpha:]»])($aib)?:($aib)?([„\x22(])([^_0-9])=\1\2: \3\4\5=gI

# точка в начале строки
s=^\.[ \xc2\xa0]?([[:alnum:]«\x22„(?!…])=\1=gI

# тире вместо дефиса после точки перед Прописной
s=(\.)($aib)?[ \xc2\xa0]?($aib)?-($aib)?[ \xc2\xa0]($sib)?([«„\x22“]?[[:upper:]])=\1\2\3\xc2\xa0— \4\5\6=g

# удаление точки/запятой после запятой/точки между строчными
s=([^.][^\xc2\xa0])([[:alnum:]»)])($aib)?([,.])($aib)?[.,]?(\w[^.])=\1\2\3\5\4\6=g

# пробел после закрывающих кавычек перед буквами (почему-то не реагирует на обычные двойные кавычки (")?)
s=([[:alpha:]?.!])($fib)?([»“\x22])($aib)?(\w)=\1\2\3 \4\5=gI

# странные закрывающие кавычки
s=``=»=g

# пробел перед открывающимися кавычками
s=([[:alnum:],:.])«(\w)=\1 «\2=g

# пробел перед Прописной после строчной с точкой!?
s=([[:lower:]])([.?!])($aib)?([[:upper:]])=\1\2\3 \4=g

# кавычки в начале строки
s=^($sib)?.?»=\1«=g

# кавычки в конце строки
s=«.?($fib)?$=»\1=g

# открывающие кавычки после двоеточия
s=: ($sib)?»=: \1«=g

# две точки после слова — в многоточие
s=(\w)\.\. =\1… =gI

# удаление одного пробела вокруг <emphasis'а>
s=(<p>|[ \xc2\xa0])($sib)[ \xc2\xa0]=\1\2=gI
s=([^ \xc2\xa0])($sib)[ \xc2\xa0]=\1 \2=gI
s=[ \xc2\xa0]($fib)([!.…,?])?([ \xc2\xa0]|</p>)=\1\2\3=gI
s=[ \xc2\xa0]($fib)([^ \xc2\xa0])=\1 \2=gI
s=([ \xc2\xa0]—)($fib)=\2\1=gI

# пронумерованный/литерный список
s=^(<p>)($sib)?([«\x22])?([0-9]{1,3}|[[:lower:]])([).])($aib)?[ \xc2\xa0]?($sib)?([[:alnum:]…\x22«])=\1\2\3\4\5\6\xc2\xa0\7\8=g

# пронумерованный список: Ст. 15
s=^(<p>)($sib)?([«\x22])?(Ст\.)[ \xc2\xa0]?([0-9]{1,4}\.)\s=\1\2\3\4\xc2\xa0\5\xc2\xa0=g

# пронумерованный список: •
s=^(<p>)($sib)?(\xe2\x80\xa2)\s=\1\2\3\xc2\xa0=g

# перечень страниц и т.п. через запятую
s=([сртvp])\.([ \xc2\xa0])?([0-9]{1,4}),([0-9]{1,4})=\1.\xc2\xa0\3, \4=gI

# перечень страниц и т.п. с интевалом
s=\s([сртvp])\.([ \xc2\xa0])?([0-9]{1,4})-([0-9]{1,4})= \1.\xc2\xa0\3–\4=gI

# размерности
s=([^-][IVX0-9])\s?($sib)?([чмгт%]|кг|см|км|гг|вв|в\.|мг|мл|вт|га|тыс|млн|час|мин|сек|чел|мкг|квт|руб|коп|экз|ккал|град|млрд)(\.?)([^[:alpha:]])=\1\xc2\xa0\2\3\4\5=g

# отбивка на полугегельную от цифр (неразрывный пробел) знаков параграфа, номера
# "правильный" узкий пробел, отображется малым кол-вом шрифтов
#s=([№§])\s?([0-9])=\1\xe2\x80\x89\2=gI

# неразрывный пробел
s=([№§])\s?([0-9])=\1\xc2\xa0\2=gI

# длинное тире после препинаний
s=([[:lower:]\x22“»)? ])($aib)?([,!?….\x22]+)($aib)?\s?—{1,2}[ \xc2\xa0]([^ .])=\1\2\3\4\xc2\xa0— \5=gI

# длинное тире после препинаний и неразрывного пробела
s=([[:lower:]\x22“»)? ])($aib)?([,!?….]+)($aib)?\xc2\xa0—{1,2}([^ .])=\1\2\3\4\xc2\xa0— \5=gI

# длинное тире после букв и неразрывного пробела
s=([[:lower:]\x22“»])($aib)?\xc2\xa0—{1,2}([^ .])=\1\2 — \3=gI

# удаление стыков эмфазиса
s=</emphasis>([ \xc2\xa0]?[–—.,;:!?]?[ \xc2\xa0]?)<emphasis>=\1=gI

# тире вместо дефиса после точки перед открывающимися угловыми кавычками
s=(\.)[ \xc2\xa0]?-($aib)?[ \xc2\xa0]?($sib)?([«„\x22])=\1\2\xc2\xa0— \3\4=g

# пропущенный пробел после тире после букв и перед буквами
s=([[:alpha:])\x22»])($fib)?[ \xc2\xa0]($fib)?—($fib)?($sib)?([[:alpha:](«])=\1\2\3 — \4\5\6=gI

# пропущенные пробелы вокруг тире между буквами
s=([[:alpha:])\x22»])—([[:alpha:](«])=\1 — \2=gI

# интервал дат !!! Остались стрёмные моменты с длинным набором чисел, вроде почтового индекса или серийного номера
s=([^[:alnum:]№)/-])([0-9]{4})[ \xc2\xa0]?[-–—]{1,2}[ \xc2\xa0]?([0-9]{4})([^[:alnum:]-])=\1\2–\3\4=gI

# интервал дат в отдельной строке
s=^(<p>)([0-9]{4})[ \xc2\xa0]?[-–—]{1,2}[ \xc2\xa0]?([0-9]{4})=\1\2–\3=gI

# интервал дат в начале абзаца
s=^(<p>)([0-9]{4})[ \xc2\xa0]?[-–—]{1,2}[ \xc2\xa0]?([0-9]{4})([^[:alnum:]-])=\1\2–\3\4=gI

# интервал дат
s=([^[:alnum:]№)/-])([0-9]{3})[ \xc2\xa0]?[-–—]{1,2}[ \xc2\xa0]?([0-9]{3})([^[:alnum:]-])=\1\2–\3\4=gI

# интервал дат
s=([^[:alnum:]№)/-])([0-9]{2})[ \xc2\xa0]?[-–—]{1,2}[ \xc2\xa0]?([0-9]{2})([^[:alnum:]-])=\1\2–\3\4=gI

# интервал дат
s=([^[:alnum:]№)/-])([0-9])[ \xc2\xa0]?[-–—]{1,2}[ \xc2\xa0]?([0-9])([^[:alnum:]-])=\1\2–\3\4=gI

# знак градуса
s=\b([0-9]{1,2})[oо]([0-9]{1,2})=\1°\2=g

# знак K°
s=([и&])[ \xc2\xa0]?[KК][oо°]([^[:alnum:]\xcc\x81\xcc\xa0\xcc\xa3\xcc\xa4\xcc\xad\xcc\xb0])=\1 K°\2=g

# градус Цельсия
s=\b([0-9]+)[ \xc2\xa0]?[oо0°]\s?[CС]([^[:alpha:]])?=\1\xc2\xa0°C\2=g

# даты по-римски
s=([IVXLC])[ \xc2\xa0]?[-–—][ \xc2\xa0]?([IVXLC])=\1–\2=g

# знак №
s=N[oо°][ \xc2\xa0]?([0-9]+)=№\xc2\xa0\1=g

# Рисунок №1
s=(рис)\.\s?([0-9]+)=\1.\xc2\xa0\2=gI

# лишние пробелы (везде, кроме стихов и кода)
/^(<code>|<v>)/! s=([ \xc2\xa0])+=\1=g

# удаление одного пробела вокруг </emphasis'а>
/^(<code>|<v>)/! s=([ \xc2\xa0])($sib)[ \xc2\xa0]=\1\2=gI
/^(<code>|<v>)/! s=[ \xc2\xa0]($fib)([ \xc2\xa0])=\1\2=gI

# удаление конечных пробелов строки
s=[ \xc2\xa0]+($aib)?(</p>)$=\1\2=gI

# удаление начальных пробелов строки, кроме стихов
s=^($sib)?[ \xc2\xa0]+=\1=gI
s=^(<p>)?[ \xc2\xa0]+=\1=gI

# удаление мягкого переноса
s=(\xc2\xad|&shy;)==gI

# удаление лишних конечных точек в заголовках
#s=\.($fib)?$==g
#s=(([0-9]([ \xc2\xa0])г{1,2})|([IVX]([ \xc2\xa0])в{1,2})|(\-мл))\.($fib)?$==g

# пропущенный пробел перед строчной после строчной и запятой, точки с запятой
s=([[:lower:][:digit:]])([,;])([[:lower:]]{3,})=\1\2 \3=g

 # неверный знак препинания
s=!…=!..=g

# неверный знак препинания
s=…[.,]([^.,])=…\1=g

# удаление ненужных идентификаторов после конвертации: AutBody_0DocRoot, …fb1, …ole_link2, …toc3, …0prim, …Q__4_Q и т.п.
s/\sid="(_GoBack)"//gI

## Сноски - обрабатывает только сноски стандартного вида
# Приводим вид ссылок к "общему виду"
2 s~(<FictionBook xmlns="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:)[0-9a-z-]+(="http://www.w3.org/1999/xlink">)~\1l\2~gI
s~(<a )[^:]+(:href="#[^"]+" type="note"</a>)~\1l\2~gI
s~(<a type="note" )[^:]+(:href="#[^"]+"</a>)~\1l\2~gI
s~(<a)( type="note")( l:href=\"#[^\"]+\")(>[^<]+</a>)~\1\3\2\4~gI

# Приведение сноски к стандарному виду. НЕПРИЕМЛЕМО, если для каждого раздела существует свой формат префикса сноски
#s~(<a l:href="#)[[:alnum:]]+[^0-9]([0-9]+)(" type="note">[^<]+</a>)~\1n_\2\3~gI

# квадратное окавычивание порядкового номера в ссылке сноски - если n_ , то предполагаем примечание, а не комментарий
s~(<a l:href="#n_[0-9]+" type="note">)[[{]?([0-9]+)[]}]?(</a>)~\1[\2]\3~gI

# снятие курсива со сноски 
s~(<a l:href="#n_[0-9]+" type="note">[^<]+</a>)($fib)~\2\1~gI

# снятие курсива со сноски
s~($sib)([ .]{0,2}<a l:href="#n_[0-9]+" type="note">[^<]+</a>)~\2\1~gI

# удаление пробела после [сноски] , если за пробелом следует препинание
s~[ \xc2\xa0]?(<a l:href="#n_[0-9]+" type="note">[^<]+</a>)[ \xc2\xa0]?([,.;!?:…])?([ \xc2\xa0])?($fib)?~\4\2\1\3~gI

# удаление пробела перед [сноской]
s~[ \xc2\xa0]?($aib)?[ \xc2\xa0]?(<a l:href="#n_[0-9]+" type="note">[^<]+</a>)([^ .,!?:;<\xc2\xa0])~\1\2 \3~gI

# препинания после [сноски] {в конце строки} везде
s~(<a l:href="#n_[0-9]+" type="note">[^<]+</a>)([,!?.:;]+)($fib)?~\2\3\1~gI

# препинания после [сноски] в конце строки
s~(<a l:href="#n_[0-9]+" type="note">[^<]+</a>)([,.!?:;…])($fib)(</[pv]>)?$~\2\3\1\4~gI

# вставка пробела после [сноски]
s~\s(<a l:href="#n_[0-9]+" type="note">[^<]+</a>)($sib)?([[:alnum:]–—([-])~\1 \2\3~gI

# снятие курсива со сноски
s~(<a l:href="#n_[0-9]+" type="note">)($sib)([^><]+?)($fib)(</a>)~\1\2\3\4\5~gI

# удаление мусора.
# ■
s=\xe2\x96\xa0==g

s=\.;\.$=.=g

# •
#s=^([^\xe2\x80\xa2]+)\xe2\x80\xa2=\1=g

# HTML коды
s=\&amp;#171;=«=g
s=\&amp;#187;=»=g

#~~~~~~~~~~~~~~ Конец шаблонов ~~~~~~~~~~~~~~~~~~


# Удаление пробелов в начале и конце строки
s=^[[:space:]\xc2\xa0]+==g
s=[[:space:]\xc2\xa0]+$==g

# Анэскейпим &...;
s=\x01(gt|lt|amp)\x02=\&\1;=gI


