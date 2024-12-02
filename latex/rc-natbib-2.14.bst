% rc-natbib.bst alpha v0.1
%
% Copyright (c) 2000-2007 Rafael Corchuelo (corchu@us.es)
%
% This bst file works together with rc-language to provide you with 
% multilingual bibliographies.
%
% This class IS NOT re-distributable.  Only members of the TDG are allowed to
% use it.  If you happen to have this file, please, use it at your own risk.
% No support is available.  Don't send me e-mail asking me about rc-natbib.
% A day, RC-natbib will be made available to LaTeX users, but that day still
% has to come!

% alpha v0.0 2007/08/31
%
% New features
%   - Everything is new today! See rc-natbib.sty for further details.
%   - First names are shortened to the initials by default. So you don't need to 
%     care of homogenise your bib files
%   - Fields url, doi and abstract are recorgnised.
%   - If both the url and doi fields are specified, only the doi is displayed.  
%     Please, make sure that you specify a proper doi, e.g, 10.1000/182 is a doi,
%     but http://dx.doi.org/10.1000/182 is an URL!
%   - Urls are typeset automatically using an url command.  Please, if you have 
%     an entry of the form 
%           url = "\url{http://www.foo.com}"
%     change it into
%           url = "http://www.foo.com" 
%     since rc-natbib cares of formatting them.
%
% Known bugs... I mean, features
%   - There seems to be a bug in natbib.sty that prevents BibTeX entries
%     that use \noopsort or \switchargs from working as usual.  There's a simple 
%     workaround: remove the enclosing braces, i.e., change {\noopsort{1973b}} into 
%     \noopsort{1973b}. 

% alpha v2.14 2012/08/31
%
% New features
%
% Fixed bugs... I mean, features
%   - There was a problem with authors like "... and {\'A}ngel Vi{\~n}as". No space
%   was typeset after the "and" and the result was "... andÁ. Viñas".  Changing the 
%   command to produce the accent didn't solve the problem, but made it worse.  This
%   problem has been mended.
%   - There was a problem with \citeauthor*{ref}.  The ", and" was not localised 
%   properly.  For example, \citeauthor{ref} now outputs something like "Elvert, 
%   Rupert, and Johns" in English, but "Elvert, Rupert y Johns" in Spanish.
%   - In entries that didn't have a DOI or a URL, usually there was an extra period
%   at the end.  This has been mended.

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    url
    doi
    abstract
  }
  {}
  { label extra.label sort.label short.list }

INTEGERS { output.state before.all mid.sentence after.sentence after.block after.optional.block}

STRINGS { s t }

FUNCTION {init.state.consts}
{ 
    #0 'before.all :=
    #1 'mid.sentence :=
    #2 'after.sentence :=
    #3 'after.block :=
    #4 'after.optional.block :=    
}

