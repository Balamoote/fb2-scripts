BEGIN { 
    sib = "<emphasis>|<strong>|<emphasis><strong>|<strong><emphasis>";
    fib = "<\x2femphasis>|<\x2fstrong>|<\x2emphasis><\x2strong>|<\x2strong><\x2emphasis>";
    aib = "<emphasis>|<strong>|<emphasis><strong>|<strong><emphasis><\x2femphasis>|<\x2fstrong>|<\x2emphasis><\x2strong>|<\x2strong><\x2emphasis>"
    sau = "^(<author>|<translator>|<publisher>)$"
    fau = "^(<\x2fauthor>|<\x2ftranslator>|<\x2fpublisher>)$"
    }
{

if ( $0 ~ /^[ \t]*$/ ) { next; }

# Кривые заловки в <subtitle>
while ( $0 == "<p>" ) { sti = "";
    while ( $0 !~ "</p>$" ) {
         sti = sti $0;
         getline;
    }; sti = sti $0; getline

    pat = "<p>(" sib ")(.*)(" fib ")</p>";
    sb  = gensub(pat, "<subtitle>\\2</subtitle>", "g", sti);
    pat = "(" aib ")";
    sb  = gensub(pat, "", "g", sb)
    print sb };

# Убрать левые id из тэгов описания книги
while ( $0 ~ sau ) { noid = "";
    while ( $0 !~ fau ) {
         if ( $0 !~ /<id>.*<\/id>/ ) { noid = noid $0 "\n"};
         getline;
    }; noid = noid $0 "\n"; getline
    print noid };

print
}

