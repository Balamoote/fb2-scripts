# Скрипт вывода структуры fb2
# Последняя версия тут https://github.com/Balamoote/fb2-scripts
BEGIN {
#    maintags = 1;
#    titltags = 1;
#    linktags = 1;
#    imgstags = 1;
    }

{
if ( maintags == 1 ) {
    if ($0 ~ /<\x2f?(FictionBook|description|body|section|poem|stanza|code|epigraph)[ >]/) { print $0 } };

if ( titltags == 1 ) { if ($0 ~ "<title>") { print $0; do { getline; print $0;} while ($0 !~ "<\x2ftitle>") } };

if ( linktags == 1 ) {
    if ($0 ~ "<a l:href") { m = split ($0, lynk, "<a \x7c<\x2fa>" ); # эскейпим '|' и '/', чтобы не ругалось
	for ( i=1; i <= m; i++) { lnk = match(lynk[i], /^l:href=/);
		if ( lnk ) { printf ("      %s%s%s\n", "<a ", lynk[i], "<\x2fa>") }	} } }

if ( imgstags == 1 ) {
    if ($0 ~ "<image l:href") { m = split ($0, images, "<image \x7c\x2f>" ); # эскейпим '|' и '/', чтобы не ругалось
	for ( i=1; i <= m; i++) { img = match(images[i], /^l:href=/);
		if ( img ) { printf ("      %s%s%s\n", "<image ", images[i], "\x2f>") }	} }
    if ($0 ~ "<binary id") { m = split ($0, binaries, "<binary \x7c\x22>" ); # эскейпим '|' и '/', чтобы не ругалось
	for ( i=1; i <= m; i++) { img = match(binaries[i], /^id=/);
		if ( img ) { printf ("      %s%s%s\n", "<binary ", binaries[i], "\x22>") }	} }

    }

}
