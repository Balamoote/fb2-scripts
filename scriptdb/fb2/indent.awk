BEGIN { # Скрипт расстановки пробелов в начале строки для fb2 формата.
	# Последняя версия тут https://github.com/Balamoote/fb2-scripts
	tag1 = "cite epigraph poem section stanza table title tr";
	tag2 = "annotation author body coverpage description document-info history publish-info src-title-info title-info translator";
	sticky = "FictionBook binary"

	split(tag1, ntags1, " "); for (i in ntags1) { s = "<" ntags1[i]; f = "</" ntags1[i]; stags1[s] = s; ftags1[f] = f };
	split(tag2, ntags2, " "); for (i in ntags2) { s = "<" ntags2[i]; f = "</" ntags2[i]; stags2[s] = s; ftags2[f] = f };
} {

intag = match($0, "[> ]");
if ( intag > 0) { a = substr($0, 1, intag-1) }
else a = "none";

sw = 0

if ( a == stags1[a] ) { sw = "increase"; inc = 1 };
if ( a == ftags1[a] ) { sw = "decrease"; inc = 1 };
if ( a == stags2[a] ) { sw = "increase"; inc = 2 };
if ( a == ftags2[a] ) { sw = "decrease"; inc = 2 };
if ( a == /<\x2fFictionBook>|<\x2f?binary>/ ) { sw = "sticky" };
if ( $0 == "<publisher>" ) { sw = "increase"; inc = 1 };
if ( $0 == "<\x2fpublisher>" ) { sw = "decrease"; inc = 1 };

switch (sw) {
case "increase":
	$0 = sprintf( "%s%s", padding, $0 );
	pad += inc; padding = sprintf("%" pad "s", "");
	break;
case "decrease":
	pad -= inc; padding = sprintf("%" pad "s", "");
	$0 = sprintf( "%s%s", padding, $0 );
	break;
case "sticky":
	pad = 0; padding = "";
	$0 = sprintf( "%s%s", padding, $0 );
	break;
default:
	$0 = sprintf( "%s%s", padding, $0);
	};

if ( $0 !~ /^[ \t]*$/ ) { print $0 };

}

