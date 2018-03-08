<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:tex="placeholder.uri" exclude-result-prefixes="tex">
  <xsl:output method="text"/>

  <!-- The name of this file is tei2LaTeX -->
  <!-- This xslt script converts TEI xml to LaTeX -->



  <!-- options for the apparatus variants footnotes -->
  <!-- Should we shorten the lemma in the footnote if the lemma has more than X words? 0 for no, other number for the max length of lemma in the note (in words) -->
  <xsl:param name="shortenLem">15</xsl:param>
  <!-- What word or phrase do you want to use in the critical notes to indicate that a variant is an omission? -->
  <xsl:param name="varOm">om.</xsl:param>
  <!-- What word or phrase do you want to use in the critical notes to indicate that a variant is an addition? -->
  <xsl:param name="varAdd">add.</xsl:param>
  <!-- Possivility to change the default lemma separator -->
  <xsl:param name="lemSep"/>
  <!-- Should we display the contents of tei:quote in italics? 0 for no, 1 for yes-->
  <xsl:param name="italQuote">0</xsl:param>
  <!-- Should we display le sigla of witnesses in italics in the critical notes? -->
  <xsl:param name="italWit">1</xsl:param>


  <!-- Page size? Accepted values: 
 a0paper, a1paper, a2paper, a3paper, a4paper, a5paper, a6paper, b0paper, b1paper, b2paper, b3paper, b4paper, b5paper, b6paper, c0paper, c1paper, c2paper, c3paper, c4paper, c5paper, c6paper, b0j, b1j, b2j, b3j, b4j, b5j, b6j, ansiapaper, ansibpaper, ansicpaper, ansidpaper, ansiepaper, letterpaper, executivepaper, legalpaper -->
  <xsl:param name="pageSize">a4paper</xsl:param>
  <!-- Setting the size of the margins, in cm -->
  <xsl:param name="marginInner">3</xsl:param>
  <xsl:param name="marginOuter">3</xsl:param>
  <xsl:param name="marginTop">3</xsl:param>
  <xsl:param name="marginBottom">3</xsl:param>
  <xsl:param name="marginBinding">0.5</xsl:param>


  <!-- Set main language (useful for hyphenation rules)  -->
  <xsl:param name="lang1">latin</xsl:param>
  <!-- Set other language (useful for hyphenation rules)  -->
  <xsl:param name="lang2">english</xsl:param>


  <!-- Running titles for odd and even pages; note that you can include LaTeX instructions in the text, for instance if you want your running title text displayed in small capitals, use the value: "\textsc{Your Text}" instead of just "Your Text"  -->
  <xsl:param name="rTitleOdd">\textsc{Caesarius Heisterbachensis}</xsl:param>
  <xsl:param name="rTitleEven">\textsc{Homiliae de infantia}</xsl:param>
  <!-- Running titles position for odd and even pages; accepted values: L, C, R  -->
  <xsl:param name="rTitleOddPos">C</xsl:param>
  <xsl:param name="rTitleEvenPos">C</xsl:param>
  <!-- Running titles size for odd and even pages. Accepted values are relative: nothing (default), then from smallest to largest: tiny, scriptsize, footnotesize, normalsize, large, Large, LARGE, huge, Huge -->
  <xsl:param name="rTitleOddSize"/>
  <xsl:param name="rTitleEvenSize"/>


  <!-- Should we wrap the contents of tei:quote in quotation marks? Accepted values = 0 (No), 1 (Yes) -->
  <xsl:param name="qmQuote">0</xsl:param>
  <!-- If so, which style of quotation marks should we use? Indicate the left and right marks, separated by a | sign -->
  <xsl:param name="qmQuoteStyle">«|»</xsl:param>
  <!-- Should we put a non-breaking space between the quotation mark and the quoted text?  Accepted values = 0 (No), 1 (Yes) -->
  <xsl:param name="qmQuoteNoBr">1</xsl:param>

  <!-- start number of pagination; used only if different from 0; The value must always be an arabic numeral, even if you are using a different numbering style. -->
  <xsl:param name="fromPage">2</xsl:param>
  <!-- Is there a page number on the first page? Accepted values: 0 = No, 1 = Yes -->
  <xsl:param name="pageNumFirstPage">0</xsl:param>
  <!-- Page numbering style: accepted values are
 arabic: arabic numerals; roman: lowercase roman numerals; Roman: uppercase roman numerals; alph: lowercase letters; Alph: uppercase letters -->
  <xsl:param name="pageNumberingStyle">arabic</xsl:param>
  <!-- Should the page num be placed in the header, or footer? Accepted values: head, foot. -->
  <xsl:param name="pageNumPlace">head</xsl:param>
  <!-- Where should the page number be positioned in the header or footer? Accepted values: L (left), R (right), C (center), LE,RO (left on even pages, right on odd pages, i.e. outer margin of each page), RE,LO (inner margin) -->
  <xsl:param name="pageNumPosition">LE,RO</xsl:param>
  <!-- Size of the footer text? Accepted values are relative: nothing (default), then from smallest to largest: tiny, scriptsize, footnotesize, normalsize, large, Large, LARGE, huge, Huge -->
  <xsl:param name="pageNumSize"/>



  <!-- to number the lines; options can be: page, pstart or section  -->
  <xsl:param name="lineationStyle">page</xsl:param>
  <!-- lineation start value (default = 0) -->
  <xsl:param name="lineationStart">0</xsl:param>
  <!-- lineation step (default = 5) -->
  <xsl:param name="lineationStep">5</xsl:param>


  <!-- base font size of the document: 8pt, 9pt, 10pt, 11pt, 12pt, 14pt, 17pt, and 20pt. -->
  <xsl:param name="baseFontSize">12</xsl:param>



  <!-- do you want to print the document title? Yes if value is different from 0 -->
  <xsl:param name="printTitle">1</xsl:param>
  <!-- How big should we print the title? Accepted values are large, Large, LARGE, huge, Huge.  Those sizes are relative to the normal font size in the document.  For more information see: http://jacques-andre.fr/fontex/taille.pdf -->
  <xsl:param name="printTitleSize">Large</xsl:param>
  <!-- Should we print the title in small caps or caps? Accepted values: 0 (no formatting), smallcaps and caps -->
  <xsl:param name="printTitleStyle">smallcaps</xsl:param>



  <!-- do you want to print the list of witnesses? Yes if value is different from 0 -->
  <xsl:param name="printListWit">1</xsl:param>



  <!-- separator between apparatus entries on the same line; leave empty if you don't want to add one -->
  <xsl:param name="separatorAppEntries"/>
  <!-- Size of the blank space before each series of notes (in pt) -->
  <xsl:param name="spaceBeforeNotesA">18</xsl:param>
  <xsl:param name="spaceBeforeNotesB">18</xsl:param>



  <!-- How to display the contents of tei:head ? -->
  <!-- Should it be in bold? Accepted values: 1 for bold -->
  <xsl:param name="headStyleBold">1</xsl:param>
  <!-- vSpace before and after each tei:head, in cm -->
  <xsl:param name="headStylevSpaceBefore">0</xsl:param>
  <xsl:param name="headStylevSpaceAfter">0.1</xsl:param>
  <!-- How big should we print the tei:head elements ? Accepted values are 0 (no specification), large, Large, LARGE, huge, Huge.  Those sizes are relative to the normal font size in the document. -->
  <xsl:param name="headSize">large</xsl:param>
  <!-- How should we align the tei:head? Accepted values: center (to be continued) -->
  <xsl:param name="headAlign"/>



  <!-- vSpace after each tei:p, in cm -->
  <xsl:param name="parStylevSpace">0.1</xsl:param>

  <!-- Side notes for folios -->
  <!-- Write the folio numbers in the margins? 1 = Yes, 0 = No-->
  <xsl:param name="folioNotes">1</xsl:param>
  <!-- Location of side notes? Accepted values: left, right, inner, or outer -->
  <xsl:param name="sideNoteLocation">inner</xsl:param>
  <!-- Optional separator materialising the folio limit in the text -->
  <xsl:param name="folioInTextMarker"> ||</xsl:param>
  <!-- Should we print the ms. siglum before the folio number? 1 = Yes, 0 = No -->
  <xsl:param name="folioNotesMs">0</xsl:param>
  <!-- Should we print all teipb? 1 = Yes, 0 = No, only tei:pb related to a particular witness  -->
  <xsl:param name="folioNotesAll">0</xsl:param>
  <!-- If we must print only tei:pb related to a particular witness, tell us in which attribute of tei:pb is stored the value linking to this witness... -->
  <xsl:param name="folioNoteAttribute">ed</xsl:param>
  <!-- ...and the value we're looking for in this attribute -->
  <xsl:param name="folioNoteAttributeValue">T1</xsl:param>


  <!-- Do you want to add an index nominum? 0 = no, 1 = yes-->
  <xsl:param name="idxNom">1</xsl:param>
  <!-- Do you want to add a prologue to the index nominum? -->
  <xsl:param name="idxNomPrologue"/>
  <!-- Which title do you want for the index nominum? -->
  <xsl:param name="idxNomTitle">My Index Nominum</xsl:param>
  <!-- Do you want to add an index locorum? 0 = no, 1 = yes-->
  <xsl:param name="idxLoc">1</xsl:param>
  <!-- Do you want to add a prologue to the index nominum? -->
  <xsl:param name="idxLocPrologue"/>
  <!-- Which title do you want for the index locorum? -->
  <xsl:param name="idxLocTitle">Index locorum</xsl:param>



  <xsl:template match="/">
    <xsl:text>\documentclass{article}
    \usepackage{polyglossia,fontspec,xunicode}
    \usepackage{libertine} 
    \usepackage{soul} 
    \usepackage{hyperref}
    </xsl:text>
    <xsl:if test="$idxNom = '1' or $idxLoc = '1'">
      <xsl:text>
        \usepackage[innote]{indextools}
      </xsl:text>
      <!--    \indexsetup{}  -->
      <xsl:if test="$idxNom = '1'">
        <xsl:text>
          \makeindex[title={</xsl:text>
        <xsl:value-of select="$idxNomTitle"/>
        <xsl:text>},name=nominum]</xsl:text>
      </xsl:if>
      <xsl:if test="$idxLoc = '1'">
        <xsl:text>
          \makeindex[title={</xsl:text><xsl:value-of select="$idxLocTitle"/>
        <xsl:text>},name=locorum]</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:text>
      \usepackage[</xsl:text><xsl:value-of select="$baseFontSize"/><xsl:text>pt]{extsizes}</xsl:text>
    <xsl:text>
      \usepackage[</xsl:text><xsl:value-of select="$pageSize"
      /><xsl:text>, twoside, bindingoffset=</xsl:text><xsl:value-of select="$marginBinding"
      /><xsl:text>cm, inner=</xsl:text><xsl:value-of select="$marginInner"
      /><xsl:text>cm, outer=</xsl:text><xsl:value-of select="$marginOuter"
      /><xsl:text>cm, top=</xsl:text><xsl:value-of select="$marginTop"
      /><xsl:text>cm, bottom=</xsl:text><xsl:value-of select="$marginBottom"/><xsl:text>cm]{geometry} </xsl:text>
    <!-- Fancy headers and footers -->
    <xsl:text>
    \usepackage{fancyhdr} 
    \fancyfoot{}
    \renewcommand{\headrulewidth}{0pt} % remove the header 
    \pagestyle{fancy}</xsl:text>
    <xsl:choose>
      <xsl:when test="$pageNumPlace = 'head'"><xsl:text>
        \fancyhead[</xsl:text><xsl:value-of
          select="$pageNumPosition"/><xsl:text>]{</xsl:text><xsl:value-of select="$pageNumSize"
        /><xsl:text>\thepage}</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>
        \fancyfoot[</xsl:text><xsl:value-of
          select="$pageNumPosition"/><xsl:text>]{</xsl:text><xsl:value-of select="$pageNumSize"
        /><xsl:text>\thepage}</xsl:text></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$rTitleEven"><xsl:text>
      \fancyhead[</xsl:text><xsl:value-of
        select="$rTitleEvenPos"/><xsl:text>E]{</xsl:text><xsl:value-of select="$rTitleEvenSize"
        /><xsl:value-of select="$rTitleEven"/><xsl:text>} </xsl:text></xsl:if>
    <xsl:if test="$rTitleOdd != ''"><xsl:text>
      \fancyhead[</xsl:text><xsl:value-of
        select="$rTitleOddPos"/><xsl:text>O]{</xsl:text><xsl:value-of select="$rTitleOddSize"
        /><xsl:value-of select="$rTitleOdd"/><xsl:text>} </xsl:text></xsl:if>
    <!-- Set accordingly  -->
    <xsl:choose>
      <xsl:when test="$lang1 = 'ancientGreek'">
        <xsl:text>
      \setmainlanguage[variant=ancient]{greek}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>
      \setmainlanguage{</xsl:text><xsl:value-of select="$lang1"
        /><xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$lang2 = 'ancientGreek'">
        <xsl:text>
      \setmainlanguage[variant=ancient]{greek}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>
      \setotherlanguage{</xsl:text><xsl:value-of select="$lang2"
        /><xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
    \usepackage[series={A,B},noend,noeledsec,noledgroup]{reledmac} 
    \Xarrangement[A]{paragraph}
    \Xarrangement[B]{paragraph}</xsl:text>
    <!-- set the space before each series of notes -->
    <xsl:text>
      % set the space before each series of notes </xsl:text>
    <xsl:text>
      \Xbeforenotes[A]{</xsl:text><xsl:value-of select="$spaceBeforeNotesA"/><xsl:text>pt}</xsl:text>
    <xsl:text>
      \Xbeforenotes[B]{</xsl:text><xsl:value-of select="$spaceBeforeNotesB"/><xsl:text>pt}</xsl:text>
    <!-- Prevents the lemma from having the same characteristics as in the text (bold, italics, etc.) -->
    <xsl:text>
      \Xlemmadisablefontselection[A] % Prevents the lemma from having the same characteristics as in the text (bold, italics, etc.)</xsl:text>
    <!-- To print the line number in bold in the apparatus... -->
    <xsl:text>
      \Xnotenumfont{\normalfont\bfseries} % To print the line number in bold in the apparatus...</xsl:text>
    <xsl:if test="$lemSep != ''">
      <xsl:text>
      \Xlemmaseparator[]{\,</xsl:text><xsl:value-of select="$lemSep"
      /><xsl:text>}</xsl:text>
    </xsl:if>
    <!-- to number the lines; options can be: page, pstart or section    -->
    <xsl:text>
        \lineation{</xsl:text><xsl:value-of select="$lineationStyle"/><xsl:text/>} <!-- setting lineation start, and step. -->
    <xsl:text>
      \setlength{\stanzaindentbase}{20pt}
      \setstanzaindents{1,1}
      \setcounter{stanzaindentsrepetition}{1}
    </xsl:text>
    <xsl:text>     
      \firstlinenum{</xsl:text><xsl:value-of select="$lineationStart"/><xsl:text>}</xsl:text>
    <xsl:text>
      \linenumincrement{</xsl:text><xsl:value-of select="$lineationStep"/><xsl:text>}</xsl:text>
    <!-- choose in which margin the line numbers will appear -->
    <xsl:text>
    \linenummargin{outer}
    \Xnumberonlyfirstinline[] 
    \Xnumberonlyfirstintwolines[]</xsl:text>
    <!-- separator between entries on the same line -->
    <xsl:text>
      \Xsymlinenum{</xsl:text><xsl:value-of select="$separatorAppEntries"/><xsl:text>}</xsl:text>
    <!-- order of the critical and familiar footnotes -->
    <xsl:text>
    \fnpos{critical-familiar}
    \begin{document} </xsl:text>
    <xsl:if test="$pageNumFirstPage = '0'">
      <xsl:text>
      \thispagestyle{empty}</xsl:text>
    </xsl:if>
    <xsl:text>
      \sidenotemargin{</xsl:text><xsl:value-of select="$sideNoteLocation"
      /><xsl:text>} 
        \pagenumbering{</xsl:text><xsl:value-of select="$pageNumberingStyle"/><xsl:text>} </xsl:text>
    <xsl:if test="$fromPage != '1'">
      <xsl:text>
        \setcounter{page}{</xsl:text><xsl:value-of select="$fromPage"
      /><xsl:text>} </xsl:text>
    </xsl:if>
    <!-- Printing (or not) the document title, and how -->
    <xsl:if test="$printTitle != '0'">
      <xsl:text>
        \begin{center}\begin{</xsl:text><xsl:value-of select="$printTitleSize"/><xsl:text>} </xsl:text>
      <xsl:choose>
        <xsl:when test="$printTitleStyle = 'smallcaps'"><xsl:text>\textsc{</xsl:text></xsl:when>
        <xsl:when test="$printTitleStyle = 'caps'"><xsl:text>\MakeUppercase{</xsl:text></xsl:when>
      </xsl:choose><xsl:apply-templates
        select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
      <xsl:choose>
        <xsl:when test="$printTitleStyle = 'smallcaps'"><xsl:text>}</xsl:text></xsl:when>
        <xsl:when test="$printTitleStyle = 'caps'"><xsl:text>}</xsl:text></xsl:when>
      </xsl:choose>
      <xsl:text>
        \end{</xsl:text><xsl:value-of select="$printTitleSize"
      /><xsl:text>}\end{center} \vspace{0.8cm} </xsl:text>
    </xsl:if>
    <xsl:if test="$printListWit != '0'">
      <xsl:if test="//tei:listWit">
        <xsl:apply-templates select="//tei:listWit"/>
      </xsl:if>
    </xsl:if>
    <xsl:text>
      \beginnumbering </xsl:text>
    <xsl:apply-templates select="/tei:TEI/tei:text/tei:body"/>
    <xsl:text>
      \endnumbering </xsl:text>
    <xsl:if test="$idxNom = '1'">
      <xsl:if test="$idxNomPrologue != ''"
          ><xsl:text>
        \indexprologue{\small </xsl:text><xsl:value-of
          select="$idxNomPrologue"/><xsl:text>} </xsl:text></xsl:if>
      <xsl:text>
            \printindex[nominum]</xsl:text>
    </xsl:if>
    <xsl:if test="$idxLoc = '1'">
      <xsl:if test="$idxLocPrologue != ''">
        <xsl:text>
        \indexprologue{\small </xsl:text><xsl:value-of select="$idxLocPrologue"
        /><xsl:text>} </xsl:text></xsl:if>
      <xsl:text>
        \printindex[locorum]</xsl:text>
    </xsl:if>
    <xsl:text>
       \end{document}</xsl:text>
  </xsl:template>

  <!-- Prints div heads as a Chapter -->
  <xsl:template match="tei:div">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- Prints div heads  -->
  <xsl:template match="tei:head[parent::tei:div or parent::tei:body]">
    <xsl:choose>
      <xsl:when test="not(ancestor::tei:rdg)">
        <!-- no paragraphs in the footnotes -->
        <xsl:text> \vspace{</xsl:text>
        <xsl:value-of select="$headStylevSpaceBefore"/>
        <xsl:text>cm}</xsl:text>
        <xsl:text>
      \pstart </xsl:text>
        <xsl:if test="$headSize != '0'">
          <xsl:text> \begin{</xsl:text>
          <xsl:value-of select="$headSize"/>
          <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:if test="$headAlign = 'center'">
          <xsl:text>\begin{center}</xsl:text>
        </xsl:if>
        <xsl:if test="$headStyleBold = '1'">
          <xsl:text>\textbf{</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- If this is the descendant of a tei:rdg, it will only appear in the critical footnotes, so paragraphs are not allowed here, and we don't want fancy markup either; just a space to separate paragraphs. -->
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <!-- several lemmata can end or begin at the same paragramh-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:variable name="depthOfLem" select="count(ancestor::tei:lem)"/>
    <xsl:call-template name="whileStartLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>


    <!-- several lemmata can end or begin at the same paragramh-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:call-template name="whileEndLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>


    <xsl:if test="not(ancestor::tei:rdg)">
      <!-- no paragraphs in the footnotes -->
      <xsl:if test="$headStyleBold = '1'">
        <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:if test="$headAlign = 'center'">
        <xsl:text>\end{center}</xsl:text>
      </xsl:if>
      <xsl:if test="$headSize != '0'">
        <xsl:text>\end{</xsl:text>
        <xsl:value-of select="$headSize"/>
        <xsl:text>}</xsl:text>
      </xsl:if>

      <xsl:text>
    \pend
    \vspace{</xsl:text>
      <xsl:value-of select="$headStylevSpaceAfter"/>
      <xsl:text>cm} </xsl:text>
    </xsl:if>
  </xsl:template>


  <!-- Prints out paragraphs -->
  <xsl:template match="tei:p|tei:ab">

    <xsl:choose>
      <xsl:when test="not(ancestor::tei:rdg)">
        <xsl:text>
      \pstart </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <!-- several lemmata can end or begin at the same paragramh-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:variable name="depthOfLem" select="count(ancestor::tei:lem)"/>
    <xsl:call-template name="whileStartLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>

    <!-- several lemmata can end or begin at the same paragramh-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:call-template name="whileEndLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:if test="not(ancestor::tei:rdg)">
      <xsl:text>
      \pend \vspace{</xsl:text>
      <xsl:value-of select="$parStylevSpace"/>
      <xsl:text>cm} </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="whileStartLem">
    <xsl:param name="depth"/>
    <xsl:if test="$depth > 0">
      <xsl:if
        test="ancestor::tei:lem[position() = $depth]/descendant::node()[name() = 'p' or name() = 'head' or name() = 'lg' or name() = 'list'][position() = 1] = self::node()">
        <xsl:text>\edlabel{lem_</xsl:text>
        <xsl:number select="ancestor::tei:lem[position() = $depth]" level="any"/>
        <xsl:text>_start}</xsl:text>
      </xsl:if>
      <xsl:call-template name="whileStartLem">
        <xsl:with-param name="depth" select="$depth - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="whileEndLem">
    <xsl:param name="depth"/>
    <xsl:if test="$depth > 0">
      <xsl:if
        test="ancestor::tei:lem[position() = $depth]/descendant::node()[name() = 'p' or name() = 'head' or name() = 'lg' or name() = 'list'][last()] = self::node()">
        <xsl:text>\edtext{</xsl:text>
        <xsl:text>\edlabel{lem_</xsl:text>
        <xsl:number select="ancestor::tei:lem[position() = $depth]" level="any"/>
        <xsl:text>_end}}</xsl:text>
        <xsl:text>{\xxref{lem_</xsl:text>
        <xsl:number select="ancestor::tei:lem[position() = $depth]" level="any"/>
        <xsl:text>_start}{lem_</xsl:text>
        <xsl:number select="ancestor::tei:lem[position() = $depth]" level="any"/>
        <xsl:text>_end}</xsl:text>
        <xsl:call-template name="noteForLemmaWithParagraphs">
          <xsl:with-param name="depth">
            <xsl:value-of select="$depth"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:call-template name="whileEndLem">
        <xsl:with-param name="depth" select="$depth - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <xsl:template name="noteForLemmaWithParagraphs">
    <xsl:param name="depth"/>

    <xsl:choose>
      <!-- default case -->
      <!-- It is common practice to write the apparatus text in lower case, so I use the \MakeLowercase{} command  -->
      <!-- Common case: there is a <lem> -->
      <xsl:when
        test="ancestor::tei:app[position() = number($depth)]/tei:lem/descendant-or-self::text() != ''">
        <xsl:choose>
          <!-- If there is a tei:note[@type='altLem'], then we use its contents for the lemma, without changing the case -->
          <xsl:when test="ancestor::tei:app[position() = number($depth)]/tei:note[@type='altLem']">
            <xsl:text>{\lemma{</xsl:text>
            <xsl:apply-templates
              select="ancestor::tei:app[position() = number($depth)]/tei:note[@type='altLem']"/>
            <xsl:text>} </xsl:text>
            <xsl:choose>
              <xsl:when test="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:for-each select="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                  <xsl:variable name="currentRdg">
                    <xsl:apply-templates select="."/>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="text() != ''">
                      <!-- doing this because of a bug in reledmac when a  footnote starts with plus or minus-->
                      <xsl:if
                        test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                        <xsl:text>\,</xsl:text>
                      </xsl:if>
                      <xsl:value-of select="lower-case($currentRdg)"/>
                     <xsl:choose> 
                       <xsl:when test="$italWit = '1'">
                        <xsl:text> \emph{</xsl:text>
                      </xsl:when>
                       <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                     </xsl:choose>
                      <xsl:value-of select="translate(@wit, '#', '')"/>
                      <xsl:if test="$italWit = '1'">
                        <xsl:text>}</xsl:text>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>\emph{ </xsl:text>
                      <xsl:value-of select="$varOm"/>
                      <xsl:text>} </xsl:text>
                      <xsl:choose> 
                        <xsl:when test="$italWit = '1'">
                          <xsl:text> \emph{</xsl:text>
                        </xsl:when>
                        <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="translate(@wit, '#', '')"/>
                      <xsl:if test="$italWit = '1'">
                        <xsl:text>}</xsl:text>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="following-sibling::node()/name() = 'rdg'">
                    <xsl:text>, </xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>}}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <!-- Eh??  -->
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- If there is not, we use the contents of the <lem> -->
          <xsl:otherwise>
            <xsl:text>{\lemma{</xsl:text>
            <xsl:variable name="currentLemmaNote"
              select="ancestor::tei:app[position() = number($depth)]/tei:lem/tokenize(normalize-space(string-join(descendant-or-self::text()[not(parent::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')"/>

            <xsl:choose>
              <xsl:when test="$shortenLem != '0' and count($currentLemmaNote) > $shortenLem">
                <xsl:value-of
                  select="translate(lower-case($currentLemmaNote[position() = 1]), ',.!?:;)', '')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="translate(lower-case($currentLemmaNote[position() = 2]), ',.!?:;)', '')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="translate(lower-case($currentLemmaNote[position() = 3]), ',.!?:;)', '')"/>
                <xsl:text> \dots </xsl:text>
                <xsl:value-of
                  select="translate(lower-case($currentLemmaNote[last() - 2]), ',.!?:;)', '')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="translate(lower-case($currentLemmaNote[last() - 1]), ',.!?:;)', '')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of
                  select="translate(lower-case($currentLemmaNote[last()]), ',.!?:;)', '')"/>
                <!--                <xsl:value-of select="translate(lower-case(./tei:lem/tokenize(normalize-space(string-join(descendant-or-self::text()[not(ancestor::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()]), ',.!?:;)', '')"/>   -->
              </xsl:when>
              <!-- we must not use $currentLemma here; it's for the edtext and has plenty of unnecessary tex markup (especially if the apps are nested)
              ==> write a clean version of the lemma, text only (could be optimised) -->
              <xsl:otherwise>
                <xsl:value-of
                  select="translate(lower-case(ancestor::tei:app[position() = number($depth)]/tei:lem/normalize-space(string-join(descendant-or-self::text()[not(parent::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],''))), ',.!?:;)', '')"
                />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>} </xsl:text>
            <xsl:choose>
              <xsl:when test="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:for-each select="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                  <xsl:variable name="currentRdg">
                    <xsl:apply-templates select="."/>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="descendant-or-self::text() != ''">
                      <xsl:if
                        test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                        <xsl:text>\,</xsl:text>
                      </xsl:if>
                      <xsl:value-of select="lower-case($currentRdg)"/>
                      <xsl:choose> 
                        <xsl:when test="$italWit = '1'">
                          <xsl:text> \emph{</xsl:text>
                        </xsl:when>
                        <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="translate(@wit, '#', '')"/>
                      <xsl:if test="$italWit = '1'">
                        <xsl:text>}</xsl:text>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- it is an omission by this witness -->
                      <xsl:text>\emph{ </xsl:text>
                      <xsl:value-of select="$varOm"/>
                      <xsl:text>} </xsl:text>
                      <xsl:choose> 
                        <xsl:when test="$italWit = '1'">
                          <xsl:text> \emph{</xsl:text>
                        </xsl:when>
                        <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                      </xsl:choose>
                      <xsl:value-of select="translate(@wit, '#', '')"/>
                      <xsl:if test="$italWit = '1'">
                        <xsl:text>}</xsl:text>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="following-sibling::node()/name() = 'rdg'">
                    <xsl:text>, </xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>}}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <!-- Eh??  -->
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- addition; the lemma is empty, so short of a better thing we need to put in the footnote's lemma the last word preceding this <app> -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="ancestor::tei:app[position() = number($depth)]/tei:note[@type='altLem']">
            <xsl:text>{\lemma{</xsl:text>
            <xsl:apply-templates
              select="ancestor::tei:app[position() = number($depth)]/tei:note[@type='altLem']"/>
            <xsl:text>} </xsl:text>
            <xsl:choose>
              <xsl:when test="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:for-each select="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                  <xsl:variable name="currentRdg">
                    <xsl:apply-templates select="."/>
                  </xsl:variable>
                  <xsl:if test="descendant-or-self::text() != ''">
                    <xsl:if
                      test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                      <xsl:text>\,</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="lower-case($currentRdg)"/>
                    <xsl:text>\emph{ </xsl:text>
                    <xsl:value-of select="$varAdd"/>
                    <xsl:text>} </xsl:text>
                    <xsl:choose> 
                      <xsl:when test="$italWit = '1'">
                        <xsl:text> \emph{</xsl:text>
                      </xsl:when>
                      <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="translate(@wit, '#', '')"/>
                    <xsl:if test="$italWit = '1'">
                      <xsl:text>}</xsl:text>
                    </xsl:if>
                    <xsl:if
                      test="following-sibling::node()/name() = 'rdg' and following-sibling::node()/text() != ''">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>}}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <!-- Eh??  -->
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>\edtext{}{\lemma{</xsl:text>
            <xsl:variable name="currenttPreviousWord">
              <xsl:value-of
                select="tokenize(normalize-space(string-join(ancestor::tei:app[position() = number($depth)]/preceding::text()[not(ancestor::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()]"
              />
            </xsl:variable>
            <!-- If the "word" immediately preceding the addition is a punctuation mark, then we're going to select the "word" before this one; 
            TODO: ideally, this should be recursive -->
            <xsl:choose>
              <xsl:when
                test="$currenttPreviousWord = '.' or $currenttPreviousWord = '!' or $currenttPreviousWord = '?' or $currenttPreviousWord = ';' or $currenttPreviousWord = ':' or $currenttPreviousWord = ','">
                <xsl:value-of
                  select="translate(lower-case(tokenize(normalize-space(string-join(preceding::text()[not(parent::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()-1]), ',.!?:;)', '')"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="translate(lower-case(tokenize(normalize-space(string-join(ancestor::tei:app[position() = number($depth)]/preceding::text()[not(parent::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()]), ',.!?:;)', '')"
                />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>} </xsl:text>
            <xsl:choose>
              <xsl:when test="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:for-each select="ancestor::tei:app[position() = number($depth)]/tei:rdg">
                  <xsl:variable name="currentRdg">
                    <xsl:apply-templates select="."/>
                  </xsl:variable>
                  <xsl:if test="descendant-or-self::text() != ''">
                    <xsl:if
                      test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                      <xsl:text>\,</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="lower-case($currentRdg)"/>
                    <xsl:text> \emph{</xsl:text>
                    <xsl:value-of select="$varAdd"/>
                    <xsl:text>} </xsl:text>
                    <xsl:if test="$italWit = '1'">
                      <xsl:text>\emph{</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="translate(@wit, '#', '')"/>
                    <xsl:if test="$italWit = '1'">
                      <xsl:text>}</xsl:text>
                    </xsl:if>
                    <xsl:if
                      test="following-sibling::node()/name() = 'rdg' and following-sibling::node()/descendant-or-self::text() != ''">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
                <xsl:text>}}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <!-- Eh??  -->
                <xsl:text>\Afootnote{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>



  </xsl:template>














  <!-- Add index entries for person names -->
  <xsl:template match="tei:persName">
    <xsl:choose>
      <xsl:when test="$idxNom = '1'">
        <xsl:choose>
          <xsl:when test="@key">
            <xsl:apply-templates/>
            <xsl:text>\index[nominum]{</xsl:text>
            <xsl:value-of select="@key"/>
            <xsl:text>} </xsl:text>
          </xsl:when>
          <xsl:when test="@ref">
            <xsl:variable name="nameRef">
              <xsl:value-of select="translate(@ref, '#', '')"/>
            </xsl:variable>
            <xsl:apply-templates/>
            <xsl:text>\index[nominum]{</xsl:text>
            <xsl:value-of select="//tei:person[@xml:id = $nameRef]/tei:persName"/>
            <xsl:text>} </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Add index entries for place names -->
  <xsl:template match="tei:placeName">
    <xsl:choose>
      <xsl:when test="$idxLoc = '1'">
        <xsl:choose>
          <xsl:when test="@key">
            <xsl:apply-templates/>\index[locorum]{<xsl:value-of select="@key"/>} </xsl:when>
          <xsl:when test="@ref">
            <xsl:variable name="nameRef"><xsl:value-of select="translate(@ref, '#', '')"
              /></xsl:variable>
            <xsl:apply-templates/>\index[locorum]{<xsl:value-of
              select="//tei:place[@xml:id = $nameRef]/tei:placeName"/>} </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>






  </xsl:template>

  <!--Adds linebreaks into document-->
  <xsl:template match="tei:lb"/>


  <!-- adds page breaks into document -->
  <xsl:template match="tei:pb">
    <xsl:if test="$folioNotes = '1'">
      <xsl:choose>
        <xsl:when test="$folioNotesAll = '1'">
          <!-- Printing all tei:pb -->
          <xsl:value-of select="$folioInTextMarker"/>\ledsidenote{<xsl:if test="$folioNotesMs = '1'"
              ><xsl:if test="@ed|@edRef">\emph{<xsl:choose>
                <xsl:when test="@ed and @edRef"><xsl:value-of select="translate(@edRef, '#', '')"
                  /></xsl:when>
                <xsl:when test="@ed and not(@edRef)"><xsl:value-of select="translate(@ed, '#', '')"
                  /></xsl:when>
                <xsl:when test="@edRef and not(@ed)"><xsl:value-of
                    select="translate(@edRef, '#', '')"/></xsl:when>
              </xsl:choose><xsl:text> </xsl:text>}</xsl:if></xsl:if><xsl:value-of select="@n"/>} </xsl:when>
        <xsl:when test="$folioNotesAll = '0'">
          <!-- Printing only one ms. -->
          <xsl:choose>
            <xsl:when test="$folioNoteAttribute = 'ed'">
              <xsl:if test="translate(@ed, '#', '') = $folioNoteAttributeValue">
                <xsl:value-of select="$folioInTextMarker"/>\ledsidenote{<xsl:if
                  test="$folioNotesMs = '1'"><xsl:if test="@ed|@edRef">\emph{<xsl:choose>
                      <xsl:when test="@ed and @edRef"><xsl:value-of
                          select="translate(@edRef, '#', '')"/></xsl:when>
                      <xsl:when test="@ed and not(@edRef)"><xsl:value-of
                          select="translate(@ed, '#', '')"/></xsl:when>
                      <xsl:when test="@edRef and not(@ed)"><xsl:value-of
                          select="translate(@edRef, '#', '')"/></xsl:when>
                    </xsl:choose><xsl:text> </xsl:text>}</xsl:if></xsl:if><xsl:value-of select="@n"
                />} </xsl:if>
            </xsl:when>
            <xsl:when test="$folioNoteAttribute = 'edRef'">
              <xsl:if test="translate(@edRef, '#', '') = $folioNoteAttributeValue">
                <xsl:value-of select="$folioInTextMarker"/>\ledsidenote{<xsl:if
                  test="$folioNotesMs = '1'"><xsl:if test="@ed|@edRef">\emph{<xsl:choose>
                      <xsl:when test="@ed and @edRef"><xsl:value-of
                          select="translate(@edRef, '#', '')"/></xsl:when>
                      <xsl:when test="@ed and not(@edRef)"><xsl:value-of
                          select="translate(@ed, '#', '')"/></xsl:when>
                      <xsl:when test="@edRef and not(@ed)"><xsl:value-of
                          select="translate(@edRef, '#', '')"/></xsl:when>
                    </xsl:choose><xsl:text> </xsl:text>}</xsl:if></xsl:if><xsl:value-of select="@n"
                />} </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <!-- inserts linegroup into document-->
  <xsl:template match="tei:lg">

    <!-- lg is a pain because it can occur in p (or not), but in tex it generates a stanza structure which must never be inside a paragraph
    I've tried closing the parent paragraph and re-opening one, but it's not enough. 
    If the lg are inside a quotation, for instance, we need to have some more complicated handling.
    -->

    <xsl:choose>
      <xsl:when test="not(ancestor::tei:rdg)">
        <xsl:if test="ancestor::tei:p and not(preceding-sibling::tei:lg)">
          <!-- In TEI an lg can occur within a p, while in LaTeX a stanza cannot occur within a pstart. The only solution I came up with was to close then re-open the current paragraph. 
        Warning: this can create a problem in the .tex file when the lg occurs at the very beginning or end of the paragraph. -->
          <xsl:text>
                \pend </xsl:text>
        </xsl:if>
        <xsl:text>                     
        \stanza[ ] </xsl:text>

        <!-- this is not good; TODO: do better. -->
        <xsl:if test="ancestor::tei:cit">
          <xsl:if
            test="ancestor::tei:quote[position() = 1]/descendant::node()[name() = 'lg'][position() = 1] = self::node()">
            <xsl:text>\edlabel{cit_</xsl:text>
            <xsl:number select="ancestor::tei:quote[position() = 1]" level="any"/>
            <xsl:text>_start}</xsl:text>
          </xsl:if>
        </xsl:if>

      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <!-- several lemmata can end or begin at the same paragraph-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:variable name="depthOfLem" select="count(ancestor::tei:lem)"/>
    <xsl:call-template name="whileStartLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>

    <!-- several lemmata can end or begin at the same paragraph-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:call-template name="whileEndLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="not(ancestor::tei:rdg)">

        <!-- this is not good; TODO: do better. -->
        <xsl:if test="ancestor::tei:cit">
          <xsl:if
            test="ancestor::tei:quote[position() = 1]/descendant::node()[name() = 'lg'][position() = last()] = self::node()">
            <xsl:text>\edtext{</xsl:text>
            <xsl:text>\edlabel{cit_</xsl:text>
            <xsl:number select="ancestor::tei:quote[position() = 1]" level="any"/>
            <xsl:text>_end}}{\xxref{cit_</xsl:text>
            <xsl:number select="ancestor::tei:quote[position() = 1]" level="any"/>
            <xsl:text>_start}{cit_</xsl:text>
            <xsl:number select="ancestor::tei:quote[position() = 1]" level="any"/>
            <xsl:text>_end}\lemma{}{\Bfootnote[nosep]{</xsl:text>
            <xsl:apply-templates select="ancestor::tei:cit[position() = 1]/tei:bibl" mode="src"/>
            <xsl:text>}}}</xsl:text>
          </xsl:if>
        </xsl:if>

        <xsl:choose>
          <xsl:when test="not(following-sibling::tei:lg)">
            <xsl:text> \&amp;[ ]</xsl:text>
            <xsl:if test="ancestor::tei:p">
              <!-- In TEI an lg can occur within a p, while in LaTeX a stanza cannot occur within a pstart. The only solution I came up with was to close then re-open the current paragraph. 
        TODO: this can create a problem in the .tex file when the lg occurs at the very beginning or end of the paragraph; fix it. -->
              <xsl:text>
                \pstart </xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> \&amp; </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>





  </xsl:template>

  <!-- inserts a line within the linegroup into document -->
  <xsl:template match="tei:l">
    <xsl:choose>
      <xsl:when test="parent::tei:lg">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::tei:l">
          <xsl:text> &amp;</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="not(ancestor::tei:rdg)">            
            <!-- The previous code was creating a stanza for isolated tei:l; it's a pain, so to Hell with it, we're going to treat those tei:l appearing outside of tei:lg as simple indented new lines-->
            <!-- Nota: here we use \textit and not \emph, bacause this tei:l could be within a tei:quote, which can already be displayed with \emph. This would have the consequence of NOT displaying in italics a tei:lg occurring within a tei:quote -->
            <xsl:text> \\ \indent \textit{</xsl:text>
          </xsl:when>
          <!-- we're in a critical footnote -->
          <xsl:otherwise>
            <xsl:text> \emph{</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
        <xsl:choose>
          <xsl:when test="following-sibling::tei:l">
            <xsl:choose>
              <xsl:when test="parent::tei:lg">
                <xsl:text> \&amp;</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>} </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="parent::tei:lg">
                 <xsl:text> \&amp;[ ]
           \pstart </xsl:text>                              
              </xsl:when>
              <xsl:otherwise>
                <!-- The previous code was creating a stanza for isolated tei:l; it's a pain, so to Hell with it, we're going to treat those tei:l appearing outside of tei:lg as simple indented new lines-->
                <xsl:choose>
                  <xsl:when test="not(following-sibling::tei:l) and not(parent::tei:lem)">
                  <xsl:text>}
                \\ </xsl:text>
                </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>} </xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- textual apparatus -->
  <xsl:template match="tei:app">
    <xsl:variable name="currentLemma">
      <xsl:apply-templates select="./tei:lem"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when
        test="not(descendant::tei:p) and not(descendant::tei:head) and not(descendant::tei:lg) and not(descendant::tei:list)">
        <xsl:choose>
          <!-- default case -->
          <!-- It is common practice to write the apparatus text in lower case, so I use the \MakeLowercase{} command  -->
          <!-- Common case: there is a <lem> -->
          <xsl:when test="./tei:lem/descendant-or-self::text() != ''">
            <xsl:choose>
              <!-- If there is a tei:note[@type='altLem'], then we use its contents for the lemma, without changing the case -->
              <xsl:when test="./tei:note[@type='altLem']">
                <xsl:text>\edtext{</xsl:text>
                <xsl:value-of select="$currentLemma"/>
                <xsl:text>}{\lemma{</xsl:text>
                <xsl:apply-templates select="./tei:note[@type='altLem']"/>
                <xsl:text>} </xsl:text>
                <xsl:choose>
                  <xsl:when test="./tei:rdg">
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:for-each select="./tei:rdg">
                      <xsl:variable name="currentRdg">
                        <xsl:apply-templates select="."/>
                      </xsl:variable>
                      <xsl:choose>
                        <xsl:when test="descendant-or-self::text() != ''">
                          <!-- doing this because of a bug in reledmac when a  footnote starts with plus or minus-->
                          <xsl:if
                            test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                            <xsl:text>\,</xsl:text>
                          </xsl:if>
                          <xsl:value-of select="lower-case($currentRdg)"/>
                          <xsl:choose>
                            <xsl:when test="$italWit = '1'">
                              <xsl:text> \emph{</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text> </xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:value-of select="translate(@wit, '#', '')"/>
                          <xsl:if test="$italWit = '1'"><xsl:text>}</xsl:text></xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>\emph{ </xsl:text>
                          <xsl:value-of select="$varOm"/>
                          <xsl:text>} </xsl:text>
                          <xsl:if test="$italWit = '1'"><xsl:text>\emph{</xsl:text></xsl:if>
                          <xsl:value-of select="translate(@wit, '#', '')"/>
                          <xsl:if test="$italWit = '1'"><xsl:text>}</xsl:text></xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="following-sibling::node()/name() = 'rdg'">
                        <xsl:text>, </xsl:text>
                      </xsl:if>                               
                    </xsl:for-each>
                    <xsl:text>}}</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Eh??  -->
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}}</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <!-- If there is not, we use the contents of the <lem> -->
              <xsl:otherwise>
                <xsl:text>\edtext{</xsl:text>
                <xsl:value-of select="$currentLemma"/>
                <xsl:text>}{\lemma{</xsl:text>
                <xsl:variable name="currentLemmaNote"
                  select="./tei:lem/tokenize(normalize-space(string-join(descendant-or-self::text()[not(parent::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')"/>

                <xsl:choose>
                  <xsl:when test="$shortenLem != '0' and count($currentLemmaNote) > $shortenLem">
                    <xsl:value-of
                      select="translate(lower-case($currentLemmaNote[position() = 1]), ',.!?:;)', '')"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                      select="translate(lower-case($currentLemmaNote[position() = 2]), ',.!?:;)', '')"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                      select="translate(lower-case($currentLemmaNote[position() = 3]), ',.!?:;)', '')"/>
                    <xsl:text> \dots </xsl:text>
                    <xsl:value-of
                      select="translate(lower-case($currentLemmaNote[last() - 2]), ',.!?:;)', '')"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                      select="translate(lower-case($currentLemmaNote[last() - 1]), ',.!?:;)', '')"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                      select="translate(lower-case($currentLemmaNote[last()]), ',.!?:;)', '')"/>
                    <!--                <xsl:value-of select="translate(lower-case(./tei:lem/tokenize(normalize-space(string-join(descendant-or-self::text()[not(ancestor::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()]), ',.!?:;)', '')"/>   -->
                  </xsl:when>
                  <!-- we must not use $currentLemma here; it's for the edtext and has plenty of unnecessary tex markup (especially if the apps are nested)
              ==> write a clean version of the lemma, text only (could be optimised) -->
                  <xsl:otherwise>
                    <xsl:value-of
                      select="translate(lower-case(./tei:lem/normalize-space(string-join(descendant-or-self::text()[not(parent::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],''))), ',.!?:;)', '')"
                    />
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text>} </xsl:text>
                <xsl:choose>
                  <xsl:when test="./tei:rdg">
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:for-each select="./tei:rdg">
                      <xsl:variable name="currentRdg">
                        <xsl:apply-templates select="."/>
                      </xsl:variable>
                      <xsl:choose>
                        <xsl:when test="descendant-or-self::text() != ''">
                          <xsl:if
                            test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                            <xsl:text>\,</xsl:text>
                          </xsl:if>
                          <xsl:value-of select="lower-case($currentRdg)"/>
                          <xsl:choose>
                            <xsl:when test="$italWit = '1'"><xsl:text> \emph{</xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                          </xsl:choose>                          
                          <xsl:value-of select="translate(@wit, '#', '')"/>
                          <xsl:if test="$italWit = '1'"><xsl:text>}</xsl:text></xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- it is an omission by this witness -->
                          <xsl:text>\emph{ </xsl:text>
                          <xsl:value-of select="$varOm"/>
                          <xsl:text>} </xsl:text>
                          <xsl:if test="$italWit = '1'"><xsl:text>\emph{</xsl:text></xsl:if>
                          <xsl:value-of select="translate(@wit, '#', '')"/>
                          <xsl:if test="$italWit = '1'"><xsl:text>}</xsl:text></xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="following-sibling::node()/name() = 'rdg'">
                        <xsl:text>, </xsl:text>
                      </xsl:if>                      
                      <!-- Lame attenpt at correctly displaying the notes. TODO: do betetr -->
                      <!--
                      <xsl:apply-templates select="following-sibling::tei:note"/>                      
                      -->
                    </xsl:for-each>
                    <xsl:text>}}</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Eh??  -->
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}}</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <!-- addition; the lemma is empty, so short of a better thing we need to put in the footnote's lemma the last word preceding this <app> -->
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="./tei:note[@type='altLem']">
                <xsl:text>\edtext{</xsl:text>
                <xsl:value-of select="$currentLemma"/>
                <xsl:text>}{\lemma{</xsl:text>
                <xsl:apply-templates select="./tei:note[@type='altLem']"/>
                <xsl:text>} </xsl:text>
                <xsl:choose>
                  <xsl:when test="./tei:rdg">
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:for-each select="./tei:rdg">
                      <xsl:variable name="currentRdg">
                        <xsl:apply-templates select="."/>
                      </xsl:variable>
                      <xsl:if test="descendant-or-self::text() != ''">
                        <xsl:if
                          test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                          <xsl:text>\,</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="lower-case($currentRdg)"/>
                        <xsl:text> \emph{</xsl:text>
                        <xsl:value-of select="$varAdd"/>
                        <xsl:text>} </xsl:text>
                        <xsl:if test="$italWit = '1'"><xsl:text>\emph{</xsl:text></xsl:if>
                        <xsl:value-of select="translate(@wit, '#', '')"/>
                        <xsl:if test="$italWit = '1'"><xsl:text>}</xsl:text></xsl:if>
                        <xsl:if
                          test="following-sibling::node()/name() = 'rdg' and following-sibling::node()/descendant-or-self::text() != ''">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:text>}}</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Eh??  -->
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}}</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>\edtext{}{\lemma{</xsl:text>
                <xsl:variable name="currenttPreviousWord">
                  <xsl:value-of
                    select="tokenize(normalize-space(string-join(preceding::text()[not(ancestor::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()]"
                  />
                </xsl:variable>
                <!-- If the "word" immediately preceding the addition is a punctuation mark, then we're going to select the "word" before this one; 
            TODO: ideally, this should be recursive -->
                <xsl:choose>
                  <xsl:when
                    test="$currenttPreviousWord = '.' or $currenttPreviousWord = '!' or $currenttPreviousWord = '?' or $currenttPreviousWord = ';' or $currenttPreviousWord = ':' or $currenttPreviousWord = ','">
                    <xsl:value-of
                      select="translate(lower-case(tokenize(normalize-space(string-join(preceding::text()[not(ancestor::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()-1]), ',.!?:;)', '')"
                    />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="translate(lower-case(tokenize(normalize-space(string-join(preceding::text()[not(ancestor::tei:rdg)][not(ancestor::tei:note)][not(ancestor::tei:bibl)],'')),' ')[last()]), ',.!?:;)', '')"
                    />
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text>} </xsl:text>
                <xsl:choose>
                  <xsl:when test="./tei:rdg">
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:for-each select="./tei:rdg">
                      <xsl:variable name="currentRdg">
                        <xsl:apply-templates select="."/>
                      </xsl:variable>
                      <xsl:if test="descendant-or-self::text() != ''">
                        <xsl:if
                          test="starts-with($currentRdg, 'plus') or starts-with($currentRdg, 'minus')">
                          <xsl:text>\,</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="lower-case($currentRdg)"/>
                        <xsl:text> \emph{</xsl:text>
                        <xsl:value-of select="$varAdd"/>
                        <xsl:text>} </xsl:text>
                        <xsl:if test="$italWit = '1'"><xsl:text>\emph{</xsl:text></xsl:if>
                        <xsl:value-of select="translate(@wit, '#', '')"/>
                        <xsl:if test="$italWit = '1'"><xsl:text>}</xsl:text></xsl:if>
                        <xsl:if
                          test="following-sibling::node()/name() = 'rdg' and following-sibling::node()/descendant-or-self::text() != ''">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:text>}}</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Eh??  -->
                    <xsl:text>\Afootnote{</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>}}</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="tei:lem"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <!-- Prints all tei:note as footnotes -->
  <xsl:template match="tei:note[not(ancestor::tei:app)]">
    <xsl:text>\footnoteA{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>


  <xsl:template match="tei:note[ancestor::tei:app][@type != 'altLem']">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>} </xsl:text>
  </xsl:template>

  <!-- we use the @next and @prev to join split citations -->

  <xsl:template match="tei:cit">
    <xsl:choose>
      <xsl:when test="./tei:quote//tei:lg">
        <!-- the complicated case of lg...Not very good! TODO: do better -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@next">
            <xsl:choose>
              <xsl:when test="@type='bible'">
                <xsl:text>\emph{</xsl:text>
                <xsl:apply-templates select="tei:quote"/>
                <xsl:text>}</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>\edlabel{</xsl:text>
                <xsl:value-of select="translate(@xml:id, '#', '')"/>
                <xsl:text>}</xsl:text>
                <xsl:apply-templates select="tei:quote"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="@prev">
            <xsl:choose>
              <xsl:when test="@type='bible'">
                <xsl:text>\emph{</xsl:text>
                <xsl:apply-templates select="tei:quote"/>
                <xsl:text>}</xsl:text>
                <xsl:apply-templates select="tei:bibl" mode="bibl"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="tei:quote"/>
                <xsl:text>\edlabel{</xsl:text>
                <xsl:value-of select="translate(@xml:id, '#', '')"/>
                <xsl:text>}}{\xxref{</xsl:text>
                <xsl:value-of select="translate(@prev, '#', '')"/>
                <xsl:text>}{</xsl:text>
                <xsl:value-of select="translate(@xml:id, '#', '')"/>
                <xsl:text>}\lemma{}{\Bfootnote[nosep]{</xsl:text>
                <xsl:apply-templates select="tei:bibl" mode="src"/>
                <xsl:text>}}}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="@type='bible'">
                <xsl:text>\emph{</xsl:text>
                <xsl:apply-templates select="tei:quote"/>
                <xsl:text>}</xsl:text>
                <xsl:apply-templates select="tei:bibl" mode="bibl"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="tei:quote"/>
                <xsl:text>}{\lemma{}{\Bfootnote[nosep]{</xsl:text>
                <xsl:apply-templates select="tei:bibl" mode="src"/>
                <xsl:text>}}}</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>



  <xsl:template match="tei:quote">
    <xsl:if test="$italQuote = '1'">
      <xsl:text>
      \emph{</xsl:text>
    </xsl:if>
    <xsl:if test="$qmQuote = '1'">
      <xsl:value-of select="substring-before($qmQuoteStyle, '|')"/>
      <xsl:if test="$qmQuoteNoBr = '1'">
        <xsl:text>\,</xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="$qmQuote = '1'">
      <xsl:if test="$qmQuoteNoBr = '1'">
        <xsl:text>\,</xsl:text>
      </xsl:if>
      <xsl:value-of select="substring-after($qmQuoteStyle, '|')"/>
    </xsl:if>
    <xsl:if test="$italQuote = '1'">
      <xsl:text>
      }</xsl:text>
    </xsl:if>
  </xsl:template>




  <xsl:template match="tei:bibl" mode="bibl">
    <xsl:text> \nobreak&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\nobreak&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="tei:bibl" mode="src">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:bibl"/>

  <xsl:template match="tei:title">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>


  <!--Prints lists with bullets -->
  <xsl:template match="tei:list">
    <xsl:choose>
      <xsl:when test="not(ancestor::tei:rdg)">
        <xsl:choose>
          <!-- In TEI a list can occur within a p. The only solution I came up with was to close then re-open the current paragraph. 
        Warning: this can create a problem in the .tex file when the lg occurs at the very beginning or end of the paragraph. -->
          <xsl:when test="ancestor::tei:p">
            <xsl:if
              test="preceding::text()/ancestor::tei:p[position() = 1] = ancestor::tei:p[position() = 1]">
              <!-- add a new line only if there is text before the list in this paragraph -->
              <xsl:text>
                \\ \indent </xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>
              \pstart </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <!-- several lemmata can end or begin at the same paragramh-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:variable name="depthOfLem" select="count(ancestor::tei:lem)"/>
    <xsl:call-template name="whileStartLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>


    <xsl:apply-templates/>

    <!-- several lemmata can end or begin at the same paragramh-like element; we're going to count the number of tei:lem ancestors, and check for all of them is the current element is a first or last descendant -->
    <xsl:call-template name="whileEndLem">
      <xsl:with-param name="depth">
        <xsl:value-of select="$depthOfLem"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:choose>
      <xsl:when test="not(ancestor::tei:rdg)">
        <xsl:choose>
          <!-- In TEI a list can occur within a p. The only solution I came up with was to close then re-open the current paragraph. 
        Warning: this can create a problem in the .tex file when the lg occurs at the very beginning or end of the paragraph. -->
          <xsl:when test="ancestor::tei:p"/>
          <xsl:otherwise>
            <xsl:text>
              \pend \vspace{</xsl:text>
            <xsl:value-of select="$parStylevSpace"/>
            <xsl:text>cm} </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="tei:item">
    <xsl:apply-templates/>
    <xsl:if test="not(ancestor::tei:rdg)">
      <xsl:if test="following-sibling::tei:item">
        <xsl:text>
     \\ \indent </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:emph">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="tei:hi">
    <xsl:choose>
      <xsl:when test="@rend = 'italic' or @rend='italics'">
        <xsl:text> \emph{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>} </xsl:text>
      </xsl:when>
      <xsl:when test="@rend = 'bold'">
        <xsl:text> \textbf{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>} </xsl:text>
      </xsl:when>
      <xsl:when test="@rend = 'sup'">
        <xsl:text> \textsuperscript{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>} </xsl:text>
      </xsl:when>      
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:ref"> \textsuperscript{ <xsl:apply-templates/>} </xsl:template>

  <xsl:template match="tei:table"> \begin{tabular}{c|c|c|c} <xsl:apply-templates/> \end{tabular} </xsl:template>

  <xsl:template match="tei:row">
    <xsl:apply-templates/> \\ </xsl:template>

  <xsl:template match="tei:cell">
    <xsl:apply-templates/>
    <!--<xsl:value-of select='normalize-space()'/>--> &amp; </xsl:template>
  <xsl:template match="tei:listWit">
    <xsl:apply-templates/>
    <xsl:text>
      \vspace{0.8cm}</xsl:text>
  </xsl:template>
  <xsl:template match="tei:witness">
    <xsl:text>
      \par \textbf{</xsl:text>
    <xsl:value-of select="@xml:id"/>
    <xsl:text>} - </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <tex:replace-map>
    <entry key="&gt;">$\rangle$</entry>
    <entry key="&lt;">$\langle$</entry>
    <entry key="&amp;">\&amp;</entry>
    <entry key="_">\_</entry>
    <entry key="%">\%</entry>
    <entry key="#">\#</entry>
    <entry key="$">\$</entry>
    <entry key="\">\textbackslash{}</entry>
    <entry key="^">\^{}</entry>
    <entry key="{">\{</entry>
    <entry key="}">\}</entry>
    <entry key="~">\~{}</entry>
  </tex:replace-map>


  <xsl:template match="text()">
    <xsl:variable name="toreturn">
      <xsl:call-template name="StringReplace">
        <xsl:with-param name="text" select="."/>
        <xsl:with-param name="chars" select="'&lt; &amp; % # $ \ * ^ { ~ } _ &gt; '"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="ancestor::*[@xml:space][1]/@xml:space='preserve'">
        <xsl:value-of select="$toreturn"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Retain one leading space if node isn't first, has
	     non-space content, and has leading space.-->
        <xsl:if test="position()!=1 and matches($toreturn,'^\s') and normalize-space()!=''">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:value-of select="normalize-space($toreturn)"/>
        <xsl:choose>
          <!-- node is an only child, and has content but it's all space -->
          <xsl:when test="last()=1 and string-length()!=0 and normalize-space()=''">
            <xsl:text> </xsl:text>
          </xsl:when>
          <!-- node isn't last, isn't first, and has trailing space -->
          <xsl:when test="position()!=1 and position()!=last() and matches($toreturn,'\s$')">
            <xsl:text> </xsl:text>
          </xsl:when>
          <!-- node isn't last, is first, has trailing space, and has non-space content   -->
          <xsl:when test="position()=1 and matches($toreturn,'\s$') and normalize-space()!=''">
            <xsl:text> </xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- <xsl:template match = "text()" >
    <xsl:variable name="toreturn">
      <xsl:call-template name="StringReplace">
        <xsl:with-param name="text" select="." />
        <xsl:with-param name="chars" select="'&lt; &amp; % # $ \ * ^ { ~ } _ &gt; '" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::tei:p"><xsl:value-of select="$toreturn" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="normalize-space($toreturn)" /></xsl:otherwise>
    </xsl:choose>
