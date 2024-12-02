% rc-book.cls alpha v2.14
%
% Copyright (c) 2000-2012 Rafael Corchuelo (corchu@us.es)
%
% This class provides new commands for type-setting modern, attractive books
%
% This class IS NOT re-distributable.  Only members of the TDG are allowed to
% use it.  If you happen to have this file, please, use it at your own risk.
% No support is available.  Don't send me e-mail asking me about RC-BooK.
% A day, RC-BooK will be made available to LaTeX users, but that day still
% has to come!

% alpha v0.0 2000/01/10
%   - RC-BooK is just a handful of commands to typeset floats inside nice rules!
%     Only for its creator's eyes!

% alpha v1.0 2001/01/16
%   - This was the first release brought to the TDG

% alpha v1.1 2001/01/20
%
% New features
%   - \path{text}

% alpha v1.2 2001/07/28
%
% New features
%   - \product{product name}
%   - \marginalnote{text}
%   - \blank, and \tilde
%   - Typewriter text is typeset using "cmtt m n at 10pt" instead of "cmtt m n at 12pt"
%   - Package amssymb is loaded by default
%   - The listing and program environments now support automatic line numbering
%   - \ref{label} puts a \S in front of the reference
%   - The first argument to environment comparison is now the name of the image to be displayed
%
% Fixed bugs, I mean... features
%   - Corrected \concept so that it does not leave an extra space in the output
%   - The icon in a tip box is now placed correctly
%   - Preferred placement for tips is now tbp
%   - Postscript figures use now 0.9\linewidth instead of \hsize

% alpha v1.3 2001/07/08
%
% New features
%   - Tables are now typeset using tabularx so that you can use the X column format
%     \begin{table}[width]{caption}{label}{layout}{heading} text \end{table}
%   - \option{text}
%   - \keystroke{text}
%   - It now includes the color package.
%   - Foot notes are now referenced to by means of symbols
%
% Fixed bugs, I mean... features
%   - Marginal notes are now aligned properly
%   - The distance between a tip and the preceding paragraph is now the same in
%     normal text and tips

% alpha v1.4 2002/01/07
%
% Fixed bugs, I mean... features
%   - \drop works well, even if there's not a preceding section

% alpha v1.5 2002/08/03
%
% Fixed bugs, I mean... features
%    - Please, enjoy typing `¡'  and `¿' in verbatim mode!.  Notice that you
%    need to add the following lines to the preamble of you LaTeX source
%    so that `¡' and `¿' work well in verbatim mode.
%
%    \usepackage[T1]{fontenc}
%    \usepackage{textcomp}
%
%    - RC-BooK is now compatible with the hyperref package.  Now, when you
%    transform your .dvi output into .pdf, the .pdf file can analyse
%    your contents section and cross references.  They appear as clickable
%    links that help you to move around quickly.
%    - Figures, tables, and other floating material is displayed now using
%    all the space available for text.  It includes the space normally used
%    for marginal notes.  Notice that you usually need to compile twice to
%    get good results.  If you compile only once, some floatings might not
%    be typeset well.

% alpha v1.6 2002/08/22
%
% Fixed bugs, I mean... features
%    - There is a page number at the botton of every new chapter
%    - The listing environment now leaves the same space before and after
%      the text typeset within it, regardless of the environment in which it
%      is placed
%    - Dropped letters use now the same font as regular text and its height
%      is equivalñent to two typeset rows.  Before it was 2.5, which made
%      typesetting ugly in most cases
%    - Footnotes are not limited now.  Use as many as you want!
%    - A few space is typeset between programmes belonging to different
%      chapters in the list of programmes
%
% New Features
%   - We now include package geometry to center pages properly on the printing
%     medium
%   - Use \lt and \gt if you can't type < and >
%   - Use \defaultparskip to change the space between paragraphs
%   - Use \defaultparindent to change the amount of space at the
%     beginning of each paragraph
%   - Use \listingfont to change the font in which listings are typeset
%   - Captions are now typeset in boldface
%   - The listing environment was rewriten.  Now you can use !escape<commands>
%     to escape to normal mode temporarily.  Listings can also spread over
%     several pages.
%
%     \begin{listing}
%         this is verbatim %&$&/()%
%         \escape<this is \textbf{\underline{not}} verbatim!>
%     \end{listing}
%
%   - Please, use \maketitle to typeset your title page.  We accept commands
%     \title, \subtitle, \author, and \date to typeset it.
%   - We now print crop marks around typeset pages, which can be smaller than
%     the paper on which they are going to be printed.  Please, use *paper to
%     specify the dimensions of the pages you plan on using to bind your book
%     and *page to specify the dimensions of the pages on which you're going
%     to print your book. Notice that 15x24page is available for books whose
%     dimensions are 15cm x 24 cm.
%
%     For instance, if you specify
%
%     \documentclass[15x24paper,a4page]{rc-book}
%
%     this means that your use a4 pages to print your book, but you want to
%     bind it using 15x24 paper.  In this case, crop marks will be drawn on
%     your a4 pages to help you cut them properly.
%
%   - If you don't want to use marginalnotes, please specify nomarginalnotes
%     when you load rc-book.  This will allow you to use the space they have
%     for the body of your text.
%   - Use environment bodywide to typeset text as wide as your printing area.
%     If you're using marginalnotes, this environment allows you to typeset
%     text that spreads beyond a normal line an uses the space available for
%     marginalnotes.  Figures, tables, and the like are now typeset using this
%     environment.
%   - Use \leaderfill to typeset dotted lines that strech automatically.
%   - Use \symbolfont to switch to switch to the manfnt font

% alpha v1.7 2002/11/02
%
% Fixed bugs, I mean... features
%   - Titles, subtitles, and authors can now spread over several lines.
%     All the lines are typeset centered on the page.
%   - No extra page after the cover is typeset.  Before, there was an
%     extra page with "1111" at the top.
%
% New Features
%   - Use \splash to typeset a splash in your cover page.  It allows you
%     to include a picture in the middle of your cover page, for instance.
%   - Use \centerblock{text} to center a block of text.  It works within the
%     the bodywide environment.  \centerline{text} or \begin{center} ...
%     \end{center} do not work well within a bodywide environment.

% alpha v1.8 2003/01/01
%
% Fixed bugs, I mean... features
%   - Multi-letter mathematical identifiers are now typeset propoerly by
%     means of package mathident.sty.  Compare, for instance, how
%     LaTeX typesets $specification, offer$ with and without this
%     package.
%   - \psfigure does not add a white space if figures have wider
%     than .95\linewidth
%
% New Features
%   - Mathident, allfnt and newproof packages have been included
%   - Option doubleisomargin has been added.  With this option, margins
%     are twice as wider.  isomargin is de default option

% alpha v1.9 2003/18/07
%
% Fixed bugs, I mean... features
%   - Program and List of programmes has been changed to Program
%     and List of Programs, respectively
%   - Multiline part/chapter titles are now typeset ragged right
%   - Now, centered blocks do not produce \hbox warnings.
%   - Now, the title page does not produce \hbox warnings.
%
% New Features
%   - A new option called miniabstract has been added.  It typesets
%     abstracts in a minipage that is .80\linewidth width and \small
%     letters.
%   - Variable \abstractsep defines the symbol that separates the
%     abstract from the first section.  It is {\symbolfont \char"26}
%     by default.
%   - A new command called \addcontentslinenonumber has been added.
%     It adds a line to a contents section, but do not includes the
%     page number
%   - Parts do not have page number in the table of contents
%   - A new environment to typeset Z-like schema has been added:
%
%     \begin{scheme}{BirthdayBook}
%         known \colon 2^{NAME} \\
%         birthday \colon NAME \then DATE \\
%     \suchthat
%         known == \mathop{\mathrm{dom}} birthday \\
%     \end{scheme}
%
%     \begin{scheme}[X]{GenericInclusion}
%         s \colon 2^{X} \\
%         includes \colon X \\
%     \suchthat
%         includes(x) \iff x \in s \\
%     \end{scheme}

% alpha v2.0 2003/18/08
%
% Fixed bugs, I mean... features
%   - I forgot to include the miniabstract option in version
%     alpha 1.9 O:)
%   - Multiline chapter titles are now typeset properly flushed
%     right, even in documents with marginal notes
%   - Now, centered blocks do not produce \hbox warnings.
%   - Now, the title page does not produce \hbox warnings.
%   - \subtitle and \splash need not be defined explicitely.  If
%     you don't have a subtitle for you document or a splash
%     screen, just leave this commands undefined.
%   - RC-Book is now compatible with bibliographical styles other
%     than plain.  Enjoy using named.bst, for instance!
%   - Now, \centerblock works well inside body-wide environment
%     if your book uses marginal notes.  Before it didn't typeset
%     its argument using a \bodywith box, but a \textwidth box
%   - Schema now works well inside figures.
%
% New Features
%   - Multiline part titles are now typeset centered
%   - \thanks can now be used outside the title.  It is not typeset
%     as a footnote as before, but on the second page.  Use \makethanks
%     to typeset your thanks note.
%   - Use \dedicatory to define a dedicatory.  Use \makededicatory to
%     typeset it.
%   - In addition to \centerblock, you can now use \leftblock and
%     \rightblock to flush a block of text to the left or to the
%     right, respectively.  It works well in body-wide environments.

