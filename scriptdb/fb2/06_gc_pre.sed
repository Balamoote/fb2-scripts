#~~~~~~~~~~ Регулярные выражения ~~~~~~~~~~~~
# Разделение тэгов, починка и удаление лишних
# Последняя версия тут https://github.com/Balamoote/fb2-scripts

s=><fictionbook\s=>\n<FictionBook =gI
s=(<title>)([^<]*)(</title>)=\1\n<p>\2</p>\n\3=gI

s=<(cite|epigraph|poem|section|stanza|table|title|annotation|author|body|coverpage|description|document-info|history|publish-info|src-title-info|title-info|translator|first-name|middle-name|last-name|id|genre|coverpage|author|program-used|title-info|history|section|title|title-info|p|coverpage|title-info|src-url|src-lang|document-info|book-name|publisher|isbn|v|nickname|year|subtitle)([ >])=\n<\1\2=gI

s=<(/)(cite|epigraph|poem|section|stanza|table|title|annotation|author|body|coverpage|description|document-info|history|publish-info|src-title-info|title-info|translator|first-name|middle-name|last-name|id|genre|coverpage|author|program-used|title-info|history|section|title|title-info|p|coverpage|title-info|src-url|src-lang|document-info|book-name|publisher|isbn|v|nickname|year)>=<\1\2>\n=gI

s=<(/)(cite|epigraph|poem|section|stanza|table|title|annotation|author|body|coverpage|description|document-info|history|publish-info|src-title-info|title-info|translator|coverpage|author|title-info|history|section|title|title-info|coverpage|title-info|document-info)>=\n<\1\2>=gI

s=<(empty-line|sequence|image)([^/]*)?/>=\n<\1\2/>\n=g
#s=<(custom-info) [^/>]+>=<\1>=g
s=(<date [^<]+</date>)=\n\1\n=gI

s=<(image|sequence)( [^>]+)></(image|sequence)>=\n<\1\2/>=gI

