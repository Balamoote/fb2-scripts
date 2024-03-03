# Отсортировать примечания в теле fb2, отсортировать sections не.
# Сортировка сквозная! Рабтает только на уже офрматированных ссылках, приведенных к виду
# <a l:href="n_150" type="note">[150]</a>
# Последняя версия тут https://github.com/Balamoote/fb2-scripts
BEGIN { 
	
#    ofile = "links.fb2"
    n = 0;
    RS = "<section"
    } {

book[++num] = $0;

}
END { 

for ( b=1; b <= num; b++ ) {
    if ( b > 1 ) { book[b] = RS book[b] };
    clen = length(book[b]);

while (match(book[b], /(<a) (l:href="#n_)([0-9]+)(" type="note">\[)([0-9]+)(\]<\/a>)/, lyn) > 0 ) {

    if ( lynks[lyn[3]] != "" )
        { printf ( "%s %s\n", "Дубликат сноски", lyn[3] ); xit++ };
    if ( lyn[3] != lyn[5] )
        { printf ( "%s %s %s\n", "Название сноски", lyn[3], "не соответствует её индексу" ); xit++ };

    n++; mblinks[lyn[3]] = lyn[0];
    lynks[lyn[3]] = n; 
    first = substr(book[b], 1, RSTART-1); last = substr(book[b], RSTART+RLENGTH, clen)
    book[b] = first lyn[1] "!Ъ_@Ь#Ь@_Ъ!" lyn[2] n lyn[4] n lyn[6] last    
    clen = length(book[b]);
                            }
    book[b] = gensub("!Ъ_@Ь#Ь@_Ъ!", " ", "g", book[b])
    clen = length(book[b])

while (match(book[b], /(<section) (id="n_)([0-9]+)(">\n\s*<title>\n\s*<p>)([0-9]+)(<\/p>)/, lyn) > 0 ) {

    if ( lynks[lyn[3]] == "" )
        { printf ( "%s %s\n", "Ни одна сноска не ссылается на секцию", lyn[3] ); xit++ };
    if ( lyn[3] != lyn[5] )
        { printf ( "%s %s %s\n", "Название индекс section", lyn[3], "не соответствует её title" ); xit++ };

    s++; selinks[lyn[3]] = lyn[0]; se2links[lyn[3]] = lyn[0];
    first = substr(book[b], 1, RSTART-1); last = substr(book[b], RSTART+RLENGTH, clen);
    book[b] = first lyn[1] "!Ъ_@Ь#Ь@_Ъ!" lyn[2] lynks[lyn[3]] lyn[4] lynks[lyn[3]] lyn[6] last;
    clen = length(book[b]);
                            }
    book[b] = gensub("!Ъ_@Ь#Ь@_Ъ!", " ", "g", book[b])
        }

if (n > s) { printf "%s\n", "Ссылок больше, чем секций."; xit++ };
if (n < s) { printf "%s\n", "Секций больше, чем ссылок."; xit++ };

for ( i in mblinks ) { if (selinks[i] != "" ) { delete selinks[i] }; if ( mblinks[i] == "" ) { delete mblinks[i] };};
for ( i in se2links ) { if (mblinks[i] != "" ) { delete mblinks[i] }; if ( selinks[i] == "" ) { delete selinks[i] }; };

if (mb = length(mblinks)) { printf ("%s %s\n","Сиротские сноски:", mb); for ( i in mblinks ) { printf ("%s\n", mblinks[i]) }; };
if (se = length(selinks)) { printf ("%s %s\n","Сиротские секции:", se); for ( i in mblinks ) { printf ("%s\n", selinks[i]) }; };

if ( xit > 0 ) { printf ("%s %s %s\n", "Найдено", xit, "ошибок. Обработка прекращена."); exit };

for ( b=1; b <= num; b++ ) { 
        if ( match(book[b], /(<section) (id="n_)([0-9]+)(">\n\s*<title>\n\s*<p>)([0-9]+)(<\/p>)/, lyn) == 0 && b < num )
             { startbook = startbook book[b] }
        else { lynsec[lyn[3]] = book[b] };
        if ( match(book[b], /(<section) (id="n_)([0-9]+)(">\n\s*<title>\n\s*<p>)([0-9]+)(<\/p>)/, lyn) == 0 && b == num )
             { endbook = book[b] };
        if ( match(book[b], /(<section) (id="n_)([0-9]+)(">\n\s*<title>\n\s*<p>)([0-9]+)(<\/p>)/, lyn) > 0 && b == num )
             { split(book[b], lnote, "</section>\n"); lynsec[lyn[3]] = lnote[1] "</section>\n"; endbook = lnote[2]};
        }

    nt = length(lynsec)
    for ( i=1; i <= nt; i++) { notes = notes lynsec[i] }
    printf ( "%s\n", "Ошибок не найдено.")
    printf ( "%s%s%s", startbook, notes, endbook) > ofile
    }