% alpha v2.1 2003/09/01
%
% Fixed bugs, I mean... features
%   - A lot of work to fix the space between a rule and the text
%     immediately below or above has been done.  I think now it,
%     finally works well.  I cross my fingers
%   - No more extra space in the list of tables, figures or programs
%     if a chapter does not contain a table, a figure or a program
%   - \textwidth is changed in bodywide environments.  Use it to
%     to find out how much horizontal space is available
%   - \centerblock, \rightblock, and \leftblock now work depending
%     on the horizontal space available.  Before they could be used
%     in bodywide environments only.
%   - Stuff that depends on a page being odd or even to be typeset
%     properly works now well in pages numbered with roman literals.
%     This was the reason why \frontmatter couldn't be used before.
%   - A few minor changes have been made to newproof.sty so that
%     enumerate, itemize or description environments work well inside
%     a proof environment.
%   - \drop works well everywhere!  It produces a 2-line character in
%     any situation.  However, you can't see the result in the .dvi file
%     since I required \specials to resize dropped characters.  Convert
%     your .dvi file into .ps before enjoying the results.
%   - No more duplicated internal labels are produced.
%   - Including an .eps figure does not result in its name being printed
%     on the screen.
%   - No more extra space for the footers is left.  Pages are now
%     altogether symmetric.
%   - The bounding line is now drawn inside the sheet, not outside it.
%
% New features
%   - The euler package is now included automatically.  It defines
%     a math font that combines with Palatino better than the default
%     Computer Modern fonts.  This makes `mathident.sty' useless for
%     RC-BooK.  Keep it, however, since it may be useful with other styles!
%   - Use \institution{text} to add the name of your institution to the title
%   - Now, \suchthat works well in any context
%   - Use \begin[info]{author} text \end{quotation} typeset your
%     favourite quotations
%   - Use \begin{citeverbatim}[info] text \end{citeverbatim} to reproduce
%     a piece of text from other document
%   - A note informing about the version of RC-Book with which a document
%     was compile it now added at the end of the output file.
%   - Use command \zapf to change to the Zapf Chancery font at 12pt.
%   - Divide your document using
%        \covermatter ... Title page, legal page, and stuff like that
%        \frontmatter ... Table of contents, list of figures, abstracts, etc
%        \mainmatter ... The body of your document
%        \backmatter ... Your apendices, bibliography, etc
%   - Miniabstract is no longer supported :(
%   - The first letter of an abstract is dropped by default
%   - 12pt is the default letter size
%   - Use \publisher{text}, \printed{text}, \copytext{text}, \rights{text},
%     \trademarks{text}, \record{text}, and \support{text} to add legal
%     stuff to your document.
%     Notice that \thanks and \makethanks are no longer supported.
%   - Added \url, \path, and \email to typeset URLs, file paths, and
%     e-mail addresses.  It breaks these pieces of text properly.
%   - Use \tab[n] to insert n tabulators.  n = 1 by default
%   - Now you can use \includechapter with only one argument.  In this
%     case, the figures corresponding to that chapter are assumed to be
%     stored in a folder called fig in the same directory where the
%     chapter resides.  For instance \includechapter{chapter5/motivation.tex}
%     includes file motivation.tex from directory chapter5 and assumes that
%     the images are stored in chapter5/fig.  Instead, the command
%     \includechapter[images]{chapter5/motivation.tex} loads file
%     motivation.tex in folder chapter5, but the images from folder
%     images.
%   - Use \makefront to typeset the front of your documents.  This includes
%     the title page, the dedicatory, and the table of contents, figures,
%     tables, and programs.
%   - Use \makeback to typeset the end of your document.  This includes the
%     bibliography and the index.
%   - Enumerations use now roman labels
%   - Use \oldstyle{n} to typeset a number in `old style'.
%   - Use \romanyear to typeset \year in roman numerals
%   - Use \toroman{n} to typeset any number in romans
%   - Inside a listing, you can now use $ to switch to math mode, and
%     \ to call any command, even if it has a parameter.  \escape remains
%     working, but you should not use it a lot since it is obsolete now.
%     For instance, let's define the following macros to typeset remarks
%     and keywords
%   - Long lines in verbatim environments now hang
%
%        \def\remfill{\leaders\hbox to 0.5em{\hss$\cdot$\hss}\hfill}
%        \newcommand{\rem}[1]{$\lhd$\remfill\textit{#1}\remfill$\rhd$}
%        \newcommand{\kw}[1]{\textit{#1}}
%
%     Now, it is easy to typeset a complex IP program, as follows:
%
%        ...
%        \newcommand{\Skip}{\kw{skip}}
%        \newcommand{\Where}{\kw{where}}
%        \begin{listing}[9]
%        \rem{Simple system}
%        SYSTEM :: [P$\mbox{}_1$ $\|$ P$\mbox{}_2$], \Where $\label{x}$
%            P$\mbox{}_1$ :: *[A<> $\to$ \Skip & B<> $\to$ \Skip] $\label{y}$
%            Q$\mbox{}_1$ :: *[A<> $\to$ \Skip & B<> $\to$ \Skip] $\label{z}$
%        \end{listing}
%
%        The system is declared in line~\ref{x}, and the processes in
%        lines~\ref{y} and~\ref{z}.
%        ...
%
%     Notice that \, $, {, or } are quite a lot likely to be special symbols
%     in your listings.  In those cases, you can change them very easily by
%     redefining \listingcatcodes.  For instance, if you need to use \, {,
%     and } quite often, it is a good idea to redefine \listingcatcodes as follows
%
%        \def\listingcatcodes%
%        {%
%            \makeescape\|%
%            \catcode`\$=3%
%            \catcode`\[=1%
%            \catcode`\]=2%
%        }
%
%     Now, you have to type |textit[text] instead of \textit{text} since \, {, or
%     } aren't special characters.  For instance, you would type
%
%        ...
%        \renewcommand{\rem}[1]{/*\remfill\textit{#1}\remfill*/}
%        \begin{listing}[9]
%        |rem[Calculate Kolmogorov's coefficient]
%        float f(int i, int j) {
%            return $i * |sin(i + j)^[|mathbb[C](i, j) |over |mathbb[F](i, j)] * |mathcal[F](i, j)$
%        }
%        |end[listing]
%        ...
%
%     If \, {, }, and $ are all special symbols in your listings, you can change
%     them all.  For instance, the following redefinition
%
%        \def\listingcatcodes%
%        {%
%            \makeescape\|%
%            \catcode`\!=3%
%            \catcode`\(=1%
%            \catcode`\)=2%
%        }
%
%      makes !|mathrm(text)! equivalent to $\mathrm{text}$ in your listings.
%   - In draft mode, the boundingbox of eps figures is drawn explicitly.
%   - Use \midrule[thickness]{length} to typeset horizontal rules that are aligned
%     with the middle of your lines.
%   - Are you bored of typing \^{}, \_, and \_ outside maths.  Use \makemathother
%     right after your \begin{document} and forget about escaping these characters!
%   - \centerblock, \leftblock, and \rightblock have now an optional parameter
%     that allows to control how wide the box they produce is.
%   - Redefine \hintglyph, \warningglyph, or \comparisonglyph to change the
%     symbol displayed be hint, warning and comparison floats.
%   - Use \documenttype{text} to specify the kind of document you're typing.
%
% Known bugs, I mean... features
%   - \mathtt letters are too wide
%   - \drop It doesn't work with accented characters, and still needs some
%     work to adjust the horizontal space it leaves after the letter depending
%     on the size of the current font.
%   - \url, \path or \email can't be used as an argument to another command.
%     In those case, use \urldef{\myurl}\url{http://www.home.com} to define
%     a robust url command and use \myurl instead
%   - Bodywide boxes can't be split between two consecutive pages
%   - \hbadness needs to be set to 10000 to avoid spurious warnings

% alpha v2.2 2003/09/30
%
% Fixed bugs, I mean... features
%   - The optional parameter to citeverbatim is not typeset unless it is provided
%   - Chapters headers without a number didn't have enough space below or
%     above the rules
%   - There was an incompatibility with Spanish babel's package that made
%     some documents in which \xspace was used as the argument to a caption to
%     crash. It's been corrected.
%   - I've found a bug... I mean a feature of Latex.  If a roman-numbered section
%     finishes in an odd page and the next page number is set to 1, then
%     \cleardoublepage does not work well.  I've prepared a workaround!  Covermatter
%     always finishes in an even page!
%
% New features
%   - Use \eg, \ie, \cf, \Cf, \viz, \etal, \viceversa, \adhoc, \reductio, \apriori
%     to typeset common latin expressions homogeneously
%   - Abstracts are typeset on the first page of each chapter.  The first section lies
%     always on the next page.
%   - Quotations are typeset bodywide by default
%   - An empty page is added automatically to every document.
%   - Use \{text} to define the artwork you want to use to illustrate
%     your document.  Use \makeartwork to typeset it.

% alpha v2.3 2003/10/13
%
% New Features
%   - Use \fixspanish in your preamble if you're using babel and Spanish.
%     This avoids ~ and " from being active characters with special meaning.

% alpha v2.4 2003/11/07
%
% Fixed bugs, I mean... features
%   - There was a little problem with the definition of \fixspanish.
%     In the bibliography, for instance, names were typeset without a space
%     between the initials and the surname.  The problem's fixed.
%
% New Features
%   - Now you can use the common natbib bibliographic commands, namely:
%       * \cite{ref} --> [9]
%       * \citeauthor{ref} --> John et al.
%       * \citeauthor*{ref} --> John, Williams, and Roberts.
%       * \citeyear{ref} --> 1990
%       * \citet{ref} John et al. [9]
%       * \cite{ref1, ref2, ref3, ref4} --> [3, 8-12]
%   - Now, \makeback accepts an optional parameter to specify the
%     bibliographic style to be used.  plainnat.bst is the default.
%   - A new bibliographic style called plainnat_sp.bst can now be used
%     with documents written in Spanish.

% alpha v2.5 2003/11/10
%
% Fixed bugs, I mean... features
%   - There was a bug in the abstract environment which caused it not to
%     accept more than two paragraphs.  It's been fixed.
%   - \makeback included plain.bast instead of plainnat.bst
%   - The optional parameter to citeverbatim had a little bug.
%   - Some abstracts weren't typeset on an independent page

% alpha v2.6 2003/11/28
%
% Fixed bugs, I mean... features
%   - Centered pages without header seemed not to be centered because there
%     wasn't a footer to balance the centering routine.  Now the cover, the
%     legal stuff, the art work, the dedicatory, or part pages look fine
%   - The first line of a listing is no longer indented inside itemized
%     environments.
%
% New Features
%   - \RCBooK's been changed into \RCBook.
%   - RC-Book has a new companion called RC-Math to typeset inference rules,
%     transitions, schemes, and so on.  You can use this and forthcoming
%     companions independently from RC-Book.  The scheme environment is no
%     longer part of RC-Book, but of its RC-Math companion.

% alpha v2.7 2003/12/02
%
% Fixed bugs, I mean... features
%   - I've just released two bibliographic styles called rc-nat-es.bst
%     and rc-nat-en.bst to fix a problem with the original style that made
%     the bibliography to leave extra lines between references in some cases.
%     Soon, there'll be only a bst file able to interact with babel to
%     adapt itself to the language selected for the main document.
%
% New Features
%   - Use \makeminutes to typeset the minutes of your document.  You can
%     use \minutestext and \minutesdate to define the text on top of the
%     minutes pages and the date at the bottom.
%     \defaultminutestext{degree}{discipline} and \defaultminutesdate provide
%     standard pieces of text that may well be useful in most cases.
%     Use \boardmember{name \\ position \\ affiliation} to add members to
%     the board that signs minutes of your document.
%   - Use the commands \toprule[thickness]{length} and
%     \bottomrule[thickness]{length} to typeset rules that are aligned to the
%     top or the bottom of your lines.  These commands complement the existing
%     \midrule[thickness]{length}.  The default thickness is now
%     \arrayrulewidth instead of 2pt.

% alpha v2.8 2004/09/01
%
% Fixed bugs, I mean... features
%   - Hints, warnings, and comparisons now read their icons from the RC-BooK
%     installation directory.
%   - If a document had more than two authors, the cover page looked ugly.
%     Multiple authors are now typeset nicely.
%   - Paragraphs inside hints, warnings, and comparisons were not indented
%     properly.  Now the indentation is the same as in the rest of the
%     document.
%   - \list environments didn't work well inside bodywide environment in
%     documents that use marginal notes.
%   - There was a name clash with oz.sty and oz2e.sty that prevented \S
%     marks from appearing when a \ref command was used.  Furthermore,
%     there were problems with using a `proof' environment.  These problems
%     have been fixed.
%   - In previous releases, there was always a list of figures, a list of
%     tables and a list of programs, even if you didn't type a figure, a
%     table, or a program.  Notice that it was a LaTeX bug... I mean a LaTeX
%     feature, not an RC-BooK feature!
%   - There was a little mistake in the definition of \defaultminutestext.
%   - It seems there was a little problem with documents without a \title or
%     \author in some \LaTeX distributions.  May that be another feature?
%
% New Features
%   - Can you remember \fixspanish.  Yeah, it was a must to include this
%     command in the preamble if you wanted Babel to work well in Spanish.  The
%     fix is now applied automatically.  I mean, you needen't include this
%     command in your preamble if your writing in Spanish.  RC-Book detects
%     it automatically, and fixes the problem behind the scenes!
%   - Use \brand{text} to typeset brands.  You could typeset products, but not
%     brands.
%   - Use \vs to typeset versus.  There were a lot of latin expressions, but I
%     forgot `vs.' in previous versions.
%   - You need to change the definition of \installfolder to tell RC-BooK where
%     it's been installed.
%   - There's a new tip-like environment called sidebar.  Redefine
%     \sidebarglyph to change its glyph.
%   - RC-BooK has a new companion called RC-QandA to typeset questions and
%     answers.
%   - The text inside a citeverbatim environment is now indented the same as
%     a standard paragraph.  Previously it was indented 3em.
%   - There's a new companion called RC-Floats to typeset floats.  It includes
%     figures, subfigures, cont'd figures, tables, subtables, cont'd tables,
%     programmes, and the like.  RC-BooK is now mostly float-compatible with
%     LaTeX2e!
%   - Upgrading figures and programs shouldn't be that difficult, but tables
%     are different since their contents weren't typeset using standard
%     \tabular or \tabularx.  Recall that every time you type \\ an \hline
%     command is issued immediately.  To help upgrade table, RC-BooK now
%     provides you with the rctabular environment.  For instance:
%
%     \begin{table}
%        \begin{rctabular}{rX}
%            {Column A & Column B}
%            item a    & item b \\
%            item a    & item b \\
%            item a    & item b \\
%        \end{rctabular}
%        \caption{A table}
%        \label{tab-tab}
%     \end{table}
%
%     Notice that it is mandatory to have an X column at least or otherwise
%     rctabular won't work.  Think of using another tabular environment if you
%     don't need X columns... but that comes at a cost: lines aren't typeset
%     automatically in other tabular environments.  Next release will include
%     better support for tabular environments.
%
%   - \psfigure is now part of RC-Floats.
%   - Previous releases didn't take advantage of Babel's localisation
%     facilities, i.e., RC-BooK was configured to work in an English locale and
%     you had to redefine macros such as \programname if you wanted to typeset
%     a document in, say, Spanish. RC-BooK is now able to localise itself as
%     long as `babel.sty' is included in the preamble. Currently, localisation
%     works with `spanish', `english', `catalan', `francais', and `german',
%     but more languages are to come.  I'm quite sure that the Spanish, English
%     and French translations are right, and the German translations are gonna
%     be right in a few months :), but I'd appreciate if you could lend me a
%     hand with Catalonian and other languages.
%   - `newproof.sty' is no longer included.  Note that RC-Math alpha v0.1
%     includes new functionality to typeset theorems, lemmata, collolaries
%     and the like, as well as proofs to them.  Needless to say, this is
%     localised automatically by RC-BooK!
%   - `allfnt.sty' is no longer included sin the functionality of the listing
%     environment superceeded allfnt's functionality several releases ago.

% alpha v2.9 2005/01/06
%
% Fixed bugs, I mean... features
%   - Latins and other commands that relied on the \lang command didn't work
%     well with the `oz.sty' package.  I've got to rename this command to
%     \barbarism to avoid this problem. See RC-Math alpha 0.2 for further
%     details.  This version should make `oz.sty' or `oz2e,sty' obsolete!
%   - A warning was displayed when fixing problems with Babel and Spanish.
%     However, TeXnicCenter reported it as an error.  The message has been fixed
%     so that TeXnicCenter interprets it correctly.
%   - The localisation support has been improved.  Some labels were not
%     translated correctly into languages other than English, but they work well
%     now.
%   - \citeauthor, \citeauthor*, and \citet didn't display "et al." using the
%     right font.  It now works well.
%   - There were still extra blank lines in the bibliography.  This was due to a
%     problem with float numbers that made the results of a couple of
%     operations different in PIII or PIV computers.  I've patched this, and I
%     hope extra blank lines will dissapear forever from the bibliography.
%   - The definition of \qquad was wrong and it's been fixed.
%   - There was still a little mistake in the font used for \inline.  It's been
%     fixed so that inline text looks exactly the same as in a listing.
%
% New Features
%   - The \tilde command has been removed.  No-one used it, and it seemed to
%     be a problem to typeset mathematical text in Spanish.
%   - Use \advisor to typeset the name of your advisor!
%   - \tab[n] accepts now decimal tabs.
%   - The rctabular environment's been improved a lot.  The syntax is now as
%     follows:
%
%    \begin{rctabular}[width]{columns}
%        {header row}
%        entries
%    \end{rctabular}
%
%    Notice that rctabular accepts now an optional parameter to indicate the
%    size of the tableau.  This is necessary if you use X columns since the
%    default width of a tableau in such cases is 0.95\textwidth.  Note that it
%    is not a must now to use an X column, and in this case, rctabular
%    is able to calculate the size of the tableau automatically.
%
%    There are also new column types, namely: .{n}, and ,{n}.  These columns
%    are useful to type decimal numbers aligned on the decimal point or comma,
%    respectively.  They take a mandatory argument to specify the maximum
%    number of decimal places a number has. (A day, this will be calculated
%    automatically, but that day still has to come.)
%
%    Furthermore, header rows are typeset in boldface and aligned to the center
%    by default.  You needn't specify the style to your headers any more.
%
%    For instance, the following environemnt typesets a table with two numeric
%    columns aligned on the decimal point or comma, respectively:
%
%     \begin{rctabular}{r.{2},{3}} % No X column is necessary
%        {Name & Salary in \EUR{} & $\alpha^\beta$-rank}
%        John    & 1200.20 &  -3,4 \\
%        Mary    & 500.10  &  12,345 \\
%        Melanie & 5.00    & 786,44 \\
%    \end{rctabular}
%
%   - Use the rotate environment to rotate your text.  For instance, if you
%     have a big table that might better be typeset in landscape, use the
%     following piece of LaTeX:
%
%        \begin{figure}
%            \begin{rotate}{90}
%            \begin{rctabular}{cccc}
%                {A & B & C & D}
%                E & F & G & H \\ ...
%            \end{rctabular}
%            \end{rotate}
%            \caption{XXX}
%        \end{figure}
%
%     Notice that you can rotate arbitrary pieces of text, not only tables,
%     including figures.  However, it is not possible to see the result in your
%     .dvi file.  Transform it into .ps or .pdf to see the results.

% alpha v2.10 2006/12/28
%
% New features
%   - Do you have Office 2003 and MiKTeX 2.4 installed?  Enjoy stretching
%     your bitmaps! Aliasing and speckling is no more a problem with non-vectorial
%     images. (To an extent, obviously.) Unfortunately the driver doesn't work well
%     if you use latexpdfm to translate a .dvi file into a .pdf file.  The result
%     is good for printing but horrible for the screen. If you want
%     to get high-quality bitmaps in .pdf, use dvi2ps to tranform you dvi file
%     into PostScript and ps2pdf to transform this into PDF.  The result is
%     quite good!
%   - There is a new companion called RC-LisTinG that includes \inline, \tab,
%     \listingfont, and the listing environment
%   - In draft mode, lines numbers are added automatically to your document.
%   - New macros are available though the dashbox package.
%   - If you're compiling a book with chapters contributed by several authors,
%     then the environement \begin{authorship} text \end{authorship} to typeset
%     their names, affiliations, and the like.
%
% Fixed bugs, I mean... features
%   - X Headers in rctabulars are aligned to the left
%   - \S didn't work when I updated MikTeK.  The problem seems to be that the new
%     Euler package redefines \S to a symbol that maps to a blank character.  The
%     problem seems now to fixed once and forever.
%   - Footnotes work well now.  An update to a package reverted them to symbolic
%     mode.
%   - There was a little problem with \caption and \listoffigures when the latest
%     version of babel was used.  Instead of "Tabla" or "Índice de tablas", "Cuadro"
%     and "Índice de cuadros" was typeset.  This has been fixed.
%   - You may now have up to 99 sections in a chapter and up to 99 subsections
%     per section. We however do not recommend to have so may sections and subsections.
%   - Quotes didn't work well inside \inline.  For instance \inline{"Hi"} produced
%     ''Hi''.  This feature is now corrected.
%   - A few adjustments have been made to \drop so that some letter drop better.

% alpha v2.11 2007/31/08
%
% Refactoring
%   - The rotate environment is now in the rc-floats companion.
%   - \fixspanish removed.  It behaviour is now implemented in the rc-language companion.
%   - You can now use RC-Math with classes other than RC-BooK.
%
% New features
%   - A new option is available: nocrop.  It just executes \crop[off].  By default,
%     cropping is enabled, as in previous versions.
%   - If you try to load oz.sty or oze.sty, you will get an error message.  Please, use
%     RC-Math instead.
%   - Including srcltx in your preamble was a little unportable.  Please, remove this
%     style from your preamble.  RC-BooK will include it if necessary.
%   - \marginalnote command has been removed since it was misleading.  Use the standard
%     \marginpar instead.
%   - Error messages and warning do not provide context information, which is interesting
%     to advanced users who have a good knowledge of LaTeX and RC-BooK internals.  There's
%     a new option called rcdebug that restores context information; it's intended to be
%     used by package developers only.
%   - Tolerance is set to 3000 in order to help typeset manuscripts that contain a lot of
%     inlines.  This works quite well for both normal text and inline text.
%   - Use \EUR{n} to typeset euroes.
%   - Package 'colors' now loads default colour names.
%   - To font used in quotations and the initial letter in the abstracts has changed from
%     Zapf Chancery to Aurical.  There were problems with letters like "ã" and Zapf Chancery
%     using the modern T1 font encoding.  You can redefine \calligraphicfont to change it
%     if you wish.
%
% New companions
%   - RC-Language: this cares of localising both your text and your bibliography
%     automatically.  Please, don't use babel.sty with RC-BooK, but RC-Language.
%   - RC-HyperLink: this hyperlinks the output automatically so that you can
%     navigate through your \refs and \cites.
%   - RC-NatBib: this is RC-BooK's native bibliography style.
%   - RC-Tabular: contains lots of improvements to the rctabular environment.
%
% Fixed bugs, I mean... features
%   - Integer ranges such as $1..2$ were not typeset well in Spanish documents. Such
%     ranges work well now.
%   - The rctabular environment didn't work well within a rotate environment.  It now
%     works well.
%   - The bibliography now adapts automatically to the language selected with the
%     babel package.  A new bst file called rc-natbib.bst is provided, and it is now
%     the default bst file used in \makeback.  rc-natbib.bst replaces the old
%     rc-nat-es.bst and rc-nat-en.bst and it's multilingual!  Note that not all babel
%     languages are supported.
%   - \centering, \raggedright, \raggedleft, \flushright, and \flushleft finally
%     work well inside the body wide environment!
%   - There was a bug in the definitions of \blockright and \blockleft, which used
%     \flushright and \flushleft wrongly.
%   - Line numbers in draft mode are aligned properly, event within body wide
%     environments.
%   - \eg, \cf, etc have been fixed.  The final dot is now a non-ortographical dot,
%     and they are typeset in slanted shape, which looks better.
%   - \textwidth was not wide enough in body wide environments.  Now, it is.
%   - The definition of \defaultparskip was absolutely wrong, and it was the reason for
%     displayed material never being correctly space (above or below).  I've taken 7 years
%     to find this bug!!!
%   - Can you remember the bug in the bibliography? Yes, that bug that outputs an extra
%     blank line in some bibliographical entries... forget about it!
%   - It was sometimes disturbing that the first page of a chapter or contents table
%     didn't have a number.  This has been fixed.
%   - Chapters before the main matter were not hyperlinked well from the contents
%     table.  This has been fixed.
%   - \installfolder has been removed since it's no longer necessary to tell RC-BooK where
%     it was installed.

% alpha v2.12 2011/31/12
%
% New features
%   - If you generate a PDF file using dvipdfmx, it'll be bookmarked.  Furthermore, the
%     PDF title and author will be set properly as well.
%   - \includechapter is no longer supported.  RC-BooK now complies with the standard
%     \include command to include chapters.  Note that if you wanted to create a project
%     tree in WinEdt, you needed to \input the chapters individually at the end of you main
%     document.  If you replace your old \includechapter sentences by \include it should
%     work fine.
%   - There's new command \includepart[running-header]{title}{file} that allows to
%     create a part in your document with the title and optional running header indicated.
%     The contents are read from the file indicated.  Note that this prevents WinEDT from
%     reading the structure of your document :(
%   - The first letter in abstracts and letter dropped using \drop is now typeset using the
%     the normal font instead of a calligraphic font.  It looks more formal.
%   - There's a new environment called legend that is intended to typeset legends inside
%     figures.  It's very simple, but works pretty nice.
%   - Bored of providing default options to RC-BooK?  By default the following options are
%     executed: [nobibnotes, doubleisomargin, nocrop, nomarginalnotes, draft]  That means
%     that you simply need to write \documentclass{rc-book} to request RC-BooK!
%   - There are three new commands called \dontforget, \comment, and \checkthis that are
%     intended to produce annotations while working on a document.  RC-BooK won't provide a
%     means to disable these commands, since I assume that you will eventually erase them
%     before producing the final version of your document.
%   - The ad message at the end of every RC-BooK document now includes the time when the
%     document was compiled. The message has ben changed to make it clear that this class
%     is not publicly available, yet.
%
% Fixed bugs, I mean... features
%   - So many bug fixes... features have been fixed that it does not make sense to
%     list them all here.  Just enjoy them!
%   - Forget about the annoying fleqn and euler warnings!
%   - Previous versions printed out an ad message at the end of every document... after leaving
%     four pages blank.  The message is now printed the sooner as possible.

% alpha v2.13 2012/31/05
%
% New features
%   - There's a new companion in the neighbourhood: RC-Notes.  Commands \dontforget, \comment,
%     and \checkthis have moved to this companion and they have been improved so that they produce
%     notes that are more... professional.  I know this notes are not intended to be in
%     the final version of a document, but... call me perfectionist :)  Note also that these notes
%     do not appear unless the document is compiled in draft model.  They are ignored in final
%     mode. Please, note that you can now include notes wherever you wish, even inside a list or
%     a figure.
%   - There's a new command \attach{file} by means of which you can attach an external file to
%     your PDF output.  Note that the files that are attached are actually embedded into your PDF
%     files, i.e., you need not distribute them.  Files can be of any type, e.g., text files,
%     pictures, PDF documents, videos, and the like.
%   - The typesetting of the date in the last-page message has been improved.  The date is now
%     printed out in full.
%   - There's a new command called \hiddenpart{text}.  It allows to include a hidden part in your
%     document.  A hiddent part is not typeset in your table of contents, but on your PDF document
%     outline.
%
% Fixed bugs, I mean... features
%   - Notes are typeset correctly inside lists, figures, and other environments that reduce the
%     line width.
%   - Times were not typeset properly in the last-page message.  For instance "this document was
%     typeset on 2012/1/28 at 9:3".  This has been fixed.
%   - Graphics are now instructed to produce output for DVIPDFMX, which is the only method that
%     is supported by RC-Book in order to generate PDF files. The quality of images was superb in
%     previous releases of RC-Book... now it's extraordinary!
%   - Lines are paragraphs are separated better, and most pages that previously didn't aligned at
%     the bottom now fit nicely.  Before this fix, you had to change your text a lot of times to
%     make some lines slightly longer or shorter.

% alpha v2.14 2012/08/31
%
% New features
%
%   - Recall that RC-BooK is improving its multi-version support.  There's usually a little confusion
%     with rc-language since you're likely to write \usepackage[english]{rc-language}, which loads
%     the old 2.13 rc-language.sty.  To make things simpler, you can use \uselanguages in your preamble.
%     For instance, the following preamble loads Spanish and English and makes English the default language.
%     Recall that the convention is that the last language you load is the default language LaTeX uses.
%
%           \documentclass{rc-book-2.14}
%
%           \usepackage[latin1]{inputenc}
%           \usepackage[T1]{fontenc}
%           \uselanguage{spanish, english}
%           ...
%
%   - Should you wish RC-BooK to output black links, please, load it as follows:
%
%           \documentclass[blacklinks]{rc-book-2.14}
%
%     This is useful if you're writing a PhD report and do not want to pay for every printed page as
%     if it was a coloured page.
%   - RC-BooK will no longer add a "." automatically at the end of your captions.  This makes your figures
%     more portable to classes that do not add a period automatically.
%   - The interword stretch is now a little wider.  This won't usually have any impact on the
%     output, but if you have a lot of inline code or long urls that stretch out far the right margin,
%     this may help improve the results at the expense of a little more interword space in some places.
%     Remember, RC-BooK can't do magic.. but it may help! WARNING:  The result may look as typeset
%     by MS Word!
%   - Use \smaller and \larger to change the size of the current font relative to its current size.
%   - The default calligraphic font is ECF Tall Paul.  This is more readable than the one in the previous
%     version.
%   - The default behaviour of \psfigure has been changed.  Now it should work well in the majority of
%     cases, which makes \psfigure* of very little use.  Id you've used \psfigure* previously, change it
%     to \psfigure and you'll get excellent results.
%
% Fixed bugs, I mean... features
%   - The PDF outline of a document without parts didn't look well; neither looked well the outline of
%     the bibliography.  These problems have been mended.
%   - A few improvements so that you can include figures that are exactly the size of the line.  Before
%     these figures created a little extra vertical space in floats.
%   - The target of a link is better placed.  Before, it linked to the base of the figures or the text,
%     which was annoying because you had to scroll a little up to see the target.
%   - A simple \section{\small Stuff} would make the previous version crash.  The problem's that a
%     command like \special{pdf:XXX \small} caused TeX to loop forever!  Now, RC-BooK tries to
%     prevent this behaviour.
%   - The quotation environment has been fixed once and for all!  You can now typeset quotations
%     that are longer than a line and RC-BooK breaks them automatically!
%   - Use \settypewriterfont in your preamble to set the listing and the URL font at once.  For
%     instance \settypewriterfont{\sffamily\smaller} works well in many common cases.
%   - The outlines of the back matter output by \makeback do not look well in PDF because they are
%     embedded in the last part of the document. This has been mended.
%   - Since version 2.13, RC-BooK allows several versions to co-exists in your instalation.
%     Unfortunately, the language and the input ecnoding can't be handled automatically by RC-BooK,
%     i.e., you must load RC-Language in your main file.  As a conclusion, rc-language.sty is
%     confusing since you don't know which version will be loaded if you have serveral versions of
%     RC-BooK installed.  To prevent this name clash, rc-language.sty will be renamed to
%     rc-language-x.y.sty from now on, where x.y is the corresponding version number.  For instance,
%     use the following command in your preamble if you're using RC-BooK 2.14 and wanna use English
%     as your main language and spanish in some passages:
%
%       \usepackage[spanish,english]{rc-language-2.14}
%
%     Since the idea is that every package in RC-BooK be as reusable as possible, I've used this
%     naming style with the other companions.  I mean, to request rc-notes, you need use the following
%     command:
%
%       \usepackage[spanish,english]{rc-notes-2.14}
%
%     From now on, if you don't specy a version, you'll load version 2.13 by default.  Take a look at
%     the new \uselanguages command in this version!

\NeedsTeXFormat{LaTeX2e}[1995/12/01]

\def\rc@majorversion{2}
\def\rc@minorversion{14}
\def\rc@versiondate{2012/08/31}

%\def\installfolder{C:/Docume~1/AllUse~1/Documents/SH3731~1/tex/latex/misc/rc-book}
%\def\installfolder{}

\ProvidesClass{rc-book-2.14}
     [\rc@versiondate\space RC-Book alpha \rc@majorversion.\rc@minorversion\space Copyright (C) 2000-2012 The Distributed Group]

% Included packages

\AtBeginDocument{
    % this must be loaded after any languaghe related package, in order to deal with active characters appropriatedly
    \RequirePackage{xspace}
}

\RequirePackage{ifthen}
\RequirePackage[dvips,final]{graphicx}
\RequirePackage{makeidx}
\RequirePackage{tabularx}
\RequirePackage[usenames,dvipsnames,table]{xcolor}
\RequirePackage{url}
\RequirePackage{lineno}
\RequirePackage{dashbox}

%\RequirePackage{hyperref}
%\RequirePackage{named}%%%%   CREO que no sirve pa na
%\RequirePackage{amssymb}
%\RequirePackage{amsfonts}
%\RequirePackage{latexsym}
%\RequirePackage[debugshow,infoshow]{tabularx}

%\let\rc@originalmkpream\@mkpream

%\RequirePackage[usenames,dvipsnames]{color}
%\RequirePackage{colortbl}
%\RequirePackage{allfnt}
%\RequirePackage{newproof}
%\RequirePackage{ogonek}
%\RequirePackage[mathcal,mathbf]{euler}
%\RequirePackage{mathident}
%\RequirePackage{dcolumn}
%\RequirePackage{array}


% Load languages

\def\loadlanguages#1{%
    \RequirePackage[#1]{rc-language-2.14}
}
\@onlypreamble\loadlanguages

% LaTeX fonts: http://www.tug.dk/FontCatalogue/allfonts.html

% Calligraphic font.  Before selecting a font, please, make sure
% that you can see a complete enough charset:
%
%     \bgroup
%         \calligraphicfont\noindent
%         1234567890 \\
%         abcdefghijklmnopqrstuvwxyz \\
%         ABCDEFGHIJKLMNOPQRSTUVWXYZ \\
%         áéíóú \\
%         ÁÉÍÓÚ \\
%         àèìòù \\
%         ÀÈÌÒÙ \\
%         äëïöü \\
%         ÄËÏÖÜ \\
%         ñç \\
%         ÑÇ \\
%         ºª \\
%         !"·\$\%\&/()=?¿ \\
%         \textbackslash @\# \\
%         \{\}[] \\
%         ,.-;:\_ \\
%     \egroup

%\usepackage{rotunda}
%\let\calligraphicfont=\rtndfamily  % No accents :(

\usepackage{aurical}
% \let\calligraphicfont=\Fontauri
 \let\calligraphicfont=\Fontskrivan
% \let\calligraphicfont=\Fontlukas

%\usepackage{emerald}
% \let\calligraphicfont=\ECFJD
% \def\calligraphicfont{\ECFJD\smaller}
% \let\calligraphicfont=\ECFTallPaul
%\def\calligraphicfont{\ECFTallPaul\larger\larger}

% Typewriter font

\newtoks\@typewriterfont
\@typewriterfont={}
\def\settypewriterfont#1{%
    \@typewriterfont={#1}%
}
\@onlypreamble\settypewriterfont

\AtBeginDocument{
    \def\listingfont{\the\@typewriterfont}
    \let\UrlFont=\listingfont
}

% Flush the bottom of the pages

\flushbottom

% Set up a few counters, and lengths

\newcounter{part}
\newcounter{chapter}
\setcounter{chapter}{-1000}
\newcounter{section}[chapter]
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]

\newlength{\defaultparskip}
%\setlength{\defaultparskip}{10pt plus 3pt minus 3pt}%  HERE!!!!!
%\setlength{\defaultparskip}{10pt plus 1pt}
\setlength{\defaultparskip}{10pt plus 3pt minus 7pt}
\setlength{\parskip}{\defaultparskip}

\newlength{\defaultparindent}
\setlength{\defaultparindent}{\parindent}
\parindent=\defaultparindent

% Set up a few \ifs

\newif\if@marginalnotes
\def\@marginalnotestrue{\let\if@marginalnotes\iftrue}
\def\@marginalnotesfalse{\let\if@marginalnotes\iffalse}

\newif\if@isomargin
\def\@isomargintrue{\let\if@isomargin\iftrue}
\def\@isomarginfalse{\let\if@isomargin\iffalse}

\newif\if@draft
\def\@drafttrue{\let\if@draft\iftrue}
\def\@draftfalse{\let\if@draft\iffalse}

\newif\if@firstsec
\def\@firstsectrue{\let\if@firstsec\iftrue}
\def\@firstsecfalse{\let\if@firstsec\iftrue}

\newif\if@bodywide
\def\@bodywidetrue{\let\if@bodywide\iftrue}
\def\@bodywidefalse{\let\if@bodywide\iffalse}

\newif\if@tip
\def\@tiptrue{\let\if@tip\iftrue}
\def\@tipfalse{\let\if@tip\iffalse}

\newif\if@wideoddpage
\def\@oddpagetrue{\let\if@wideoddpage\iftrue}
\def\@oddpagefalse{\let\if@wideoddpage\iffalse}

\newif\if@cropping
\def\@croppingtrue{\let\if@cropping\iftrue}
\def\@croppingfalse{\let\if@cropping\iffalse}

%\newif\if@miniabstract
%\def\@miniabstracttrue{\let\if@miniabstract\iftrue}
%\def\@miniabstractfalse{\let\if@miniabstract\iffalse}
%\@miniabstractfalse

\newif\if@bibnotes
\def\@bibnotestrue{\let\if@bibnotes\iftrue}
\def\@bibnotesfalse{\let\if@bibnotes\iffalse}

\@isomargintrue\@marginalnotestrue\@draftfalse
\@bodywidefalse\@tipfalse\@bibnotestrue\@oddpagetrue


% RC-BooK Companions %%%%%%%%%%%%%%

% Think of moving this to AtBeginDocument!

%\RequirePackage{rc-listing}
\RequirePackage{rc-math-2.14}
\RequirePackage{rc-qanda-2.14}
\RequirePackage{rc-floats-2.14}
\RequirePackage{rc-tabular-2.14}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{legend}{%
    \trivlist\item[]
}{%
    \endtrivlist
}

\newcounter{streamcount}
\newcommand{\attach}[1]{%
    %\mbox{}%
    \hspace*{5.5pt}%
    \special{pdf:fstream @stream\arabic{streamcount} (#1)}%
    \special{pdf:ann width 7bp height 7bp
        <<
            /Type /Annot /Subtype /FileAttachment
            /FS <<
                    /Type /Filespec /F (#1) /EF << /F @stream\arabic{streamcount} >>
                >>
            /Name /PushPin
        >>
    }%
    \stepcounter{streamcount}%
    \hspace*{-5.5pt}
    %\hyperlink{#1}{\raisebox{1pt}{\ensuremath{\bigcirc}}}%
    \raisebox{1pt}{\ensuremath{\bigcirc}}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\let\xfbox=\fbox
%\long\def\fbox#1{\fboxsep=0pt\fboxrule=0.04pt\xfbox{#1}}

\def\setfboxlengths{%
    \fboxsep=0.00pt%
    \fboxrule=0.04pt%
}

\@ifpackageloaded{dashbox}{%
    \setlength{\dashlength}{4pt}%
    \setlength{\dashdash}{2pt}%
    \def\rc@fbox#1{\bgroup\setfboxlengths\dbox{#1}\egroup}%
}{%
    \def\rc@fbox#1{\bgroup\setfboxlengths\fbox{#1}\egroup}%
}

\def\shbox#1{%
    \bgroup%
        \setbox#1=\hbox{%
            \rc@fbox{%
                \copy#1%
                \kern -\wd#1%
                \hbox to \wd#1{%
                    %\leaders\hrule height 0.04pt\hfill%
                    \leaders\hbox{\rule[0pt]{2pt}{0.04pt}\hbox to 2pt{}}\hfill\kern-4pt%
                }%
            }%
        }%
        \box#1%
    \egroup%
}

\def\svbox#1{%
    \bgroup%
        \setbox#1=\vbox{%
            \rc@fbox{%
                \copy#1%
                \kern -\wd#1%
                \hbox to \wd#1{%
                    \leaders\hrule height 0.04pt\hfill%
                }%
            }%
        }%
        \box#1%
    \egroup%
}


\AtBeginDocument{%
    \@ifpackageloaded{rc-language-2.14}%
    {%
        \relax%
    }%
    {%
        \errhelp{Please, use \loadlanguages{l1, l2, ..., ln} in your preamble.}%
        \errmessage{No language was selected in the preamble}%
    }%

    \ifthenelse{\equal{\languagename}{english}}
    {
        \RequirePackage{eurosym}
    }
    {
        \RequirePackage[right]{eurosym}
    }

%    \let\@rc@savedot=\dot%
%    \@ifpackageloaded{oz}{\let\dot=\undef}{}%
%    \@ifpackageloaded{oz2e}{\let\dot=\undef}{}%
%    \@ifpackageloaded{oz}{\fixoz}{}%
%    \@ifpackageloaded{oz2e}{\fixoz}{}%
%    \RequirePackage[mathcal,mathbf]{euler}%

    %\if@draft\def\linenumberfont{\usefont{OML}{\rmdefault}{m}{n}\tiny}\pagewiselinenumberss\switchlinenumbers\linenumbers\fi%

    \if@draft%
        \linenumbersep=3pt%
        %\det\makeLineNumber{%
            %\hss%
            %\linenumberfont%
            %\LineNumber%
            %\hskip\linenumbersep%
            %\if@bodywide%
            %    \if@wideoddpage%
            %    \else
            %        \hskip\marginalwidth%
            %    \fi%
            %\fi%
        %}
        \def\makeLineNumberLeft{%
            \hss%
            \linenumberfont%
            \LineNumber%
            \hskip\linenumbersep%
            \if@bodywide%
                \if@wideoddpage%
                \else
                    \hskip\marginalwidth%
                \fi%
            \fi%
        }
        \def\makeLineNumberRight{%
            \hskip\textwidth%
%            \if@bodywide%
%                \if@wideoddpage%
%                    +\hskip\marginparsep+%
%                    !\hskip\marginalwidth!%
%                \fi%
%            \fi%
            \hskip\linenumbersep%
            \linenumberfont%
            \LineNumber%
            \hss%
        }
        \def\linenumberfont{%
            \usefont{OML}{\rmdefault}{m}{n}\tiny%
        }%
        \pagewiselinenumbers%
        \switchlinenumbers%
        \linenumbers%
        \linenumberdisplaymath%

        % To typeset the index in two colums with line numbers (Doesn't work with marginalnotes, but well)
        %BEGIN
        \setpagewiselinenumbers
        \columnwiselinenumberstrue
        \realpagewiselinenumbers
        %END
    \fi%

    \hbadness=10000
    \vbadness=10000
    \newdimen\defaultdisplayskip
    \defaultdisplayskip=2pt\relax%
    \abovedisplayskip=\defaultdisplayskip%
    \belowdisplayskip=\defaultdisplayskip%
    \topsep=\defaultdisplayskip%
    \partopsep=0pt%
    \listparindent=\defaultparindent%
    \vfuzz2pt % Don't report over-full v-boxes if over-edge is small
    \hfuzz2pt % Don't report over-full h-boxes if over-edge is small

    \let\itshape\slshape

    \def\ps@empty{%
        \let\@mkboth\@gobbletwo%
        \let\@oddhead\@empty%
        \let\@oddfoot\@empty%
        \let\@evenhead\@empty%
        \let\@evenfoot\@empty%
    }

    \def\ps@plain{%
        \let\@mkboth\@gobbletwo%
        \let\@oddhead\@empty%
        \def\@oddfoot{\reset@font\hfil\thepage\hfil}%
        \let\@evenhead\@empty%
        \let\@evenfoot\@oddfoot%
    }

    \def\pagestyle#1{%
        \@ifundefined{ps@#1}%
            \undefinedpagestyle%
        {\@nameuse{ps@#1}}%
    }

    \def\thispagestyle#1{%
        \@ifundefined{ps@#1}%
            \undefinedpagestyle%
            {\global\@specialpagetrue\gdef\@specialstyle{#1}}%
    }

}

\RequirePackage[mathcal,mathbf]{euler}%
%\RequirePackage{mathpazo}%
%\RequirePackage{mathrsfs}%

\def\to@month@name#1{%
    \ifnum#1=1January%
    \else\ifnum#1=2February%
    \else\ifnum#1=3March%
    \else\ifnum#1=4April%
    \else\ifnum#1=5May%
    \else\ifnum#1=6June%
    \else\ifnum#1=7July%
    \else\ifnum#1=8August%
    \else\ifnum#1=9September%
    \else\ifnum#1=10October%
    \else\ifnum#1=11November%
    \else\ifnum#1=12December%
    \else\@latex@error{#1 is not a month number}%
    \fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi%
}
\newcount\currenthour
\newcount\currentminute
\newcount\currentresidual
\def\RCBooKContactMessage{%
    {\calligraphicfont%
    %\to@month@name{1}\space\to@month@name{2}\space\to@month@name{3}\space\to@month@name{4}\space\to@month@name{5}\space\to@month@name{6}\space\to@month@name{7}\space\to@month@name{8}\space\to@month@name{9}\space\to@month@name{10}\space\to@month@name{11}\space\to@month@name{12}\space
    This document was typeset on\space%
    \to@month@name{\the\month}\space\the\day, \the\year\space \space%
    using class {\normalfont\small\RCBook~$\alpha$\rc@majorversion.\rc@minorversion}\space%
    for {\normalfont\small\LaTeX$_{2\epsilon}$}. As of the time of writing this\space%
    document, this class is not publicly available. Only\space%
    members of \hyperlink{http://www.tdg-seville.info}{The Distributed Group (TDG)} and the \hyperlink{http://www.gca.unijui.edu.br}{Applied Computing Research Group (GCA)} are allowed to typeset their documents using this class.}
}

\AtEndDocument{%
    \cleardoublepage%
    \markboth{}{}%
    \mbox{}%
    \pagestyle{empty}%
    \vfill%
    \begin{bodywide}[ad]
        \centerblock{\RCBooKContactMessage}
    \end{bodywide}
}

\AtEndOfPackage{%
    \if@draft
        \IfFileExists{srcltx.sty}{\RequirePackage[active]{srcltx}}{\relax}
    \fi

    % Geometry
    \if@isomargin%
        %\RequirePackage[footskip=0pt,heightrounded,margin=0.12\textwidth,marginparsep=1.5em,centering,includeall\RC@marginparwidth@param]{geometry}%
        \RequirePackage[heightrounded,margin=0.12\textwidth,marginparsep=1.5em,centering,includeall\RC@marginparwidth@param]{geometry}%
    \else%
        % showframe
        %\RequirePackage[footskip=0pt,heightrounded,margin=0.24\textwidth,marginparsep=1.5em,centering,includeall\RC@marginparwidth@param]{geometry}%
        \RequirePackage[showframe=false,heightrounded,margin=0.24\textwidth,marginparsep=1.5em,centering,includeall\RC@marginparwidth@param]{geometry}%
    \fi%

    % Cropping
    \RequirePackage[\RC@actual@page,center,dvips,axes]{crop}
    \cropdef[\RC@crop@info]\RC@crop@ul\RC@crop@ur\RC@crop@ll\RC@crop@lr{rcrop}
    \if@cropping
        \crop[font=\small\sffamily,rcrop]
    \else
        \crop[off]
    \fi

    %\marginparsep=12pt plus 0pt minus 0pt
    \newlength\marginalwidth
    \marginalwidth\marginparsep
    \advance\marginalwidth by \marginparwidth

    \newlength\bodywidth
    \bodywidth=\textwidth
    \advance\bodywidth by \marginalwidth

    \parskip=\defaultparskip

    \hsize=\textwidth % DON'T REMOVE THIS LINE

    \setcounter{bodywide@label@no}{0}
%    \setcounter{rc@current@page@number}{1}

    % Enumerates have roman labels

    \def\theenumi{\roman{enumi}}

    % Bibliography
    \newenvironment{thebibliography}{}{}

    %\RequirePackage[square,numbers,sort&compress]{natbib}
    %     \if@bibnotes
    %         \RequirePackage[showall,square,numbers,sort&compress,comma]{rc-natbib-2.14}
    %     \else
    %         \RequirePackage[square,numbers,sort&compress,comma]{rc-natbib-2.14}
    %     \fi

    \RequirePackage[square,numbers,sort&compress,comma]{rc-natbib-2.14}

    \newdimen\bibindent
    \setlength\bibindent{1.5em}

    \gdef\bibitem{%
        \prepare@wide@margins[]{bib}%
        %\let\xxxbibpar\par%
        %\def\par{\pagelabel{\bodywide@label}\let\par\xxxbibpar\par}%
        \pagelabel{\bodywide@label}%
        \@ifnextchar[{\@lbibitem}{%
            %\@bibitem%
            \global\NAT@stdbsttrue%
            \stepcounter{NAT@ctr}%
            \@lbibitem[\arabic{NAT@ctr}]%
        }%
    }


    \def\@lbibitem[#1]#2{%
      \if\relax\@extra@b@citeb\relax\else
        \@ifundefined{br@#2\@extra@b@citeb}{}{%
         \@namedef{br@#2}{\@nameuse{br@#2\@extra@b@citeb}}%
        }%
      \fi
      \@ifundefined{b@#2\@extra@b@citeb}{%
       \def\NAT@num{}%
      }{%
       \NAT@parse{#2}%
      }%
      \def\NAT@tmp{#1}%
      \expandafter\let\expandafter\bibitemOpen\csname NAT@b@open@#2\endcsname
      \expandafter\let\expandafter\bibitemShut\csname NAT@b@shut@#2\endcsname
      \@ifnum{\NAT@merge>\@ne}{%
       \NAT@bibitem@first@sw{%
        \@firstoftwo
       }{%
        \@ifundefined{NAT@b*@#2}{%
         \@firstoftwo
        }{%
         \expandafter\def\expandafter\NAT@num\expandafter{\the\c@NAT@ctr}%
         \@secondoftwo
        }%
       }%
      }{%
       \@firstoftwo
      }%
      {%
       \global\advance\c@NAT@ctr\@ne
       \@ifx{\NAT@tmp\@empty}{\@firstoftwo}{%
        \@secondoftwo
       }%
       {%
        \expandafter\def\expandafter\NAT@num\expandafter{\the\c@NAT@ctr}%
        \global\NAT@stdbsttrue
       }{}%
       \bibitem@fin
       \item[\hfil\NAT@anchor{#2}{\NAT@num}]%
       %\item[\hfil\@biblabel{\NAT@num}\setbox7=\hbox{\raise1\baselineskip\hbox{\hyper@natanchorstart{#2\@extra@b@citeb}[2\@extra@b@citeb]\hyper@natanchorend}}\hbox{\wd7=0pt\ht7=0pt\dp7=0pt\box7}]%
       \global\let\NAT@bibitem@first@sw\@secondoftwo
       \NAT@bibitem@init
      }%
      {%
       \NAT@anchor{#2}{}%
       \NAT@bibitem@cont
       \bibitem@fin
      }%
      \@ifx{\NAT@tmp\@empty}{%
        \NAT@wrout{\the\c@NAT@ctr}{}{}{}{#2}%
      }{%
        \expandafter\NAT@ifcmd\NAT@tmp(@)(@)\@nil{#2}%
      }%
    }%

    \gdef\newblock{\hskip .11em\@plus.33em\@minus.07em}
    \let\@openbib@code\@empty

    \gdef\thebibliography#1{%
        \@partlevel=0%
        \chapter{\bibname}%
        \markboth{\bibname}{\bibname}%
        %\thispagestyle{plain}%
        \bgroup%
            \list{\@biblabel{\arabic{NAT@ctr}}}%
                {%
                    %\@bibsetup{#1}%
                    \setcounter{NAT@ctr}{0}%
                    \usecounter{NAT@ctr}%
                    \settowidth\labelwidth{\@biblabel{#1}}%
                    \leftmargin\labelwidth%
                    \advance\leftmargin\labelsep%
                }%
                \sloppy%
                \clubpenalty=5000%
                \@clubpenalty \clubpenalty%
                \widowpenalty=5000%
                \sfcode`\.=\@m\relax%
    %                \let\citeN\cite%
    %                \let\shortcite\cite%
    %                \let\citeasnoun\cite%
        }

    \gdef\endthebibliography{%
                \def\@noitemerr{\PackageWarning{natbib}{Empty `thebibliography' environment}}%
            \endlist%
            \vskip-\lastskip%
        \egroup%
    }%

    \if@draft%
        \RequirePackage{rc-hyperlink-2.14} % Make sure this is the last required package
    \else%
        \RequirePackage[final]{rc-hyperlink-2.14} % Make sure this is the last required package
    \fi%

    \RequirePackage{rc-listing-2.14}%  Load RC-Listing after RC-Hyperlink or otherwise labels inside a listing won't be hyper-referenced well!

    \RequirePackage{rc-notes-2.14}%  Load RC-Listing after RC-Hyperlink or otherwise labels inside a listing won't be hyper-referenced well!
}

% Needed to crop pages properly

\def\RC@crop@ul{%
    \picture(0,0)
        \unitlength1pt\thinlines
        \put(0,0){\line(-1,0){30}}
        \put(0,0){\line(0,1){30}}
        \put(-30,0){\circle*{10}}
        \put(0,30){\circle*{10}}
        \multiput(10, 0)(0, -20){10}{\line(0,-1){10}}
        \put(0,0){\line(1,0){\strip@pt\paperwidth}}
        \put(0,0){\line(0,-1){\strip@pt\paperheight}}
    \endpicture%
}

\def\RC@crop@ur{%
    \picture(0,0)
        \unitlength1pt\thinlines
        \put(0,0){\line(1,0){30}}
        \put(0,0){\line(0,1){30}}
        \put(30,0){\circle*{10}}
        \put(0,30){\circle*{10}}
    \endpicture%
}

\def\RC@crop@ll{%
    \picture(0,0)
        \unitlength1pt\thinlines
        \put(0,0){\line(-1,0){30}}
        \put(0,0){\line(0,-1){30}}
        \put(-30,0){\circle*{10}}
        \put(0,-30){\circle*{10}}
        \multiput(10, 0)(0, 20){10}{\line(0,1){10}}
    \endpicture%
}

\def\RC@crop@lr{%
    \picture(0,0)
        \unitlength1pt\thinlines
        \put(0,0){\line(1,0){30}}
        \put(0,0){\line(0,-1){30}}
        \put(30,0){\circle*{10}}
        \put(0,-30){\circle*{10}}
        \put(0,0){\line(-1,0){\strip@pt\paperwidth}}
        \put(0,0){\line(0,1){\strip@pt\paperheight}}
    \endpicture%
}

\def\RC@crop@info{%
  {%
    \global\advance\CROP@index\@ne
    \hskip10\p@
    \advance\paperwidth-20\p@
    \raise40\p@\vbox to\z@{%  debería depender de lo que hay dentro
        \centering%
        \hsize\paperwidth%
        \vss%
        \normalfont%
        \let\protect\relax%
        \CROP@font{%
            \tabular[t]{c}%
                \ignorespaces%
                \@title\\%
                \ifx\@subtitle\empty%
                \else%
                    \@subtitle\\%
                \fi%
                 %\tabular[t]{l}\@author\endtabular \\%
                ``\jobname.tex''\hskip20pt%
                \the\year/\the\month/\the\day\hskip20pt%
                \CROP@time\hskip20pt%
                page~\thepage~(\#\the\CROP@index)%
            \endtabular%
            %\strut
        }%
    }%
  }%
}

%\def\cleardoublepage{%
%    \clearpage%
%    \if@twoside
%        \ifodd\c@page\else
%            \hbox{}\newpage%
%            \if@twocolumn%
%                \hbox{}\newpage%
%            \fi%
%        \fi%
%    \fi%
%}

% Fix problems with oz.sty and oz2e.sty

%\let\rc@saveproof=\proof
%\let\rc@saveendproof=\endproof
%\let\hbar=\undef

%\def\fixoz{%
%    \@latex@warning{Fixing problems with `oz.sty' and `oz2e.sty'}%
%    \let\proof=\rc@saveproof%
%    \let\endproof\rc@saveendproof%
%    %\let\dot=\@rc@savedot
%}%

% Please, record indexes

\makeindex

% Set up default font family

% cmr     Computer Modern Roman
% cmss    Computer Modern Sans
% cmtt    Computer Modern Typewriter
% cmm     Computer Modern Math Italic
% cmsy    Computer Modern Math Symbols
% cmex    Computer Modern Math Extensions
% manfnt  Manual Font
% ptm     Adobe Times
% phv     Adobe Helvetica
% pcr     Adobe Courier
% pun     Univers
% ppl     Palatino
% pagk    AvantGarde-Book
% pagd    AvantGarde-Demi
% pbk     Bookman
% put     Utopia
% pop     Optima
% pnc     New Century Schoolbook
% pzc     ZapfChancery
% pzd     ZapfDingbats
% rpad    Garamond

\renewcommand{\sfdefault}{phv}
\renewcommand{\rmdefault}{ppl}
\renewcommand{\ttdefault}{pcr}
\renewcommand\familydefault{\rmdefault}

\font\symbolfont=manfnt

\font\zapf=pzcmi at 12pt

\def\smaller{\ifx\@currsize\Huge \protect\huge \else
              \ifx\@currsize\huge \protect\LARGE \else
               \ifx\@currsize\LARGE \protect\Large \else
                \ifx\@currsize\Large \protect\large \else
                 \ifx\@currsize\large \protect\normalsize \else
                  \ifx\@currsize\normalsize \protect\small \else
                   \ifx\@currsize\small \protect\footnotesize \else
                    \ifx\@currsize\footnotesize \protect\scriptsize \else
                       \protect\tiny
                    \fi\fi\fi\fi\fi\fi\fi\fi}

\def\larger{\ifx\@currsize\tiny \protect\scriptsize \else
              \ifx\@currsize\scriptsize \protect\footnotesize \else
               \ifx\@currsize\footnotesize \protect\small \else
                \ifx\@currsize\small \protect\normalsize \else
                 \ifx\@currsize\normalsize \protect\large \else
                  \ifx\@currsize\large \protect\Large \else
                   \ifx\@currsize\Large \protect\LARGE \else
                    \ifx\@currsize\LARGE \protect\huge \else
                       \protect\Huge
                    \fi\fi\fi\fi\fi\fi\fi\fi}

% Fix the interword spacing:

%     \begin{description}
%       \item[slant] \the\fontdimen1\font
%       \item[interword space] \the\fontdimen2\font
%       \item[interword stretch] \the\fontdimen3\font
%       \item[interword shrink] \the\fontdimen4\font
%       \item[extra space] \the\fontdimen7\font
%       \item[xspaceskip] \the\xspaceskip
%       \item[hyphenchar] \the\hyphenchar\font
%     \end{description}

\AtBeginDocument{
     \pretolerance=-1
     \tolerance=3000
     \hyphenpenalty=-1
     \exhyphenpenalty=-1

     \spaceskip=\fontdimen2\the\font
     \advance\spaceskip by 0em plus 2em minus 0.10em

     \xspaceskip=\fontdimen7\the\font
     \advance\xspaceskip by .25em plus .33em minus .02em
}

% Indent first line of each paragraph

\let\@afterindentfalse\@afterindenttrue
\@afterindenttrue

%\everypar{\if@drop \@dropfalse X \fi}

% A few useful shorthands

\newcommand{\RCBook}
{%
    R%
    \kern-.1667em\raise.25ex\hbox{C}%
    \kern-.25em\raise.25ex\hbox{--}%
    B%
    \lower.5ex\hbox{O}%
    \kern-.425em\raise.5ex\hbox{O}%
    \kern-.4em\lower.5ex\hbox{K}%
    \xspace%
}

%\newcommand{\smalltt}[1]{{\usefont{T1}{pcr}{m}{n} #1}}
\newcommand{\product}[1]{{\scshape #1}}
\newcommand{\brand}[1]{{\scshape #1}}
%\newcommand{\barbarism}[1]{{\itshape #1}}
%\newcommand{\path}[1]{{\underline{\sffamily #1}}}
\newcommand{\option}[1]{{\itshape #1}}
\newcommand{\keystroke}[1]{{\fbox{\sffamily #1}}}
\newcommand{\blank}{\ensuremath{\llcorner\!\!\lrcorner}}
%\renewcommand{\tilde}{\mbox{\~{}}}
\newcommand{\qt}{\mbox{"{}}}
\newcommand{\lt}{\mbox{$<$}}
\newcommand{\gt}{\mbox{$>$}}
\newcommand{\bs}{\ensuremath{\backslash}\if@listing\,\fi}
\newcommand{\oldstyle}[1]{{\usefont{OML}{\rmdefault}{m}{n} #1}}

\newcommand{\barbarism}[1]{{\slshape #1}\/}

\newcommand{\eg}{\barbarism{e.g.\@}\xspace}
\newcommand{\ie}{\barbarism{i.e.\@}\xspace}
\newcommand{\cf}{\barbarism{cf.\@}\xspace}
\newcommand{\Cf}{\barbarism{Cf.\@}\xspace}
\newcommand{\viz}{\barbarism{viz.\@}\xspace}
\newcommand{\etal}{\barbarism{et~al.\@}\xspace}
\newcommand{\viceversa}{\barbarism{vice versa}\xspace}
\newcommand{\adhoc}{\barbarism{ad hoc}\xspace}
\newcommand{\reductio}{\barbarism{reductio ad absurdum}\xspace}
\newcommand{\apriori}{\barbarism{a priori}\xspace}
\newcommand{\vs}{\barbarism{vs.\@}\xspace}

\def\romanyear{\uppercase\expandafter{\romannumeral\year}}
\def\toroman#1{\uppercase\expandafter{\romannumeral #1}}

\def\quadwidth{1em}
\def\quad{\hskip \quadwidth\relax}
\def\qquad{\quad\quad}

\def\sidebarglyph{%
%    \IfFileExists{\installfolder fig/sidebar.eps}%
    \IfFileExists{rc-book-2.14/fig/sidebar.eps}%
%        {\includegraphics[width=3em]{\installfolder fig/sidebar.eps}}%
        {\includegraphics[width=3em]{rc-book-2.14/fig/sidebar.eps}}%
        {{\symbolfont\char'044}}%
}

\def\hintglyph{%
%    \IfFileExists{\installfolder fig/hint.eps}%
    \IfFileExists{rc-book-2.14/fig/hint.eps}%
%        {\includegraphics[width=3em]{\installfolder fig/hint.eps}}%
        {\includegraphics[width=3em]{rc-book-2.14/fig/hint.eps}}%
        {{\symbolfont\char'177}}%
}

\def\warningglyph{%
%    \IfFileExists{\installfolder fig/warning.eps}%
    \IfFileExists{rc-book-2.14/fig/warning.eps}%
%        {\includegraphics[width=3em]{\installfolder fig/warning.eps}}%
        {\includegraphics[width=3em]{rc-book-2.14/fig/warning.eps}}%
        {{\symbolfont\char'177}{\symbolfont\char'177}}%
}

\def\comparisonglyph{%
    \IfFileExists{\installfolder rc-book-2.14/fig/comparison.eps}%
        {\includegraphics[width=3em]{\installfolder rc-book-2.14/fig/comparison.eps}}%
        {{\symbolfont\char'044}}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \pagelabel{label} stores the arabic number of the page in which label is found.

%\def\pagelabel#1{\label{#1}}

%\newcommand\rc@new@label[3]{%
%    %\typeout{#1@#2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1}%
%    \@ifundefined{#1@#2}%
%    \relax%
%    {%
%        \gdef\@multiplelabels{\@latex@warning@no@line{There were multiply-defined labels}}%
%        \@latex@warning@no@line{Label `#2' SHOULD NOT BE multiply defined}%
%    }%
%    \global\@namedef{#1@#2}{#3}%
%}

%\newcounter{rc@current@page@number}
%
%\newif\if@reset@current@page
%\def\@reset@current@pagetrue{\let\if@reset@current@page\iftrue}
%\def\@reset@current@pagefalse{\let\if@reset@current@page\iffalse}
%\@reset@current@pagetrue
%
%\let\rc@orig@outputpage=\@outputpage
%
%\def\@outputpage%
%{%
%    \if@reset@current@page%
%        %\immediate\protected@write\@auxout{}{\string\rc@current@page@number=1}%
%        \global\@reset@current@pagefalse
%    \fi%
%    \refstepcounter{rc@current@page@number}%
%    \typeout{[[[[[[\thepage -- \the\c@page]]]]]]}%
%    \immediate\protected@write\@auxout{}{\string\relax}%
%    \rc@orig@outputpage%
%}

%\let\rc@orig@outputpage=\@outputpage
%
%\def\@outputpage%
%{%
%{
%      \moveright\@themargin%
%      \vbox to\z@{\baselineskip\z@skip\lineskip\z@skip\lineskiplimit\z@%
%      \vskip\topmargin\vbox to\z@{\vss\hrule width\textwidth}%
%      \vskip\headheight\vbox to\z@{\vss\hrule width\textwidth}%
%      \vskip\headsep\vbox to\z@{\vss\hrule width\textwidth}%
%      \hbox to\textwidth{\llap{\vrule height\textheight}\hfil%
%      \vrule height\textheight}%
%      \vbox to\z@{\vss\hrule width\textwidth}%
%      \vskip\footskip\vbox to\z@{\vss\hrule width\textwidth}%
%      \vss}%
%      \vbox to\z@{\baselineskip\z@skip\lineskip\z@skip\lineskiplimit\z@%
%      \vskip-1\Gm@truedimen in\rlap{\hskip-1\Gm@truedimen in%
%      \vbox to\z@{\vbox to\z@{\vss\hrule width\paperwidth}%
%      \hbox to \paperwidth{\llap{\vrule height\paperheight}\hfil%
%      \vrule height\paperheight}%
%      \vbox to\z@{\vss\hrule width\paperwidth}%
%      \vss}}\vss}%
%}
%    \rc@orig@outputpage%
%}

\def\pagenumbering#1{%
    \global\c@page=\@ne%
    \gdef\thepage{%
        \csname @#1\endcsname\c@page%
    }%
    \gdef\thearabicpage{%
        \number\c@page%
    }%
}

\long\def\protected@write#1#2#3%
{%
    \begingroup%
        \let\thepage\relax%
        \let\thearabicpage\relax%
        #2%
        \let\protect\@unexpandable@protect%
        \edef\reserved@a{\write#1{#3}}%
        \reserved@a%
    \endgroup%
    \if@nobreak%
        \ifvmode%
            \nobreak%
        \fi%
    \fi%
}

\def\pagelabel#1%
{%
    \bgroup%
        \@bsphack%
            \protected@write\@auxout{}%
                {\string\newlabel{#1}{{\@currentlabel}{\thearabicpage}}}%
        \@esphack%
    \egroup%
}%

% A command for dropping text

%\input Konanur.fd
%\newcommand*\dropfont{\usefont{U}{Konanur}{xl}{n}}
\newcommand*\dropfont{\normalfont\LARGE}

\newif\if@drop
\def\@droptrue{\let\if@drop\iftrue}
\def\@dropfalse{\let\if@drop\iffalse}

\newbox\patternbox
\newbox\thembox
\newbox\dropbox
\newdimen\dropboxwidth
\newdimen\dropboxheight

\def\drop#1{%
    \setbox\patternbox=\hbox{\vbox{\hbox{M}\hbox{M}\hbox{M}\hbox{M}}}%
    \setbox\thembox\hbox{M}%
    \setbox\dropbox=\hbox{\fboxsep=\arrayrulewidth\fboxrule=\arrayrulewidth\fbox{\dropfont\colorbox{lightgray}{#1}}}%
    \setbox\dropbox=\hbox{\resizebox*{!}{\ht\patternbox}{\box\dropbox}}%
    \dropboxwidth=\wd\dropbox%
    \advance\dropboxwidth by 3pt%
    \dropboxheight=\ht\dropbox%
    \advance\dropboxheight by -\ht\thembox%
    \setbox\dropbox=\hbox to \dropboxwidth{\raise-\dropboxheight\box\dropbox}%
    \noindent%
    \hangindent=\dropboxwidth%
    \hangafter=-4%
    \hskip-\dropboxwidth%
    \dp\dropbox=0pt%
    \ht\dropbox=0pt%
    \box\dropbox%
    \ignorespaces%
}%

% \def\drop#1{%
%     \begingroup%
%          \setbox1\hbox{\vbox{\hbox{M}\hbox{M}\hbox{M}}}%
%          \setbox0\hbox{\normalfont\LARGE#1}%
%          \setbox0\hbox{\resizebox*{!}{\ht1}{\box0}}%
%          \setbox1\hbox{M}%
%          \setbox2\hbox{(}%
%          \dimen0=\wd0%
%          \advance\dimen0 by 3pt%
%          \dimen1=\ht0%
%          \advance\dimen1 by -\ht1%
%          \setbox0\hbox to \dimen0{\raise-\dimen1\box0\hss}%
%          \noindent%
%          \hangindent=\dimen0%
%          \hangafter=-3%
%          \hskip-1.0\dimen0%
%          \dp0=0pt\ht0=0pt%
%          \box0%
%     \endgroup%
% }%


% \def\drop#1{%
%     \begingroup%
%         \dimen3=0.25em%
%         \def\scalemag{1.7}%
%         \def\raisemag{0.6}%
% %        \if#1A\dimen3=0.00em\def\raisemag{0.69}\fi%
% %        \if#1B\dimen3=0.00em\def\raisemag{0.69}\fi%
%         \if#1C\dimen3=0.00em\def\raisemag{0.5}\fi%
%         \if#1D\dimen3=0.50em\def\raisemag{0.5}\fi%
%         \if#1E\dimen3=0.50em\fi%
%         \if#1F\def\raisemag{0.5}\fi%
%         \if#1G\dimen3=0.20em\def\raisemag{0.45}\fi%
%         \if#1H\dimen3=0.50em\fi%
% %        \if#1I\dimen3=0.10em\fi%
% %        \if#1J\dimen3=0.10em\fi%
% %        \if#1K\dimen3=0.10em\fi%
% %        \if#1M\dimen3=0.10em\fi%
%          \if#1N\dimen3=0.40em\fi%
%          \if#1O\dimen3=0.50em\fi%
%         \if#1P\def\raisemag{0.5}\fi%
% %        \if#1S\dimen3=0.10em\fi%
% %        \if#1T\dimen3=0.20em\fi%
% %        \if#1U\dimen3=0.10em\fi%
%         \if#1V\dimen3=0.60em\def\scalemag{1.8}\fi%
%         \if#1W\dimen3=0.80em\def\scalemag{1.8}\fi%
% %        \if#1X\dimen3=0.10em\fi%
% %        \if#1Y\dimen3=0.10em\fi%
% %        \setbox0\hbox{\calligraphicfont #1}%
%         \setbox0\hbox{#1}%
%         \setbox1\hbox{\vbox{\hbox{W}\hbox{M}}}%
%         \setbox0\hbox{\resizebox*{!}{\scalemag\ht1}{\box0}}%
%         \setbox1\hbox{M}%
%         \setbox2\hbox{(}%
%         \dimen0\wd0%
%         \advance\dimen0 by \dimen3%
%         \dimen1=\ht0%
%         \advance\dimen1 by -\ht1%
%         %\setbox0\hbox to \dimen0{\colorbox{yellow}{\raise-\raisemag\dimen1\box0\hss}}%
%         \setbox0\hbox to \dimen0{\raise-\raisemag\dimen1\box0\hss}%
%         \dimen1=\hangindent%
%         \noindent%
%         \global\hangindent=1.0\dimen0%
%         \global\hangafter=-2%
%         \hskip-1.0\dimen0%
%         \noindent%
%         \dp0=0pt\ht0=0pt%
%         \box0%
%     \endgroup%
% }%

%\def\drop#1{%
%    \begingroup%
%        \dimen3=0.25em%
%        \def\scalemag{1.7}%
%        \def\raisemag{0.6}%
%        \if#1A\dimen3=0.00em\def\raisemag{0.69}\fi%
%        \if#1C\dimen3=0.00em\def\raisemag{0.5}\fi%
%        \if#1D\dimen3=0.40em\fi%
%        \if#1F\dimen3=0.10em\fi%
%        \if#1G\dimen3=0.20em\def\raisemag{0.5}\fi%
%        \if#1I\dimen3=0.00em\fi%
%        \if#1J\dimen3=0.10em\fi%
%        \if#1K\dimen3=0.10em\fi%
%        \if#1M\dimen3=0.10em\fi%
%        \if#1O\dimen3=0.40em\fi%
%        \if#1P\dimen3=0.40em\fi%
%        \if#1S\dimen3=0.10em\fi%
%        \if#1T\dimen3=0.20em\fi%
%        \if#1U\dimen3=0.10em\fi%
%        \if#1V\dimen3=0.50em\fi%
%        \if#1W\dimen3=0.50em\fi%
%        \if#1X\dimen3=0.10em\fi%
%        \if#1Y\dimen3=0.10em\fi%
%        \setbox0\hbox{\zapf #1}%
%        \setbox1\hbox{\vbox{\hbox{W}\hbox{M}}}%
%        \setbox0\hbox{\resizebox*{!}{\scalemag\ht1}{\box0}}%
%        \setbox1\hbox{M}%
%        \setbox2\hbox{(}%
%        \dimen0\wd0%
%        \advance\dimen0 by \dimen3%
%        \dimen1=\ht0%
%        \advance\dimen1 by -\ht1%
%        \setbox0\hbox to \dimen0{\colorbox{yellow}{\raise-\raisemag\dimen1\box0\hss}}%
%        \global\drop@hangindent=\dimen0%
%        \dp0=0pt\ht0=0pt%
%        \global\savebox{\drop@letter}{\box0}%
%    \endgroup%
%        \noindent%
%        \hangindent=\drop@hangindent%
%        \hangafter=-2%
%        \hskip-\drop@hangindent%
%        \usebox{\drop@letter}%
%}%

%\def\drop#1#2{{
%    \noindent%
%    \setbox0\hbox{\droplargefont #1}%
%    \setbox1\hbox{#2}%
%    \setbox2\hbox{(}%
%    \count0=\ht0%
%    \advance\count0 by \dp0%
%    \count1\baselineskip%
%    \advance\count0 by -\ht1%
%    \advance\count0 by \ht2%
%    \dimen1=.5ex%
%    \advance\count0 by \dimen1%
%    \divide\count0 by \count1%
%    \advance\count0 by 1%
%    \dimen0\wd0%
%    \advance\dimen0 by.25em%
%    \dimen1=\ht0%
%    \advance\dimen1 by -\ht1%
%    \global\hangindent\dimen0%
%    \global\hangafter-\count0%
%    \hskip-\dimen0%
%    \setbox0\hbox to \dimen0{\raise-\dimen1\box0\hss}%
%    \dp0=0in\ht0=0in\box0}#2%
%}%

% Important concepts \concept[index term]{term}

\newcommand{\concept}[2][\empty]{%
  \emph{#2}\relax%
  \def\tempconcept{#1}%
  \ifx\tempconcept\empty%
    \index{#2}%
  \else%
    \index{#1}%
  \fi%
}

% Include chapters

% %\newcommand{\imgpath}[1]{./#1}
% %\newcommand{\includechapter}[2]{%
% %  \global\renewcommand{\imgpath}[1]{#2/##1}
% %  \include{#1}%
% %}
%
% \newcommand{\imgpath}[1]{./#1}
%
% \newcommand{\includechapter}[2][\empty]{%
%     %\typeout{\string\includechapter{#1}{#2}}%
%     \def\includechapter@filename{#2}%
%     \filename@parse\includechapter@filename%
%     \let\includechapter@filename@area\filename@area%
%     \let\includechapter@filename@base\filename@base%
%     \ifx#1\empty%
%         \global\renewcommand{\imgpath}[1]{\includechapter@filename@area fig/##1}%
%     \else%
%         \global\renewcommand{\imgpath}[1]{#1/##1}%
%     \fi%
%     %\typeout{[\includechapter@filename@area\includechapter@filename@base.tex: \imgpath{}]}%
%     \include{\includechapter@filename@area\includechapter@filename@base}%
% }

\newcommand{\imgpath}[1]{./#1}

\def\setimgpath#1#2{%
    \def\includechapter@filename{#2}%
    \filename@parse\includechapter@filename%
    \let\includechapter@filename@area\filename@area%
    \let\includechapter@filename@base\filename@base%
    \ifx#1\empty%
        \global\renewcommand{\imgpath}[1]{\includechapter@filename@area fig/##1}%
    \else%
        \global\renewcommand{\imgpath}[1]{#1/##1}%
    \fi%
}

\let\save@include=\include

\renewcommand{\include}[2][\empty]{%
    \setimgpath{\empty}{#2}%
    \save@include{#2}%
}

\def\includechapter{%
    \@latex@error{\noexpand\includechapter is deprecated.  Use \noexpand\include instead}
}

% Captions

\setlength{\dbltextfloatsep}{12cm}
\newlength{\@ctmp}
\newlength{\@figindent}
\setlength{\@figindent}{0cm}

%\long\def\@makecaption#1#2{
%    \addvspace{\abovecaptionskip}%
%%    \bodywide
%       #1:~ \itshape #2.%
%%    \endbodywide
%   %\vskip\abovecaptionskip%
%   %\setbox\@tempboxa\hbox{\noindent\normalfont #1:~\textit{#2.}}%
%   %\setlength{\@ctmp}{0.75\hsize}%
%   %\addtolength{\@ctmp}{-2\@figindent}%
%   %\ifdim \wd\@tempboxa > \@ctmp%
%      %\begin{list}{}{\leftmargin\@figindent \rightmargin\leftmargin}
%         %\item[] #1:~\textit{#2.} \par
%      %\end{list}%
%   %\else%
%   %   \hbox to \hsize{\hfil\box\@tempboxa\hfil}%
%   %\fi%
%}

\def\caption{%
    \refstepcounter\@captype%
    \@dblarg{\@caption\@captype}%
}

\long\def\@caption#1[#2]#3{%
    %\typeout{** #1 ** #2 ** #3}
    \addcontentsline{\csname ext@#1\endcsname}{#1}%
        {\protect\numberline{\csname the#1\endcsname}#2}%
    \par%
    %\vspace*{\abovecaptionskip}%
    \@printcaption{#1}{#3}%
}

\def\@printcaption#1#2{%
    \bgroup%
        \baselineskip\normalbaselineskip%
        \vspace*{\abovecaptionskip}%
        \bgroup\csname fnum@#1\endcsname\egroup:~\bgroup\itshape #2\egroup\par%
    \egroup%
}

\def\@printsubcaption#1#2{%
    \bgroup%
        \baselineskip\normalbaselineskip%
        \smallbreak%
        \parbox[b]{\hsize}{\centering(\bgroup #1\egroup)~\bgroup\itshape #2\egroup}\par%
    \egroup%
}

%\def\contcaption{%
%    \@dblarg{\@contdcaption\@captype}%
%}
%
%\long\def\@contdcaption#1[#2]#3{%
%    \bgroup%
%        \baselineskip\normalbaselineskip%
%        \bgroup\csname fnum@#1\endcsname~(#2)\egroup:~\bgroup\itshape #3.\egroup%
%    \egroup%
%}

% \centerblock{text}

\newcommand{\centerblock}[2][\textwidth]{%
    %\hskip 0.5em \@plus.17fil \hfill%
    %\vbox{\begin{center} #1 \end{center}}%
    %\hfill \hskip 0.5em \@plus.17fil \relax%
    %\vbox{\begin{center} #1 \end{center}}%
    %\hbox{\noindent \parbox{\bodywidth}{\centering #1}}\ignorespaces%
    \noindent\parbox{#1}{\centering #2}%\ignorespaces%
}

% \leftblock{text}

\newcommand{\leftblock}[2][\textwidth]{%
    %\hskip 0.5em \@plus.17fil \hfill%
    %\vbox{\begin{center} #1 \end{center}}%
    %\hfill \hskip 0.5em \@plus.17fil \relax%
    %\vbox{\begin{center} #1 \end{center}}%
    %\hbox{\noindent \parbox{\bodywidth}{\flushleft #1}}\ignorespaces%
    \noindent\parbox{#1}{\raggedright #2}%\ignorespaces%
}

% \rightblock{text}

\newcommand{\rightblock}[2][\textwidth]{%
    %\hskip 0.5em \@plus.17fil \hfill%
    %\vbox{\begin{center} #1 \end{center}}%
    %\hfill \hskip 0.5em \@plus.17fil \relax%
    %\vbox{\begin{center} #1 \end{center}}%
    %\hbox{\noindent \parbox{\bodywidth}{\hfill #1}}\ignorespaces%
    \noindent\parbox{#1}{\raggedleft #2}%\ignorespaces%
}

% patch to make list enviroments work well inside bodywides

\let\rc@list=\list%
\def\list#1#2{%
    \rc@list{#1}{#2}%
    \if@bodywide%
        \prepare@wide@margins[yes]{list}%
    \fi%
}

% bodywide environment \begin{bodywide} text \end{bodywide}

\newcounter{bodywide@begin@lineno}
\newcounter{bodywide@label@no}

%\long\def\addtocontents#1#2{%
%  \protected@write\@auxout
%      {\let\label\@gobble \let\index\@gobble \let\glossary\@gobble}%
%      {\string\@writefile{#1}{#2}}}
%
%\def\wide@init{%
%  \protected@write\@auxout
%      {\let\label\@gobble \let\index\@gobble \let\glossary\@gobble}%
%      {\string\@writefile{aux}{x=0}}
%  \global\let\wide@init\relax
%}
%
%\let\wide@orig@outputpage=\@outputpage
%\def\@outputpage%
%{%
%    \ifx\wide@init\relax
%        \relax
%    \fi
%    \wide@orig@outputpage
%}

\newcommand\prepare@wide@margins[2][]%
{%
    % BUG: \marginparsep is not taken into account
    %\wide@init
    \setcounter{bodywide@begin@lineno}{\the\inputlineno}%
    \refstepcounter{bodywide@label@no}%  TODO: Maybe stepcounter
    \global\edef\bodywide@label{bodywide-\arabic{bodywide@label@no}-#2-\the\inputlineno}%
    \ifthenelse{\isodd{\RCHL@pageno{\bodywide@label}}}%
    {%
        \def\prep@margins{\leftskip0pt\rightskip-\marginalwidth}%
        \@oddpagetrue%
    }{%
        \def\prep@margins{\leftskip-\marginalwidth\rightskip0pt}%
        \@oddpagefalse%
    }%
    \advance\linewidth by \marginalwidth
    \prep@margins%
    \textwidth=\bodywidth%
%    \parskip=\defaultparskip%
%    \hsize=\bodywidth%
%    \marginparsep=0pt%
%    \marginparwidth=0pt%
    \ifx#1\empty%
    \else%
        \pagelabel{\bodywide@label}%
    \fi%
    \nobreak%
}

\newcommand*\bodywide[1][\thechapter]%
{%
    \if@bodywide%
        \errmessage{The bodywide environment in line \arabic{bodywide@begin@lineno}~%
                    must be closed before you begin a new one}%
    \fi%
    \@bodywidetrue%
    %\par%
    \begingroup%
        % This \trivlist seems to work well if omitted, but abstracts cannot be
        % more than 2 paragraphs long if present !!!
        %\topsep=0pt\partopsep=0pt%\labelsep=0pt%
        %\labelwidth=0pt\listparindent=0pt\itemsep=0pt%
        %\trivlist%
        %    \item[]\relax%
            %\typeout{#1}\show\show
            \prepare@wide@margins[yes]{#1}%
            %\rlap{\hbox{\color{red}\scriptsize\bodywide@label ::: \RCHL@pageno{\bodywide@label}}}%%%%%%%% DEBUG!!!

}%

\def\endbodywide%
{%
        %\endtrivlist%
    \endgroup%
    \penalty-100%
    %\par%
    \@bodywidefalse%
}%


%\newcommand*\bodywide[1][\thechapter]%
%{%
%    \if@bodywide%
%        \errmessage{The bodywide environment in line \arabic{bodywide@begin@lineno}~%
%                    must be closed before you begin a new one}%
%    \fi%
%    \@bodywidetrue%
%    \setcounter{bodywide@begin@lineno}{\the\inputlineno}%
%    \global\edef\bodywide@label{bodywide-#1-\the\inputlineno}%
%    \ifthenelse{\isodd{\pageref{\bodywide@label}}}{%
%        \def\prep@margins{\leftskip0pt\rightskip-\marginalwidth}%
%        \@oddpagetrue%
%    }{%
%        \def\prep@margins{\leftskip-\marginalwidth\rightskip0pt}%
%        \@oddpagefalse%
%    }%
%    \begingroup%
%        \parskip=0pt\topsep=0pt\partopsep=0pt%
%        \trivlist%
%            \item \relax%
%                \pagelabel{\bodywide@label}%
%                \prep@margins%
%                \textwidth=\bodywidth%
%}%



% General tip environment \begin{tip}[image]{caption} text \end{tip}

\def\fps@tip{tbp}
\def\ftype@tip{2}

\newskip{\tip@head@width}%

\newenvironment{tip}[2][]
{%
    \if@tip%
        \errmessage{The tip in line \arabic{listing@begin@lineno}~%
                    must be closed before you begin a new tip}%
    \fi%
    \@tiptrue%
    \@dblfloat{tip}%
        \def\tip@temp@icon{#1}%
        \setbox0\hbox{#1}%
        \bodywide[tip]%
            \rules%
                \tip@head@width\textwidth%
                \advance\tip@head@width-\wd0%
                \advance\tip@head@width-\quadwidth%
                \if@wideoddpage%
                        \noindent\parbox[b]{\tip@head@width}{\Large\bfseries #2}\quad\parbox[t]{\wd0}{\box0}%
                \else%
                        \noindent\parbox[t]{\wd0}{\box0}\quad\parbox[b]{\tip@head@width}{\Large\bfseries #2}%
                \fi%
                \par%
                \parskip=\defaultparskip%
                \parindent=\defaultparindent%
                \bigbreak%\indent%
}%
{%
                \parskip=0pt%
                \parindent=0pt%
            \endrules%
        \endbodywide%
    \end@dblfloat%
    \@tipfalse%
}

%\newenvironment{tip}[2][]
%{%
%    \if@tip%
%        \errmessage{The tip in line \arabic{listing@begin@lineno}~%
%                    must be closed before you begin a new tip}%
%    \fi%
%    \@tiptrue%
%    \@dblfloat{tip}%
%        \def\tip@temp@icon{#1}%
%        \ifx\tip@temp@icon\empty%
%            \setbox0\hbox{}%
%        \else%
%            \if@draft%
%                \setbox0\hbox{\fbox{\Large\bf #1}}%
%            \else
%                \setbox0\hbox{\includegraphics{#1.eps}}%
%            \fi%
%        \fi%
%        \bodywide[tip]%
%            \rules%
%                \tip@head@width\textwidth%
%                \advance\tip@head@width-\wd0%
%                \advance\tip@head@width-12pt%
%                \if@wideoddpage%
%                    \setbox2\hbox{%
%                        \noindent%
%                        \parbox{\tip@head@width}{\flushright\Large\bfseries #2}%
%                        \hspace{12pt}%
%                        \box0%
%                    }%
%                \else%
%                    \setbox2\hbox{%
%                        \noindent%
%                        \box0%
%                        \hspace{12pt}%
%                        \parbox{\tip@head@width}{\Large\bfseries #2}%
%                    }%
%                \fi%
%                \wd2=0pt\box2%
%                \mbox{}\\[\bigskipamount]%
%                \parskip\defaultparskip%
%                \parindent\defaultparindent%
%                \indent%
%}%
%{%
%            \endrules%
%        \endbodywide%
%    \end@dblfloat%
%    \@tipfalse%
%}

%    \ifthenelse{\isodd{\pageref{\rules@label}}}{%
%      \begin{picture}(0, 0)%
%          \setlength{\unitlength}{0.80\bodywidth}%
%          \advance\unitlength by 10pt%
%          \put(1, 0){\lower\ht0\box0}%
%      \end{picture}%
%    }{%
%    \typeout{!!!!!!!!!!!}%
%      \begin{picture}(0, 0)%
%          \setlength{\unitlength}{\ht1}%
%          \advance\unitlength by 10pt%
%          \put(1, 1){\lower\ht0\box0}%
%      \end{picture}%
%    }%

% Sidebar environment.  \begin{sidebar}{caption} text \end{sidebar}

\newenvironment{sidebar}[1]{\tip[\sidebarglyph]{#1}}{\endtip}

% Hint environment.  \begin{hint}{caption} text \end{hint}

\newenvironment{hint}[1]{\tip[\hintglyph]{#1}}{\endtip}

% Warning environment.  \begin{warning}{caption} text \end{warning}

\newenvironment{warning}[1]{\tip[\warningglyph]{#1}}{\endtip}

% Comparison environment.  \begin{comparison}{image}{caption} text \end{comparison}

\newenvironment{comparison}[2][]{\tip[\comparisonglyph ]{#2}}{\endtip}

% \begin{citeverbatim}

%\newenvironment{Quote}[1]
%{%
%\gdef\quotecite{#1}%
%   \quotation%
%    \footnotesize \noindent``%
%}%
%{%
%'' (\cf Reference~\cite{\quotecite})%
%\endquotation%
%}%

\newenvironment{citeverbatim}[1][]%
{%
    \list{}{\leftmargin=\defaultparindent\rightmargin\leftmargin}%
        \item\relax%
        \def\tempcite{#1}
        \ifx\tempcite\empty%
        \else%
            (#1)\quad%
        \fi%
        \itshape\ignorespaces\relax%
}%
{%
    \endlist%
}

% authorship environment.  \begin{authorship} text \end{authorship}

\newenvironment{authorship}%
{%
    \vspace{\bigskipamount}%
    \bodywide
        \parskip=0pt%
        \def\\{\par\hfill}%
        \noindent\hfill%
}%
{%
        \medbreak%
    \endbodywide%
    \vspace{\bigskipamount}%
}%

% \begin{quotation}[additional-info]{author} text \end{quotation}

\newenvironment{quotation}[2][]%
{%
    \def\quotation@author{#2}%
    \ifx\\#1\\%
        \def\quotation@info{}%
    \else
        \def\quotation@info{, #1}
    \fi
    \vspace{\bigskipamount}%
    \bodywide%
        \leftskip=0.20\textwidth%
        \raggedleft%
        \noindent%
        \calligraphicfont%
}%
{%
        \medbreak%
        \raggedleft%
        \noindent%
        \quotation@author%
        \quotation@info%
        \par%
    \endbodywide%
    \vspace{\bigskipamount}%
}%


% \newenvironment{quotation}[2][\empty]%
% {%
%     \def\quotation@author{#2}%
%     \def\quotation@info{#1}
%     \vspace{\bigskipamount}%
%     \bodywide%
%         \leftskip=0pt%
%         \parskip=0pt%
%         \def\\{\par\hfill}%
%         \noindent\hfill\calligraphicfont%
% }%
% {%
%         \medbreak%
%         \noindent\hfill\calligraphicfont%
%         \quotation@author%
%         \ifx\quotation@info\empty%
%         \else%
%             \mbox{,}~\quotation@info\relax\\%
%         \fi%
%     \endbodywide%
%     \vspace{\bigskipamount}%
% }%

% Abstract environment.  \begin{abstract} text \end{abstract}

%\newcommand{\abstractsep}{\symbolfont \char"26}
%\newcommand{\abstractseptop}{\symbolfont \char"26}
%\newcommand{\abstractsepbotton}{\symbolfont \char"26}

\newenvironment{abstract}%[1][XX]
{%
    \vfill%
    \bodywide[abstract]%
        \itshape%
        \drop%
}%
{%
        \par%
    \endbodywide%
    \vfill%
    \newpage%
}

%%%% Postscript pictures
%%%
%%%\newcommand{\psfigure}[2][width=0.95\linewidth]{%
%%%    %\typeout{\string\includegraphics[#1]{\imgpath{#2}}}%
%%%    \bgroup
%%%        \if@draft%
%%%            \setbox0=\hbox{\fbox{\includegraphics[#1]{\imgpath{#2}}}}%
%%%        \else%
%%%            \setbox0=\hbox{\includegraphics[#1]{\imgpath{#2}}}%
%%%        \fi%
%%%        \setbox1=\hbox{()}%
%%%        \strut\hbox{\raise-\dp1\box0}\strut%
%%%        %\box0%
%%%    \egroup
%%%}
%%%
%%%\let\orig@Ginclude@eps\Ginclude@eps
%%%\def\Ginclude@eps#1%
%%%{%
%%%    \renewcommand{\message}[1]{\relax}%
%%%    \orig@Ginclude@eps{#1}%
%%%}%

%%%% Figure environment. \begin{figure}{caption}{label} text \end{figure}
%%%
%%%\newcounter{figure}[chapter]
%%%\renewcommand \thefigure
%%%     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@figure}
%%%\def\fps@figure{tbp}
%%%\def\ftype@figure{1}
%%%\def\ext@figure{lof}
%%%\def\fnum@figure{{\bfseries\figurename~\thefigure}}
%%%
%%%\newenvironment{figure}[2]
%%%{%
%%%    \gdef\psfigurecaption{#1}%
%%%    \gdef\psfigurelabel{#2}%
%%%    \@dblfloat{figure}%
%%%    \bodywide[figure]%
%%%        \rules%
%%%            \strut\hfill%
%%%}%
%%%{%
%%%            \hfill\strut%
%%%        \endrules%
%%%    \endbodywide%
%%%    \bodywide[caption]%
%%%        \caption{\psfigurecaption}%
%%%        \label{\psfigurelabel}%
%%%    \endbodywide%
%%%    \end@dblfloat%
%%%}%

%%% Table environment. \begin{table}[width]{caption}{label}{layout}{heading} text \end{table}
%%
%%\newcounter{table}[chapter]
%%\renewcommand \thetable
%%     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@table}
%%\def\fps@table{tbp}
%%\def\ftype@table{2}
%%\def\ext@table{lot}
%%\def\fnum@table{{\bfseries\tablename~\thetable}}
%%
%%\newenvironment{table}[5][0.95\textwidth]
%%{%
%%    \gdef\psfigurecaption{#2}%
%%    \gdef\psfigurelabel{#3}%
%%    \@dblfloat{table}%
%%        \def\@arraycr{%
%%            ${\ifnum0=`}\fi\@ifstar\@xarraycr\@xarraycr\hline}%
%%            \def\@xarraycr{\@ifnextchar[\@argarraycr{\ifnum0=`{\fi}${}\cr}}%
%%        \def\x@arraycr{%
%%            ${\ifnum0=`}\fi\@ifstar\@xarraycr\@xarraycr}%
%%            \def\@xarraycr{\@ifnextchar[\@argarraycr{\ifnum0=`{\fi}${}\cr}}%
%%        \bodywide[table]%
%%            \rules%
%%                \strut\hfill%
%%                \tabularx{#1}[tpb]{|#4|}%
%%                    \hline%
%%                        #5 \x@arraycr%
%%                    \hline\hline\hline\hline%
%%}%
%%{%
%%                \endtabularx%
%%                \hfill\strut%
%%            \endrules%
%%        \endbodywide%
%%        \bodywide[caption]%
%%            \caption{\psfigurecaption}%
%%            \label{\psfigurelabel}%
%%        \endbodywide%
%%    \end@dblfloat%
%%}%

%\newenvironment{rctabular}[2]% Último bueno en v2.8
%{%
%    \bgroup%
%        \def\@arraycr{%
%            ${\ifnum0=`}\fi\@ifstar\@xarraycr\@xarraycr\hline}%
%            \def\@xarraycr{\@ifnextchar[\@argarraycr{\ifnum0=`{\fi}${}\cr}}%
%        \def\x@arraycr{%
%            ${\ifnum0=`}\fi\@ifstar\@xarraycr\@xarraycr}%
%            \def\@xarraycr{\@ifnextchar[\@argarraycr{\ifnum0=`{\fi}${}\cr}}%
%        \tabularx{0.95\textwidth}{|#1|}%
%            \hline%
%                #2 \x@arraycr%
%            \hline\hline\hline\hline%
%}%
%{%
%        \endtabularx%
%    \egroup%
%}%

%\newcolumntype{.}[1]{D{.}{.}{#1}}
%\newcolumntype{,}[1]{D{,}{,}{#1}}
%
%\newif\if@Xcolumn
%\def\@Xcolumntrue{\let\if@Xcolumn\iftrue}
%\def\@Xcolumnfalse{\let\if@Xcolumn\iffalse}
%
%\newtoks\rc@tabcolstoks
%
%\def\rc@analysetabcols#1#2:{%
%    \ifthenelse{\equal{#1}{+}}%
%    {}%
%    {%
%        \ifthenelse{\equal{#1}{X}}{\@Xcolumntrue}{}%
%        \rc@analysetabcols#2+:%
%    }%
%}
%
%\newif\if@firstamp
%\def\@firstamptrue{\let\if@firstamp\iftrue}
%\def\@firstampfalse{\let\if@firstamp\iffalse}
%
%\newtoks\rc@tabheadertoks
%
%\def\rc@changetabheader#1&#2:{%
%    \if@firstamp%
%        \relax%
%    \else%
%        \rc@tabheadertoks\expandafter{\the\rc@tabheadertoks&}%
%    \fi%
%    \@firstampfalse%
%    \rc@tabheadertoks\expandafter{\the\rc@tabheadertoks\multicolumn{1}{l}{\mbox{\bfseries\ignorespaces#1}}\ignorespaces}%
%    \ifthenelse{\equal{#2}{+}}%
%    {%
%    }%
%    {%
%        \rc@changetabheader#2:%
%    }%
%}

%\RequirePackage{tabulary}
%\RequirePackage{multirow}
%
%\newenvironment{rctabular}[3][]%
%{%
%    \bgroup%
%        \@Xcolumnfalse%
%        \rc@tabcolstoks={}%
%        \rc@analysetabcols#2+:%
%        \rc@tabheadertoks={}%
%        \@firstamptrue%
%        \rc@changetabheader#3&+:%
%        \if@Xcolumn%
%            \ifx\\#1\\%
%                \rc@tabcolstoks={\tabularx{0.95\hsize}{#2}}%
%            \else%
%                \rc@tabcolstoks={\tabularx{#1}{#2}}%
%            \fi%
%        \else%
%            \ifx\\#1\\%
%                \rc@tabcolstoks={\tabulary{0.95\hsize}{#2}}%
%            \else%
%                \rc@tabcolstoks={\tabulary{#1}{#2}}%
%            \fi%
%        \fi%
%        \typeout{\the\rc@tabcolstoks}%
%        \the\rc@tabcolstoks%
%            %\rowcolor[gray]{.9}%
%            \the\rc@tabheadertoks \\%
%            \hline\hline%
%}%
%{%
%        \if@Xcolumn%
%            \endtabularx%
%        \else%
%            \endtabulary%
%        \fi%
%    \egroup%
%}%

% Foot notes

\renewcommand{\thefootnote}{\ensuremath{\dagger}\the\csname c@footnote\endcsname}
%\def\fnsymbol#1{\expandafter\@fnsymbol\csname c@#1\endcsname}
%\def\@fnsymbol#1{\ensuremath{\dagger\the#1}}%

% Leaders

\def\leaderfill{\leaders\hbox to 0.5em{\hss.\hss}\hfill}

% Marginal notes.  \marginalnote{text}

\let\rc@savemarginpar\marginpar

\def\rc@displaymarginpar#1{%
    \-% DON'T REMOVE THIS LINE
    \rc@savemarginpar[\raggedleft #1\par]{\raggedright #1\par}%
}

\def\marginpar#1{%
    \if@marginalnotes%
        \rc@displaymarginpar{%
            \hspace{0pt}% This hspace allows the first word to be hypenated if necessary!
            %\csname if@draft\endcsname\internallinenumbers*\fi%
            \normalfont%
            \itshape%
            \footnotesize%
            #1%
%            \par%
        }%
    \else%
        \relax%
    \fi%
}

% Add a contents line without/with page number

\def\addcontentslinenonumber#1#2#3{%
    %\typeout{!#1!#2!#3!}\show\show%
    \addtocontents{#1}{\protect\contentsline{#2}{#3}{}}%
}

% \AtBeginDocument{
%     \def\addcontentsline#1#2#3{%
%         #\typeout{!#1!#2!#3!}\show\show%
%         \addtocontents{#1}{\protect\contentsline{#2}{#3}{\thepage}}%
%     }
% }

% This is necessary to typeset lists of figures, tables, and so on body wide

\def\numberline#1{#1~}

\def\@starttoc#1{%
  \def\current@toc{#1}%
  \begingroup%
    %\select@language{\languagename}%
    \makeatletter%
    \@input{\jobname.#1}%
    \if@filesw%
      \expandafter\newwrite\csname tf@#1\endcsname%
      \immediate\openout \csname tf@#1\endcsname \jobname.#1\relax%
    \fi%
    \@nobreakfalse%
  \endgroup%
}

\newcommand*\l@part{\@parttocline{0}{0em}{1.5em}}
\newcommand*\l@chapter{\@chapterdottedtocline{0}{0em}{1.5em}}

\newcommand*\l@section{\@dottedtocline{1}{1.8em}{2.5em}}
\newcommand*\l@subsection{\@dottedtocline{2}{4.3em}{3.1em}}

\newcommand*\l@subsubsection{\@dottedtocline{3}{7.4em}{4em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{11.4em}{5em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{16.4em}{6em}}

\newcommand*\l@figure{\@dottedtocline{1}{0em}{2.5em}}
\newcommand*\l@table{\@dottedtocline{1}{0em}{2.5em}}
\newcommand*\l@program{\@dottedtocline{1}{0em}{2.5em}}

\def\@dottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth%
    \relax%
  \else%
    \bodywide[\current@toc]%
        \parskip=2pt plus 1pt minus 1pt%
        \parindent=0pt%
        \def\numberline##1{\hbox to #3{##1\hfil}}%
        \advance\leftskip #2 \hskip -#3%
        \hangindent #3 \hangafter -10%
        \noindent #4 \leaderfill #5\par%
    \endbodywide%
%    \clubpenalty=10000%
%     \widowpenalty=10000%
     \nobreak%
  \fi%
}

\def\@parttocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth%
    \relax%
  \else%
    \addvspace{\bigskipamount}%
    \bodywide[\current@toc]%
        %\rule{\textwidth}{1pt}\par%
        \def\numberline##1{\hbox to #3{##1\hfil}}%
        \noindent \hskip -#3 \hangindent #3 \hangafter -10 \Large \bfseries #4\par%
    \endbodywide%
    \nobreak%
  \fi%
}

\def\@chapterdottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth%
    \relax%
  \else%
    \addvspace{\medskipamount}%
    \bodywide[\current@toc]%
        \def\numberline##1{\hbox to #3{##1\hfil}}%
        \noindent \hskip -#3 \hangindent #3 \hangafter -10%
        \large \bfseries#4 \leaderfill #5\par%
    \endbodywide%
    \nobreak%
  \fi%
}

%\newcommand*\l@part[2]{%
%  \ifnum \c@tocdepth>-2 %
%    \addvspace{10pt}%
%    \bodywide[\current@toc]%
%        \rule{\bodywidth}{1pt}\nobreak\\[\smallskipamount]%
%        \Large \bfseries ~#1 \hfill #2\nobreak%
%    \endbodywide%
%    \nobreak%
%  \fi%
%}
%
%\newcommand*\l@chapter[2]%
%{%
%  \addpenalty{-\@highpenalty}%
%  \vskip 1.0em \@plus\p@
%  \ifnum \c@tocdepth>1%
%    \bodywide[\current@toc]%
%        \large \bfseries ~#1 \hfill #2%
%    \endbodywide%
%    \nobreak%
%  \fi%
%}

% PDF Macros

\def\pdfgroup#1{%
    \special{pdf:outline 1 << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}
}

% Matter commands

\def\hiddenpart#1{%
    \special{pdf:outline 1 << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
}

\newcommand\makefront{%
    \covermatter%
    \maketitle%
    \makeminutes%
    \makeartwork%
    \makededicatory%
    \frontmatter%
    \@partlevel=1%
    \tableofcontents%
    \listoffigures%
    \listoftables%
    \listofprograms%
    \cleardoublepage%
    \special{pdf:outline 1 << /Title (\pdfFrontMatter) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
}


\newcommand\makeback[2][rc-natbib-2.14]{%
    \@mainmatterfalse%
    %\addtocontents{toc}{\protect\addvspace{2\bigskipamount}}%
    \printanswers%
    \bibliographystyle{#1}%
    \bibliography{#2}%
    \printindex%
}

\newcommand\covermatter{%
  \@mainmatterfalse%
  \thispagestyle{empty}%
  \pagestyle{empty}%
  \setcounter{page}{1}%
}

\newcommand\frontmatter{%
  \@mainmatterfalse%
  \pagenumbering{roman}%
  \pagestyle{headings}%
  \setcounter{page}{1}%
}

\newcommand\mainmatter{%
  \@partlevel=0%
  \cleardoublepage%
  \@mainmattertrue%
  \pagestyle{headings}%
  \thispagestyle{empty}%
  \pagenumbering{arabic}%
  \setlength\parskip{\defaultparskip}%
  \setcounter{page}{1}%
  \setcounter{chapter}{0}%
}

\newcommand\backmatter{%
    \appendix%
    %\@mainmatterfalse%
}

% Center pages

\newcommand{\blankfooter}
{%
    \vspace*{\headsep}%
    \vspace*{\headheight}%
}

\newenvironment{blankfooterpage}%
{%
    \pagestyle{empty}%
    \null%
    \vfill%
}%
{%
    \vfill%
    \blankfooter%
    \null%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Standard book.cls begins here.  A few minor modifications have been made in chapters
% parts, sections and so on.  New options have been provided.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\RC@actual@page{a4page}
\def\RC@marginparwidth@param{,marginparwidth=0.25\textwidth}

\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagetrue
\newif\if@openright
\newif\if@mainmatter
\@mainmattertrue \if@compatibility\else

\errorcontextlines=0

\DeclareOption{blacklinks}%
    {\PassOptionsToPackage{blacklinks}{rc-hyperlink-2.14}}


\DeclareOption{rcdebug}%
   {\errorcontextlines=5}

\DeclareOption{nobibnotes}%
   {\@bibnotesfalse}
\DeclareOption{isomargin}%
   {\@isomargintrue}
\DeclareOption{doubleisomargin}%
   {\@isomarginfalse}
\DeclareOption{marginalnotes}%
   {\@marginalnotestrue}
\DeclareOption{nomarginalnotes}%
   {\@marginalnotesfalse%
    \def\RC@marginparwidth@param{,nomarginpar}}
\DeclareOption{15x24paper}%
   {\setlength\paperheight {24cm}%
    \setlength\paperwidth  {15cm}}
\DeclareOption{15x24page}%
   {\def\RC@actual@paper{width=15cm,height=24cm}}
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}%
\DeclareOption{a4page}%
    {\def\RC@actual@page{a4}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}%
\DeclareOption{a5page}%
    {\def\RC@actual@page{a5}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}%
\DeclareOption{b5page}%
    {\def\RC@actual@page{b5}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}%
\DeclareOption{letterpaper}%
    {\def\RC@actual@page{letter}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}%
\DeclareOption{legalpage}%
    {\def\RC@actual@page{legal}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}%
\DeclareOption{executivepage}%
    {\def\RC@actual@page{executive}}
%\DeclareOption{miniabstract}%
%    {\@miniabstracttrue}
\fi \if@compatibility
  \renewcommand\@ptsize{0}
\else \DeclareOption{10pt}{\renewcommand\@ptsize{0}\baselineskip12pt}
\fi \DeclareOption{11pt}{\renewcommand\@ptsize{1}\baselineskip13pt}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}\baselineskip14pt plus 1pt minus 2pt}
\if@compatibility\else \DeclareOption{oneside}{\@twosidefalse
\@mparswitchfalse} \fi \DeclareOption{twoside}{\@twosidetrue
\@mparswitchtrue}
\DeclareOption{draft}{%
  \setlength\overfullrule{20pt}%
  \@drafttrue}
\if@compatibility\else
\DeclareOption{final}{%
  \setlength\overfullrule{0pt}%
  \@draftfalse}
\fi \DeclareOption{titlepage}{\@titlepagetrue} \if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse} \fi \if@compatibility
\@openrighttrue \else \DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse} \fi \if@compatibility\else
\DeclareOption{onecolumn}{\@twocolumnfalse} \fi
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}

% RC %%%%%%%%%%%%%%%%%%%%%%%%%%

\@croppingtrue
\DeclareOption{nocrop}{\@croppingfalse}

\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}
% RC %%%%%%%%%%%%%%%%%%%%%%%%%%

\ExecuteOptions{a4paper,a4page,12pt,twoside,onecolumn,draft,openright,nobibnotes,doubleisomargin,nocrop,nomarginalnotes}
\ProcessOptions
\input{bk1\@ptsize.clo}
\setlength\lineskip{1\p@} \setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@} \@lowpenalty   51 \@medpenalty
151 \@highpenalty 301 \setcounter{topnumber}{2}
% RC %\renewcommand\topfraction{.7}
% RC %\setcounter{bottomnumber}{1}
% RC %\renewcommand\bottomfraction{.3}
% RC %\setcounter{totalnumber}{3}
% RC %\renewcommand\textfraction{.2}
% RC %\renewcommand\floatpagefraction{.5}
% RC %\setcounter{dbltopnumber}{2}
% RC %\renewcommand\dbltopfraction{.7}
% RC %\renewcommand\dblfloatpagefraction{.5}
\if@twoside
  \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{%
        \setbox0=\hbox{\parbox{\bodywidth}{\thepage\hfill\itshape\leftmark}}%
        \hskip-\marginalwidth \wd0=0pt\box0%
      }%
      \def\@oddhead{%
        \setbox0=\hbox{\parbox{\bodywidth}{\itshape\rightmark\hfill\thepage}}%
        \wd0=0pt\box0%
      }%
      \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth{%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter%
            \@chapapp\ \thechapter. \ %
          \fi
        \fi
        ##1}{}}%
    \def\sectionmark##1{%
      \markright{%
        \ifnum \c@secnumdepth >\z@
          \thesection. \ %
        \fi
        ##1}}}
\else
  \def\ps@headings{%
    \let\@oddfoot\@empty
    \def\@oddhead{{\itshape\rightmark}\hfil\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright{%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
            \@chapapp\ \thechapter. \ %
          \fi
        \fi
        ##1}}}
\fi
\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil\itshape\leftmark}%
    \def\@oddhead{{\itshape\rightmark}\hfil\thepage}%
    \let\@mkboth\@gobbletwo
    \let\chaptermark\@gobble
    \let\sectionmark\@gobble
    }

%\def\andbullet{\hfil $\bullet$ \hfil\def\and{\andpar}}
%\def\andpar{\relax\def\and{\andbullet}}

\def\and{%
    \hfill\mbox{}\hfill%
    \let\old@and\and%
    \def\and{\par\let\and\old@and}%
}

\newcommand{\defaultrights}%
{%
    In keeping with the traditional purpose of furthering science,
    education and research, it is the policy of the publisher, whenever
    possible, to permit non-commercial use and redistribution of the
    information contained in the documents whose copyright they own.  You
    however are \emph{not allowed} to take money for the distribution or
    use of these results except for a nominal charge for photocopying,
    sending copies, or whichever means you use redistribute them. The
    results in this document have been tested carefully, but they are not
    guaranteed for any particular purpose.  The publisher or the holder
    of the copyright do not offer any warranties or representations, nor
    do they accept any liabilities with respect to them.
}

\newcommand{\defaultminutestext}[2]%
{%
    A Comiss\~{a}o Examinadora, abaixo assinada, \bottomrule{4cm} a disserta\c{c}\~{a}o
    intitulada ``\@title : \@subtitle'', elaborada por \@author, como
    requisito parcial para a obten\c{c}\~{a}o do t\'{i}tulo de #1 em #2.%
}

\newcommand{\defaultminutesdate}%
{%
\bigbreak
\bigbreak
\centering
    Iju\'{i}, \bottomrule{1cm} de \bottomrule{3cm} de \bottomrule{2cm}.
}

\def\supportname{Support}
\def\trademarkname{Trademarks}
\def\classificationname{Classification}

\if@titlepage
  %\def\@title{\@latex@error{No \noexpand\subtitle given}\@ehc}
  \gdef\@title{Your title comes here}%
  \gdef\@subtitle{}%
  \gdef\@author{The authors come here}%
  \gdef\@institution{}%
  \gdef\@documenttype{}%
  \gdef\@advisor{}%
  \gdef\@splash{}%
  \gdef\@date{\today}%
  \gdef\@publisher{}%
  \gdef\@printed{}%
  \gdef\@copytext{}%
  \gdef\@rights{}%
  \gdef\@trademarks{}%
  \gdef\@record{}%
  \gdef\@record@text{}%
  \gdef\@support{}%
  \gdef\@artwork{}%
  \gdef\@dedicatory{}%
  \gdef\@minutestext{}%
  \gdef\@minutesdate{}%
  \def\subtitle#1{\gdef\@subtitle{#1}}%
  \def\institution#1{\gdef\@institution{#1}}%
  \def\documenttype#1{\gdef\@documenttype{#1}}%
  \def\advisor#1{\gdef\@advisor{#1}}%
  \def\splash#1{\gdef\@splash{#1}}%
  \gdef\publisher#1{\gdef\@publisher{#1}}%
  \gdef\printed#1{\gdef\@printed{#1}}%
  \gdef\copytext#1{\gdef\@copytext{#1}}%
  \gdef\rights#1{\gdef\@rights{#1}}%
  \gdef\trademarks#1{\gdef\@trademarks{{\bfseries\trademarkname:} #1}}
  \global\newcommand\record[2][ACM 1998]{%
    \gdef\@record@text{#2}%
    \gdef\@record{{\bfseries\classificationname~(#1):} \@record@text}%
  }
  \gdef\support#1{\gdef\@support{{\bfseries\supportname:} #1}}%
  \def\artwork#1{\gdef\@artwork{#1}}
  \def\dedicatory#1{\gdef\@dedicatory{#1}}
  \def\minutestext#1{\gdef\@minutestext{#1}}
  \def\minutesdate#1{\gdef\@minutesdate{#1}}
  \newcommand\maketitle{%
    \special{pdf:docinfo << /Title (\@title) /Author (\@author) /Subject (\@documenttype) /Keywords (\@record@text) >>}%
    \special{pdf:outline 1 << /Title (\@title) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
    \begingroup%
        \pagestyle{empty}%
        %\def\thefootnote{$\dagger$}%
        \begin{bodywide}[titlepage]
            \begin{rules}%
                    %\fbox{\centerblock{\Huge \@title}}%
                    \centerblock{\Huge\scshape\@title}%
                    \ifx\@subtitle\empty%
                        \relax%
                    \else%
                        \medbreak%
                        \centerblock{{\symbolfont\char'043\char'043\char'043}}%
                        \medbreak%\\[\bigskipamount]%
                        %\fbox{\centerblock{\Large \@subtitle}}%
                        \centerblock{\Large\scshape\@subtitle}%
                    \fi%
            \end{rules}%
            \bigbreak%
            %\begin{bodywide}%
                %\fbox{\centerblock{\Large\scshape\fill\@author}\hfil}\\%
                \centerblock{\Large\scshape\@author}%
                \medbreak%\mbox{}\\[\smallskipamount]%
                %\fbox{\centerblock{\Large \@institution}}%
                \centerblock{\Large\scshape\@institution}%
            %\end{bodywide}%
            \bigbreak%
            \centerblock{\scshape\@documenttype}\\%
            \centerblock{\scshape\@advisor}%
            \vfill%
            %\begin{bodywide}%
                %\fbox{\centerblock{\@splash}}%
                \centerblock{\scshape\@splash}%
            %\end{bodywide}%
            \vfill%
            %\begin{bodywide}%
                %\fbox{\centerblock{\@date}}%
                \centerblock{\scshape\@date}%
            %\end{bodywide}%
        \end{bodywide}%
        \blankfooter%
        \ifx\@legal\empty%
            \cleardoublepage%
        \else
            \newpage%
            \small%
            \thispagestyle{empty}%
            \begin{bodywide}[legalstuff]%
                \parindent=0pt%
%                \mbox{}\\%
%                \strut\vfill%
                \ifthenelse{\equal{\@publisher}{\empty}}%
                    {\relax}%
                    {%
                        \@publisher%
                        \ifthenelse{\equal{\@printed}{\empty}}%
                            {\relax}%
                            %{\mbox{}\\[\medskipamount]\@printed}%
                            {\medbreak\@printed}%
                    }%
                \ifthenelse{\equal{\@copytext}{\empty}}%
                    {\relax}%
                    {%
                        \ifthenelse{\equal{\@publisher}{\empty}}%
                            {\relax}%
                            %{\mbox{}\\[\bigskipamount]}%
                            {\medbreak}%
                        \@copytext%
                        \ifthenelse{\equal{\@rights}{\empty}}%
                            {\relax}%
                            %{\mbox{}\\[\medskipamount]\@rights}%
                            {\smallbreak\@rights}%
                    }%
                \mbox{}\vfill%
                \ifthenelse{\equal{\@trademarks}{\empty}}%
                    {\relax}%
                    {\@trademarks}%
                \ifthenelse{\equal{\@record}{\empty}}%
                    {\relax}%
                    {\smallbreak\@record}%
                \ifthenelse{\equal{\@support}{\empty}}%
                    {\relax}%
                    {%
                        \ifthenelse
                            {\equal{\@trademarks}{\empty}\and\equal{\@record}{\empty}}%
                            {\relax}%
                            {\smallbreak}%
                        \@support%
                    }%
                \blankfooter%
                \cleardoublepage%
            \end{bodywide}%
        \fi%
        %  \global\let\@thanks\@empty
        %  \global\let\@author\@empty
        %  \global\let\@date\@empty
        %  \global\let\@title\@empty
        %  \global\let\@subtitle\@empty
        \gdef\maketitle\relax%
        \gdef\title##1{\relax}%
        \gdef\subtitle##1{\relax}%
        \gdef\author##1{\relax}%
        \gdef\institution##1{\relax}%
        \gdef\documenttype##1{\relax}%
        \gdef\advisor##1{\relax}%
        \gdef\splash##1{\relax}%
        \gdef\publisher##1{\relax}%
        \gdef\copytext##1{\relax}%
        \gdef\rights##1{\relax}%
        \gdef\printed##1{\relax}%
        \gdef\trademarks##1{\relax}
        \gdef\record##1{\relax}%
        \gdef\@record@text{\relax}%
        \gdef\support##1{\relax}%
        \gdef\artwork##1{\relax}%
        \gdef\dedicatory##1{\relax}%
        \gdef\minutestext##1{\relax}%
        \gdef\minutesdate##1{\relax}%
%        \global\def\thanks##1{\relax}%
        \global\def\and{\relax}%
    \endgroup%
    }
    \global\newcounter{memberscount}%
    \global\setcounter{memberscount}{0}%
    \newcommand\boardmember[1]%
    {%
        \expandafter\newsavebox\csname memberbox\arabic{memberscount}\endcsname%
        \expandafter\savebox\csname memberbox\arabic{memberscount}\endcsname%
        {%
            \hbox{%
                \begin{minipage}[t]{0.45\textwidth}%
                    \hrule%
                    \smallbreak%
                    \begin{center}%
                        \begin{tabular}{c}%
                            #1 %
                        \end{tabular}%
                    \end{center}%
                \end{minipage}%
            }%
        }%
        \stepcounter{memberscount}%
    }
    \newcommand\makeminutes{%
        \begingroup%
            \ifx\@minutestext\empty%
            \else%
                \begin{blankfooterpage}%
                    \begin{bodywide}[minutes]%
                        \centerblock{\Huge\@institution} \\%
                        \null\vfill%
                        \begin{minipage}{0.95\hsize}%
                            \@minutestext%
                        \end{minipage}%
                        \bigbreak%
                        \vfill%\vspace{3\bigskipamount}%
                        \centerblock{%
                            \begin{tabular}{c@{\hspace*{0.05\textwidth}}c}%
                                \multicolumn{2}{c}{%
                                    \expandafter\usebox\csname memberbox0\endcsname%
                                }%
                                \def\nextsep{\\[7\bigskipamount]}%
                                \newcounter{cnt}%
                                \setcounter{cnt}{1}%
                                \newcounter{lim}%
                                \setcounter{lim}{\value{memberscount}}%
                                \ifodd \value{lim}%
                                \else%
                                    \addtocounter{lim}{-1}%
                                \fi%
                                \@whilenum \value{cnt} < \value{lim} \do%
                                {%
                                    \nextsep%
                                    \multicolumn{1}{c}{%
                                        \expandafter\usebox\csname memberbox\arabic{cnt}\endcsname
                                    }%
                                    \ifodd \value{cnt}%
                                        \def\nextsep{&}%
                                    \else%
                                        \def\nextsep{\\[7\bigskipamount]}%
                                    \fi%
                                    \stepcounter{cnt}%
                                }%
                                \ifnum \value{lim} < \value{memberscount}%
                                    \\[7\bigskipamount]%
                                    \multicolumn{2}{c}{%
                                        \expandafter\usebox\csname memberbox\arabic{cnt}\endcsname%
                                    }%
                                \fi%
                            \end{tabular}
                        }
                        \bigbreak%
                        \vfill%\vspace{3\bigskipamount}%
                        \begin{minipage}{0.95\hsize}%
                            \@minutesdate%
                        \end{minipage}%
                    \end{bodywide}%
                \end{blankfooterpage}%
                \cleardoublepage%
            \fi%
            \global\def\minutestext##1{\relax}%
            \global\def\minutesdate##1{\relax}%
        \endgroup%
    }
    \newcommand\makededicatory{%
        \begingroup%
            \ifx\@dedicatory\empty%
            \else%
                \begin{blankfooterpage}
                    \begin{bodywide}[dedicatory]%
                        \centerblock{\calligraphicfont\@dedicatory}%
                        %\begin{tabular}{p{0.50\textwidth}}%
                        %   \parbox{0.40\textwidth}{\flushright \itshape \@dedicatory}%
                        %\end{tabular}%
                    \end{bodywide}%
                \end{blankfooterpage}%
                \cleardoublepage%
            \fi%
            \global\def\dedicatory##1{\relax}%
        \endgroup%
    }
    %
%    \newcommand\makeauthorisation{%
%        \begingroup%
%            \ifx\@authorisation\empty%
%            \else%
%                \begin{blankfooterpage}
%                    \begin{bodywide}[authorisation]%
%                        \centerblock{\Huge\scshape\@institution} \\%
%                        \bigbreak%
%                        \centerblock{\Large\scshape\@author}%
%                        \null\vfill%
%                        \smallbreak%
%                        \centerblock{\@authorisation}%
%                        \smallbreak%
%                        . \usebox\csname memberbox0 \endcsname .%
%                        \bigbreak%
%                        ------------------
%                        \count1=\value{memberscount}
%                        Board members: \the\count1\par%
%                        -----------------
%                        \bigbreak%
%                        \vfill\null%
%                    \end{bodywide}%
%                \end{blankfooterpage}%
%                \cleardoublepage%
%            \fi%
%            \global\def\authorisation##1{\relax}%
%        \endgroup%
%    }
    \newcommand\makeartwork{%
    \begingroup%
        \ifx\@artwork\empty%
        \else%
            \begin{blankfooterpage}%
                \begin{bodywide}[artwork]%
                    \vbox{\centerblock{\calligraphicfont\@artwork}}%
                \end{bodywide}%
            \end{blankfooterpage}%
            \cleardoublepage%
        \fi%
        \global\def\artwork##1{\relax}%
    \endgroup%
    }
\else
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{empty}%\@thanks
  \endgroup
  \setcounter{footnote}{0}%
%  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
%  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\@subtitle\@empty
  \global\let\title\relax
  \global\let\subtitle\relax
  \global\let\splash\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  %\let \footnote \thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}
\fi
\newcommand*\chaptermark[1]{}
\setcounter{secnumdepth}{3}
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thechapter {\@arabic\c@chapter}
\renewcommand \thesection {\thechapter.\@arabic\c@section}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand\thesubsubsection{\thesubsection .\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
\newcommand\@chapapp{\chaptername}

\newcommand\includepart[3][\empty]{%
    \def\@runningtitle{#1}%
    \ifx\@runningtitle\empty%
        \part[\@runningtitle]{#2}%
    \else%
        \part{#2}%
    \fi%
    \include{#3}%
}

\newcount\@partlevel
\@partlevel=0
\newcount\@outlevel
\@outlevel=0

\newcommand\part{%
    \@partlevel=1%
    \cleardoublepage%
    \thispagestyle{empty}%
    \if@twocolumn
    \onecolumn
    \@tempswatrue
    \else
    \@tempswafalse
    \fi
    \null\vfill%
    \secdef\@part\@spart
}

\def\@part[#1]#2{%
    \special{pdf:outline 1 << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
    \ifnum \c@secnumdepth >-2\relax%
      \refstepcounter{part}%
      %\addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
      \addcontentslinenonumber{toc}{part}{\protect\numberline{\thepart}#1}%
    \else%
      %\addcontentsline{toc}{part}{#1}%
      \addcontentslinenonumber{toc}{part}{#1}%
    \fi%
    \markboth{}{}%
    \begin{bodywide}[part]
        \begin{rules}%
            %\fbox{\centerblock{\Huge \bfseries \itshape \partname~\thepart}}%
            \centerblock{\Huge \bfseries \itshape \partname~\thepart}%
            \bigbreak%
            %\fbox{\centerblock{\Huge \bfseries \itshape #2}}%
            \centerblock{\Huge \bfseries \itshape #2}%
        \end{rules}%
    \end{bodywide}%
    \@endpart%
}
\def\@spart#1{%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \Huge \bfseries #1 \par}%
    \@endpart}

\def\@endpart{%
    \vfill%
    \null%
    \blankfooter%
    \newpage%
    \if@twoside%
        \null%
        \thispagestyle{empty}%
        \newpage%
    \fi%
    \if@tempswa%
        \twocolumn%
    \fi%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%\newcommand\chapter{%
%    %\rc@everychaptertoks%
%    %\if@openright\cleardoublepage\else\clearpage\fi
%    \cleardoublepage%
%    \thispagestyle{plain}%
%    \refstepcounter{chapter}%
%    \global\@topnum\z@%
%    \@afterindentfalse%
%    \@firstsectrue%
%    \secdef\@chapter\@schapter%
%}
%
%\def\@chapter[#1]#2{%
%    \ifnum \c@secnumdepth >\m@ne%
%        \if@mainmatter
%            %\typeout{\@chapapp\space\thechapter.}%
%            \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
%        \else%
%            \addcontentsline{toc}{chapter}{#1}%
%        \fi%
%    \else%
%        \addcontentsline{toc}{chapter}{#1}%
%    \fi%
%    \chaptermark{#1}%
%    \addtocontents{lof}{\protect\addvspace{\bigskipamount}}%
%    \addtocontents{lot}{\protect\addvspace{\bigskipamount}}%
%    \addtocontents{lop}{\protect\addvspace{\bigskipamount}}%
%    \if@twocolumn%
%        \@topnewpage[\@makechapterhead{#2}]%
%    \else%
%        \@makechapterhead{#2}%
%        \@afterheading%
%    \fi%
%}
%
%\def\@schapter#1{%
%    \if@twocolumn%
%        \bgroup\@topnewpage[\bgroup\parskip=defaultparskip\@makeschapterhead{#1}\egroup]\egroup%
%    \else%
%        \@makeschapterhead{#1}%
%        \@afterheading%
%    \fi%
%}
%
%\def\@makechapterhead#1{%
%  \special{pdf:outline 2 << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
%  \vspace*{50pt}%
%  \begin{bodywide}[chapterhead]%
%    \begin{rules}%
%        \parskip=\defaultparskip%  To correct the spacing between rules in the index
%        \ifnum \c@secnumdepth >\m@ne%
%            \if@mainmatter%
%                %\noindent\fbox{\rightblock{\Huge \bfseries \itshape \@chapapp \space \thechapter}} \\[\bigskipamount]%
%                \rightblock{\Huge \bfseries \itshape \@chapapp \space \thechapter}%
%                \bigbreak%
%            \fi%
%        \fi%
%        %\noindent\fbox{\rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}}%
%        \rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}%
%    \end{rules}%
%  \end{bodywide}%
%  \vspace*{20pt}%
%  \nobreak%
%  %\thispagestyle{plain}%
%  \hyperref@label{chapter:\thechapter}%
%  %\typeout{chapter:\thechapter}%
%}
%
%\def\@makeschapterhead#1{%
%  \special{pdf:outline 2 << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
%  \vspace*{50pt}%
%  \begin{bodywide}[schapterhead]%
%    \begin{rules}%
%        %\noindent\fbox{\rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}}%
%        \rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}%
%    \end{rules}%
%  \end{bodywide}%
%  \vspace*{20pt}%
%  \nobreak%
%  %\thispagestyle{empty}%
%  \hyperref@label{chapter:\thechapter}%
%  %\typeout{chapter:\thechapter}%
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Sanitise PDF titles a little

\RequirePackage{pdftexcmds}

\def\pdf@sanitise@string@temp{}
\def\pdf@sanitise@string@result{}
\long\def\@strip@macro#1>{}
\def\pdf@sanitise@string#1{%
    \def\pdf@sanitise@string@temp{#1}%
    \def\pdf@sanitise@string@result{%
        \expandafter\@strip@macro\meaning\pdf@sanitise@string@temp%
    }%
    \pdf@escapestring{\pdf@sanitise@string@result}%
}

\newtoks\sanitised@pdf@title
\sanitised@pdf@title={}

% End sanitising pdf titles

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand\chapter{%
    %\rc@everychaptertoks%
    %\if@openright\cleardoublepage\else\clearpage\fi
    \cleardoublepage%
    \thispagestyle{plain}%
    \refstepcounter{chapter}%
    \global\@topnum\z@%
    \@afterindentfalse%
    \@firstsectrue%
    \secdef\@chapter\@schapter%
}

\def\@chapter[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne%
        \if@mainmatter
            %\typeout{\@chapapp\space\thechapter.}%
            \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
        \else%
            \addcontentsline{toc}{chapter}{#1}%
        \fi%
    \else%
        \addcontentsline{toc}{chapter}{#1}%
    \fi%
    \chaptermark{#1}%
    \addtocontents{lof}{\protect\addvspace{\bigskipamount}}%
    \addtocontents{lot}{\protect\addvspace{\bigskipamount}}%
    \addtocontents{lop}{\protect\addvspace{\bigskipamount}}%
    \if@twocolumn%
        \@topnewpage[\@makechapterhead{#2}]%
    \else%
        \@makechapterhead{#2}%
        \@afterheading%
    \fi%
}

\def\@schapter#1{%
    \if@twocolumn%
        \bgroup\@topnewpage[\bgroup\parskip=defaultparskip\@makeschapterhead{#1}\egroup]\egroup%
    \else%
        \@makeschapterhead{#1}%
        \@afterheading%
    \fi%
}

\def\tempa{}
\def\sanitise@pdf@text#1{%
    \def\tempa{#1}%
    \expandafter\@strip@macro\meaning\tempa%
}

\def\@makechapterhead#1{%
    \@outlevel=\@partlevel%
    \advance\@outlevel by 1%
    \special{pdf:outline \the\@outlevel  << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
    \vspace*{50pt}%
    \hyperref@label{chapter:\thechapter}%
    \begin{bodywide}[chapterhead]%
    \begin{rules}%
        \parskip=\defaultparskip%  To correct the spacing between rules in the index
        \ifnum \c@secnumdepth >\m@ne%
            \if@mainmatter%
                %\noindent\fbox{\rightblock{\Huge \bfseries \itshape \@chapapp \space \thechapter}} \\[\bigskipamount]%
                \rightblock{\Huge \bfseries \itshape \@chapapp \space \thechapter}%
                \bigbreak%
            \fi%
        \fi%
        %\noindent\fbox{\rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}}%
        \rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}%
    \end{rules}%
    \end{bodywide}%
    \vspace*{20pt}%
    \nobreak%
    %\thispagestyle{plain}%
    %\typeout{chapter:\thechapter}%
}

\def\@makeschapterhead#1{%
    \@outlevel=\@partlevel%
    \advance\@outlevel by 1%
    \special{pdf:outline \the\@outlevel  << /Title (#1) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
    \vspace*{50pt}%
    \begin{bodywide}[schapterhead]%
        \begin{rules}%
            %\noindent\fbox{\rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}}%
            \rightblock{\Huge\bfseries\itshape\parfillskip\z@skip #1}%
        \end{rules}%
    \end{bodywide}%
    \vspace*{20pt}%
    \nobreak%
    %\thispagestyle{empty}%
    \hyperref@label{chapter:\thechapter}%
    %\typeout{chapter:\thechapter}%
}

%\def\@makeschapterhead#1{%
%  \vspace*{50\p@}%
%  {\parindent \z@ \raggedright
%    \normalfont
%    \interlinepenalty\@M
%    \Huge \bfseries #1 XX \par\nobreak
%    \vskip 40\p@
%  }
%}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\@sect#1#2#3#4#5#6[#7]#8{%
  %\typeout{!1=#1!2=#2!3=#3!4=#4!5=#5!6=#6!7=#7!8=#8!}\show\show%
  \@outlevel=#2%
  \advance\@outlevel by 2%
  \ifnum\@partlevel<1%
        \advance\@outlevel by -1%
  \fi%
  \ifnum\@outlevel<4%
        \special{pdf:outline \the\@outlevel << /Title (#7) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
  \fi%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #6{%
        \@hangfrom{\hskip #3\relax\@svsec}%
          \interlinepenalty \@M #8\@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}

\let\save@startsection\@startsection
\def\@startsection#1#2#3#4#5#6{%
    %\typeout{#1--#2--#3--#4--#5--#6}\show\show%
    \save@startsection{#1}{#2}{#3}{#4}{#5}{\hyperref@label{#1:\csname the#1\endcsname}#6}%
}

\newcommand\section{%
      \if@firstsec%
            \@firstsecfalse%
            \@droptrue%
      \fi%
%   \@startsection {section}{1}{\z@}%
%       {-3.5ex \@plus -1ex \@minus -.2ex}%
%       {2.3ex \@plus.2ex}%
%       {\normalfont\Large\bfseries}%
    \@startsection {section}{1}{\z@}%
        {-1\defaultparskip}%
        {0.25\defaultparskip}%
        {\normalfont\Large\bfseries}%
}

\newcommand\subsection{%
%     \@startsection{subsection}{2}{\z@}%
%         {-3.25ex\@plus -1ex \@minus -.2ex}%
%         {1.5ex \@plus .2ex}%
%         {\normalfont\large\bfseries}%
    \@startsection{subsection}{2}{\z@}%
        {-1\defaultparskip}%
        {0.25\defaultparskip}%
        {\normalfont\large\bfseries}%
}

\newcommand\subsubsection{%
%     \@startsection{subsubsection}{3}{\z@}%
%         {-3.25ex\@plus -1ex \@minus -.2ex}%
%         {1.5ex \@plus .2ex}%
%         {\normalfont\normalsize\bfseries}%
    \@startsection{subsubsection}{3}{\z@}%
        {-1\defaultparskip}%
        {0.25\defaultparskip}%
        {\normalfont\normalsize\bfseries}%
}

% Paragraphs and subparagraphs must not be hyperlinked

\newcommand\paragraph{%
%     \save@startsection{paragraph}{4}{\z@}%
%         {3.25ex \@plus1ex \@minus.2ex}%
%         {-1em}%
%         {\normalfont\normalsize\bfseries}%
    \save@startsection{paragraph}{4}{\z@}%
        {-1\defaultparskip}%
        {-1em}%
        {\normalfont\normalsize\bfseries}%
}

\newcommand\subparagraph{%
%     \save@startsection{subparagraph}{5}{\parindent}%
%         {3.25ex \@plus1ex \@minus .2ex}%
%         {-1em}%
%         {\normalfont\normalsize\bfseries}%
    \save@startsection{subparagraph}{5}{\parindent}%
        {-1\defaultparskip}%
        {-1em}%
        {\normalfont\normalsize\bfseries}%
}


\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi \leftmargin  \leftmargini \setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em} \setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi \setlength  \labelsep  {.5em} \setlength
\labelwidth{\leftmargini} \addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty \@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
%\newcommand\labelitemi{\textbullet}
%\newcommand\labelitemii{\normalfont\bfseries \textendash}
%\newcommand\labelitemiii{\textasteriskcentered}
%\newcommand\labelitemiv{\textperiodcentered}
\newcommand\labelitemi{\ensuremath{\bullet}}
\newcommand\labelitemii{\ensuremath{\diamond}}
\newcommand\labelitemiii{\ensuremath{\star}}
\newcommand\labelitemiv{\ensuremath{\vartriangleright}}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep{\bfseries #1}}
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
%\newenvironment{quotation}
%               {\list{}{\listparindent 1.5em%
%                        \itemindent    \listparindent
%                        \rightmargin   \leftmargin
%                        \parsep        \z@ \@plus\p@}%
%                \item\relax}
%               {\endlist}
\if@compatibility
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }
\fi
\newcommand\appendix{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}}
\setlength\arraycolsep{5\p@} \setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@} \setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep} \skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@} \setlength\fboxrule{.4\p@} \@addtoreset
{equation}{chapter}
\renewcommand\theequation
  {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@equation}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@} \setlength\belowcaptionskip{0\p@}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\itshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{2}

%%%%%%%%%%%%%%% MANY CHANGES BELOW

\newcommand\tableofcontents{%
    \special{pdf:outline 1 << /Title (\pdfDocumentLists) /Dest [ @thispage /XYZ @xpos @ypos null ] >>}%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname}%
    \markboth{\contentsname}{\contentsname}%
%    \chapter{\contentsname}%
    \thispagestyle{plain}%
    \begingroup
        \@starttoc{toc}%
    \endgroup
    \if@restonecol\twocolumn\fi
    }
%\newcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}
%\newcommand*\l@subsection{\@dottedtocline{2}{3.8em}{3.2em}}
%\newcommand*\l@subsubsection{\@dottedtocline{3}{7.0em}{4.1em}}
%\newcommand*\l@paragraph{\@dottedtocline{4}{10em}{5em}}
%\newcommand*\l@subparagraph{\@dottedtocline{5}{12em}{6em}}
\newcommand\listoffigures{%
    \ifx\showlistoffigures\@undefined%
    \else%
        \if@twocolumn
        \@restonecoltrue\onecolumn
        \else
        \@restonecolfalse
        \fi
        \chapter*{\listfigurename}%
        \markboth{\listfigurename}{\listfigurename}%
    %    \chapter{\listfigurename}%
        \thispagestyle{plain}%
        \@starttoc{lof}%
        \if@restonecol\twocolumn\fi%
    \fi%
}

\newcommand\listoftables{%
    \ifx\showlistoftables\@undefined%
    \else%
        \if@twocolumn
        \@restonecoltrue\onecolumn
        \else
        \@restonecolfalse
        \fi
        \chapter*{\listtablename}%
        \markboth{\listtablename}{\listtablename}%
    %    \chapter{\listtablename}%
        \thispagestyle{plain}%
        \@starttoc{lot}%
        \if@restonecol\twocolumn\fi
    \fi%
}

% If natbib is not loaded
%\newdimen\bibindent
%\setlength\bibindent{1.5em}
%
%\def\bibitem{%
%    \prepare@wide@margins[]{bib}%
%    \let\xxxpar\par%
%    \def\par{\pagelabel{\bodywide@label}\let\par\xxxpar\par}%
%    \@ifnextchar[\@lbibitem\@bibitem%
%}
%
%\def\@lbibitem[#1]#2{%
%    \item[\@biblabel{#1}\hfill]%
%    \if@filesw%
%    {%
%        \let\protect\noexpand%
%        \immediate\write\@auxout{\string\bibcite{#2}{#1}}%
%    }%
%    \fi%
%    \ignorespaces%
%}
%
%\def\@bibitem#1{%
%    \item%
%        \if@filesw%
%            \immediate\write\@auxout
%            {\string\bibcite{#1}{\the\value{\@listctr}}}
%        \fi%
%        \ignorespaces%
%}
%
%\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
%\let\@openbib@code\@empty
%
%\newenvironment{thebibliography}[1]{%
%%    \chapter*{\bibname\@mkboth{\bibname}{\bibname}}%
%    \chapter{\bibname}%
%    \thispagestyle{empty}%
%    \bgroup%
%        \list{\@biblabel{\@arabic\c@enumiv}}%
%            {%
%                \settowidth\labelwidth{\@biblabel{#1}}%
%                \leftmargin\labelwidth%
%                \advance\leftmargin\labelsep%
%                \usecounter{enumiv}%
%                \let\p@enumiv\@empty
%                \renewcommand\theenumiv{\@arabic\c@enumiv}%
%            }%
%            \sloppy%
%            \clubpenalty4000%
%            \@clubpenalty \clubpenalty%
%            \widowpenalty4000%
%            \sfcode`\.\@m%
%}%
%{%
%            \def\@noitemerr{\@latex@warning{Empty `thebibliography'environment}}%
%        \endlist%
%    \egroup%
%    %\@floatplacement   % El original tenía esto
%}
%
% If natbib is loaded... see AtEndOfPackage

\newenvironment{theindex}%
{%
    \cleardoublepage%
    \bgroup%
        \global\columnseprule=0pt%
        \global\columnsep=0.5cm%
        \global\col@number=2%
        \global\@twocolumntrue%
        \global\@firstcolumntrue%
        \chapter{\indexname}%
        \columnwidth=\bodywidth%
        \divide\columnwidth\tw@%
        \advance\columnwidth-\columnsep%
        \hsize=\columnwidth%
        \parskip=10pt%
        \small%
        \hfuzz=5pt%
        \let\item\@idxitem%
        \begingroup%
            \hangindent=40pt%
}%
{%
            \par\noindent%
        \endgroup%
        \cleardoublepage%
        \global\columnwidth\textwidth
        \global\hsize\columnwidth
        \global\linewidth\columnwidth
        \global\@twocolumnfalse
        \col@number=1
        \@floatplacement   % El original tenía esto
    \egroup%
}

%        \noindent\rule{\hsize}{3pt}\par%

\gdef\@idxitem{% DON'T CHANGE THE LINE ABOVE
        \par\noindent%
    \endgroup%
    \prepare@wide@margins[yes]{theindex}%
    \marginparsep=0pt%
    \marginparwidth=0pt%
    \begingroup%
        \advance\hsize by -\marginalwidth% Workaround!!!!!!!!!
        \hangindent=40pt%
        \parskip=0pt%
}

\newcommand\subitem{\@idxitem\hspace*{20pt}}
\newcommand\subsubitem{\@idxitem\hspace*{40pt}}
\newcommand\indexspace{\par\vskip 10pt plus 5pt minus 3pt\relax}


%\newcommand\@idxitem{%
%    %\mbox{}\newline%\nobreak\par%\nobreak\par%
%    \nobreak\par\hangindent 30pt\noindent%
%    \prepare@wide@margins[yes]{theindex}%
%%    \hsize=0.3\columnwidth%
%}
%\newcommand\subitem{\@idxitem\hspace*{20pt}}
%\newcommand\subsubitem{\@idxitem\hspace*{30pt}}
%\newcommand\indexspace{\par \vskip 10pt plus 5pt minus 3pt\relax}

\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
\@addtoreset{footnote}{chapter}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{Figures}
\newcommand\listtablename{Tables}
\newcommand\bibname{References}
\newcommand\indexname{Index}
%\newcommand\figurename{Figure}
%\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\chaptername{Chapter}
\newcommand\appendixname{Appendix}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@} \setlength\columnseprule{0\p@}
\pagestyle{headings} \pagenumbering{arabic} \if@twoside \else
  \raggedbottom
\fi \if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi

\endinput