FUNCTION {not}
{   
        { #0 }
        { #1 }
    if$
}

FUNCTION {and}
{
        'skip$
        { pop$ #0 }
    if$
}

FUNCTION {or}
{   
        { pop$ #1 }
        'skip$
    if$
}

FUNCTION {output.nonnull}
{ 
    's :=
    output.state mid.sentence =
        { 
            ", " * write$ 
        }
        { 
            output.state after.block =
            { 
                add.period$ " " * write$
                newline$
                "\newblock " write$
            }
            { 
                output.state before.all =
                    'write$
                    { 
                        add.period$ " " * write$ 
                    }
                if$
            }
            if$
            mid.sentence 'output.state :=
        }
    if$
    s
}

FUNCTION {output}
{ 
    duplicate$ empty$
        'pop$
        'output.nonnull
    if$
}

FUNCTION {output.optional}
{ 
    's :=
    write$
    newline$
    "\newblock " write$
    mid.sentence 'output.state :=
    s
}


FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {new.block}
{ 
    output.state before.all =
        'skip$
        { after.block 'output.state := }
    if$
}

FUNCTION {new.sentence}
{ 
    output.state after.block =
    'skip$
    { 
        output.state before.all =
            'skip$
            { after.sentence 'output.state := }
        if$
    }
  if$
}

FUNCTION {format.url.or.doi}
{
    add.period$
    url empty$
    doi empty$
    and
        { "" }
        { 
            new.block
            "\begin{RCNBurldoi} " 
            doi empty$
                { "\bibAvailableatname\space\url{" url * "}" * }
                { "{DOI}: \doi{" doi * "}" * }
            if$
            add.period$
            " \end{RCNBurldoi}" * *
        }
    if$
}

FUNCTION {format.note.and.abstract}
{
    note empty$
        { "" }
        { new.block note add.period$ }
    if$
    abstract empty$
        { "" }
        { new.block "\begin{RCNBabstract} " abstract add.period$ * " \end{RCNBabstract}" * }
    if$    
    *    
}

FUNCTION {fin.entry}
{
    new.block
    format.url.or.doi output.optional 
    new.block    
    format.note.and.abstract output.optional
    
    write$ newline$ 
    "\par" write$ newline$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ 
    duplicate$ empty$
        { pop$ "" }
        { "\textsl{" swap$ * "}" * }
    if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "\bibcommaand\xspace" * }
                'skip$
              if$
              t "others" =
                { " \bibetalname\xspace " * }
                { " \bibandname\ " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { ", \bibeditorsname\xspace" * }
        { ", \bibeditorname\xspace" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ 
    title empty$
        { "" }
        { 
            url empty$ not
                { "\hyperlink{" url * "}{" * title "t" change.case$ * "}" *  }
                {
                    doi empty$ not
                        { "\hyperlink{http://dx.doi.org/" doi * "}{" * title "t" change.case$ * "}" *  }                         
                        { title "t" change.case$ }
                    if$
                }
            if$
        }
    if$
    emphasize
}

FUNCTION {format.full.names}
{'s :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}" format.name$ 't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              numnames #2 >
                { "\bibcommaand\ " * }
                'skip$
              if$
              t "others" =
                { " \bibetalname\xspace" * }
                { " \bibandname\ " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {author.editor.key.full}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.full.names }
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {author.key.full}
{ author empty$
    { key empty$
         { cite$ #1 #3 substring$ }
          'key
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {editor.key.full}
{ editor empty$
    { key empty$
         { cite$ #1 #3 substring$ }
          'key
      if$
    }
    { editor format.full.names }
  if$
}

FUNCTION {make.full.names}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.full
    { type$ "proceedings" =
        'editor.key.full
        'author.key.full
      if$
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  ")" make.full.names duplicate$ short.list =
     { pop$ }
     { * }
   if$
  "]{" * write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year duplicate$ empty$
    { "empty year in " cite$ * "; set to ????" * warning$
       pop$ "????" }
    'skip$
  if$
  month empty$
    'skip$
    { month
      " " * swap$ *
    }
  if$
  extra.label *
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "\bibvolumename\xspace" volume tie.or.space.connect
      series empty$
        'skip$
        { " \bibofname\xspace " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "\bibnumbername\xspace" }
            { "\bibNumbername\xspace" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { ".\space\bibInname\xspace " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { "\bibeditionname\xspace " edition * }
        { "\bibeditionname\xspace " edition * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "\bibpagesname\xspace" pages n.dashify tie.or.space.connect }
        { "\bibpagename\xspace" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { "\penalty0 (" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":\penalty0 " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "\bibchaptername\xspace" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "\bibInname\xspace " booktitle emphasize * }
        { "\bibInname\xspace " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "\bibtechnicalreportname\xspace" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "\bibInname\xspace \textsl{" journal * "\/}" * }
      if$
    }
    { "\bibInname\xspace " key * }
  if$
  " \citep{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "\bibInname\xspace "
    }
    { "\bibVolumename\xspace" volume tie.or.space.connect
      " \bibofname\xspace " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { "\textsl{" * series * "\/}" * }
          if$
        }
        { key * }
      if$
    }
    'skip$
  if$
  ", \citet{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "\bibInname\xspace \textsl{" booktitle * "\/}" * }
          if$
        }
        { "\bibInname\xspace " key * }
      if$
    }
    { "\bibInname\xspace " }
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { journal emphasize "journal" output.check
      format.vol.num.pages output
      format.date "year" output.check
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title "title" output.check
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  fin.entry
}

FUNCTION {inbook}
{ 
    output.bibitem
    author empty$
        { format.editors "author and editor" output.check }
        { format.authors output.nonnull
          crossref missing$
            { "author and editor" editor either.or.check }
            'skip$
          if$
        }
    if$
    new.block
    format.title "title" output.check
    crossref missing$
        { 
            format.bvolume output
            format.chapter.pages "chapter and pages" output.check
            new.block
            format.number.series output
            new.sentence
            publisher "publisher" output.check
            address output
        }
        { 
            format.chapter.pages "chapter and pages" output.check
            new.block
            format.book.crossref output.nonnull
        }
     if$
     format.edition output
    format.date "year" output.check
    fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address empty$
        { organization publisher new.sentence.checkb
          organization output
          publisher output
          format.date "year" output.check
        }
        { address output.nonnull
          format.date "year" output.check
          new.sentence
          organization output
          publisher output
        }
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.nonnull
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.title "title" output.check
  author empty$
    { organization empty$
        { address new.block.checka
          address output
        }
        'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  fin.entry
}
FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  "\bibMasterthesisname\xspace" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  url empty$
    { "" }
    { new.block "\space\bibAvailableatname\space\url{" url "}" * * }
  if$ output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  "\bibPhDthesisname\xspace" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.title "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization publisher new.sentence.checkb
          organization output
        }
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
        'skip$
        { organization output }
      if$
      publisher output
    }
  if$
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  fin.entry
}

FUNCTION {unpublished}
{ 
    output.bibitem
    format.authors "author" output.check
    new.block
    format.title "title" output.check
    format.date "year" output.check
    new.block
    fin.entry
}

FUNCTION {default.type} { misc }

MACRO{jan}{"\bibjanname\xspace"}
MACRO{feb}{"\bibfebname\xspace"}
MACRO{mar}{"\bibmarname\xspace"}
MACRO{apr}{"\bibaprname\xspace"}
MACRO{may}{"\bibmayname\xspace"}
MACRO{jun}{"\bibjunname\xspace"}
MACRO{jul}{"\bibjulname\xspace"}
MACRO{aug}{"\bibaugname\xspace"}
MACRO{sep}{"\bibsepname\xspace"}
MACRO{oct}{"\biboctname\xspace"}
MACRO{nov}{"\bibnovname\xspace"}
MACRO{dec}{"\bibdecname\xspace"}

MACRO {acmcs} {"ACM Computing Surveys"}
MACRO {acta} {"Acta Informatica"}
MACRO {cacm} {"Communications of the ACM"}
MACRO {ibmjrd} {"IBM Journal of Research and Development"}
MACRO {ibmsj} {"IBM Systems Journal"}
MACRO {ieeese} {"IEEE Transactions on Software Engineering"}
MACRO {ieeetc} {"IEEE Transactions on Computers"}
MACRO {ieeetcad} {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}
MACRO {ipl} {"Information Processing Letters"}
MACRO {jacm} {"Journal of the ACM"}
MACRO {jcss} {"Journal of Computer and System Sciences"}
MACRO {scp} {"Science of Computer Programming"}
MACRO {sicomp} {"SIAM Journal on Computing"}
MACRO {tocs} {"ACM Transactions on Computer Systems"}
MACRO {tods} {"ACM Transactions on Database Systems"}
MACRO {tog} {"ACM Transactions on Graphics"}
MACRO {toms} {"ACM Transactions on Mathematical Software"}
MACRO {toois} {"ACM Transactions on Office Information Systems"}
MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}
MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.lab.names}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " \bibetalname\xspace" * }
    { #2 <
        'skip$
        { s #2 "{f }{vv }{ll}{ jj}" format.name$ "others" =
            { " \noexpand\bibetalname\xspace" * }
            { " \noexpand\bibandname\xspace " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        { key #3 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            { key #3 text.prefix$ }
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        { key #3 text.prefix$ }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        { key #3 text.prefix$ }
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  "("
  *
  year duplicate$ empty$
     { pop$ "????" }
     'skip$
  if$
  *
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * }
        'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
        { "et al" * }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.label :=
  sort.label *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.label next.extra }

INTEGERS { longest.label.width last.extra.num number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
  label extra.label * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT

FUNCTION {begin.bib}
{   
    "% Generated by RC-NatBib" write$ newline$  
    newline$
    preamble$ empty$
        'skip$
        { preamble$ write$ newline$ }
    if$
    newline$  
    "\bgroup" write$ newline$    
    "     \makeatletter" write$ newline$  
    "     \ifx\RCNatBib\@undefined" write$ newline$  
    "         \@latex@error{RC-NatBib requires package rc-natbib.sty}" write$ newline$  
    "     \fi" write$ newline$
    "     \ifx\RCLanguage\@undefined" write$ newline$  
    "         \@latex@error{RC-NatBib requires package rc-language.sty}" write$ newline$  
    "     \fi" write$ newline$  
    "     \ifx\xspace\@undefined" write$ newline$  
    "         \@latex@error{RC-NatBib requires package xspace.sty}" write$ newline$  
    "     \fi" write$ newline$    
    "     \ifx\RCHyperLink\@undefined" write$ newline$  
    "         \@latex@error{RC-NatBib requires package rc-hyperlink.sty}" write$ newline$  
    "     \fi" write$ newline$      
    "\egroup" write$ newline$ 
    newline$       
    "\begin{thebibliography}{" number.label int.to.str$ * "}" * write$ newline$
    "\expandafter\ifx\csname natexlab\endcsname\relax\def\natexlab#1{#1}\fi" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ 
    newline$
    "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}