</xsl:template>
-->

  <xsl:template name="StringReplace">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>

    <xsl:choose>
      <!-- when $chars still has spaces, we're not done replacing stuff -->
      <xsl:when test="contains($chars, ' ')">
        <!-- compute the current char to work on, it's the first one in $chars
           * chars is delimited by spaces -->
        <xsl:variable name="char" select="substring-before($chars,' ')"/>

        <xsl:choose>
          <xsl:when test="contains($text, $char)">
            <!-- the text contains the character to replace
                  * first compute the next string to call on 
                  * this is all the text after the first intance of the char to replace 
                  **** 
                  * recursively call this template on that text, will do replacement
                  * as we come back up from recursion-->
            <xsl:variable name="rightString">
              <xsl:call-template name="StringReplace">
                <xsl:with-param name="text" select="substring-after($text, $char)"/>
                <xsl:with-param name="chars" select="$chars"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="leftString">
              <xsl:call-template name="StringReplace">
                <xsl:with-param name="text" select="substring-before($text, $char)"/>
                <xsl:with-param name="chars" select="$chars"/>
              </xsl:call-template>
            </xsl:variable>

            <!--  $rejoined contains the text to the left, the replacement char, and the reply from recursion -->
            <xsl:variable name="rejoined">
              <xsl:value-of
                select="concat($leftString, document('')/*/tex:replace-map/entry[@key=$char], $rightString)"
              />
            </xsl:variable>

            <!-- no more instances of the char to be replaced in $text, return the text to start
                   coming back from recursion -->
            <xsl:value-of select="$rejoined"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- done with the current $char, shorten $chars and run again-->
            <xsl:call-template name="StringReplace">
              <xsl:with-param name="text" select="$text"/>
              <xsl:with-param name="chars" select="substring-after($chars,' ')"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <!-- $chars is completely empty, we are done -->
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
