#import "colors.typ" as colors: *
#import "todo.typ": todo, list-todos, hide-todos
#import "elements.typ": *
#import "@preview/hydra:0.6.1": hydra

#let project(
    title: [#todo[Title]],
    subtitle: none,
    thesis-type: none,

    academic-degree: "ACADEMIC DEGREE",
    academic-subject: "ACADEMIC SUBJECT",

    university: "UNIVERSITY",
    faculty: "FACULTY",
    institute: "INSTITUTE",
    seminar: "SEMINAR",
    docent: "DOCENT",

    author: "AUTHOR",
    student-number: none,
    email: none,
    birthdate: none,
    birthplace: none,

    date: datetime.today(),
    date-format: (date) => if type(date) == type(datetime.today()) { date.display("[day].[month].[year]") } else { date },
    city: "CITY",

    to-reach-academic-degree: "To obtain the academic degree of",
    in-the-subject-of: "In the subject of",
    submit-to: "Submitted to",
    submit-by: "Submitted by",
    born-on: "born",
    born-in: "in",

    title-page-show-logo: true,
    title-page-logo-file:"static/Bildmarke_blue_23cm.png",
    title-page-part: none,
    tite-page-show-academic-degree: true,
    title-page-part-academic-degree: none,
    tite-page-show-submit-date: true,
    title-page-part-submit-date: none,
    tite-page-show-submit-to: true,
    title-page-part-submit-to: none,
    tite-page-show-submit-by: true,
    title-page-part-submit-by: none,

    sentence-supplement: "Example",

    header: none,
    header-right: none,
    header-middle: none,
    header-left: none,
    show-header-line: true,

    footer: none,
    footer-right: none,
    footer-middle: none,
    footer-left: none,
    show-footer-line: true,

    page-margins: none,

    text-font: ("Noto Serif", "Roboto Serif", "Libertinus Serif"),
    title-font: ("Noto Sans"),
    math-font: ("STIX Two Math", "New Computer Modern Math"),
    code-font: ("Noto Sans Mono", "FiraCode Nerd Font"),

    accent-color: blue,

    fontsize: 11pt,

    body
) = {
    // format settings

    let ifnn-line(e) = if e != none [#e \ ]

    set text(font: text-font, size: fontsize)
    show math.equation: set text(size: 13pt,font: math-font)
    show raw: set text(size: 11.5pt,font:code-font)
    show figure: set figure(gap: 1.5em)

    set enum(indent: 1em)
    set list(indent: 1em)

    show link: emph

    show heading: it => format-heading-numbering(it, accent-color: accent-color)
    show heading: set text(weight: "bold", fill:accent-color)
    show: format-quotes


    // title page
    [
        #set align(center)
        #set text(font: title-font)
        #set text(size: 1.25em, hyphenate: false)
        #set par(justify: false)

        #v(3fr)
        #if(title-page-show-logo){image(title-page-logo-file, width: 75%)}
        #v(2fr)
        #text(size: 2.5em, fill: accent-color, strong(title)) \
        #if subtitle != none {
            v(0em)
            text(size: 1.5em, fill: accent-color.lighten(25%), subtitle)
        }

        #if thesis-type != none {
            v(0em)
            text(size: 1.5em, fill: accent-color.lighten(25%), thesis-type)
        }

        
        #if title-page-part == none [

            #if (title-page-part-academic-degree == none) and tite-page-show-academic-degree{
                ifnn-line(text(size: 0.6em, upper(strong(to-reach-academic-degree))))
                ifnn-line(academic-degree)
                ifnn-line(text(size: 0.6em, upper(strong(in-the-subject-of))))
                ifnn-line(academic-subject)
            } else {
                title-page-part-submit-to
            }
            
            #v(3fr)
            #if (title-page-part-submit-to == none) and tite-page-show-submit-to{
                ifnn-line(text(size: 0.6em, upper(strong(submit-to))))
                ifnn-line(university)
                ifnn-line(faculty)
                ifnn-line(institute)
                ifnn-line(seminar)
                ifnn-line(docent)
            } else {
                title-page-part-submit-to
            }

            #if (title-page-part-submit-by == none) and tite-page-show-submit-by {
                ifnn-line(text(size: 0.6em, upper(strong(submit-by))))
                ifnn-line(author + if student-number != none [ (#student-number)])
                ifnn-line(email)
                if(birthdate != none) {
                    if(birthplace != none){ifnn-line([#born-on #birthdate, #born-in #birthplace])
                    } else {
                        ifnn-line([#born-on #birthdate])
                    }
                }
                
            } else {
                title-page-part-submit-by
            }

            #v(3fr)
            #if (title-page-part-submit-date == none) and tite-page-show-submit-date{
                [#city, #date-format(date)]
            } else {
                title-page-part-submit-date
            }

         ] else {
            title-page-part
        }

        #v(5fr)
    ]

    // page setup
    let ufi = ()
    if university != none { ufi.push(university) }
    if faculty != none { ufi.push(faculty) }
    if institute != none { ufi.push(institute) }

    set page(
        margin: if page-margins != none {page-margins} else {
            (top: 3cm, bottom: 3cm, right: 2cm, left: 4cm)
        },

        header: if header != none {header} else [
            #set text(font: title-font, size: 0.75em)

            #table(columns: (1fr, auto, 1fr),
                align: bottom,
                stroke: none,
                inset: 0pt,

                if header-left != none {header-left} else [
                    #context(hydra(1))
                ], 

                align(center, if header-middle != none {header-middle} else []),
                
                if header-right != none {header-right} else [
                    #show: align.with(top + right)
                    #context(counter(page).display())
                ]
            )
        ] + if show-header-line { v(-0.5em) + line(length: 100%, stroke: accent-color) },
    )

    state("grape-suite-element-sentence-supplement").update(sentence-supplement)
    show: sentence-logic


    // main body setup
    set page(

        background: context state("grape-suite-seminar-paper-sidenotes", ())
            .final()
            .map(e => context {
                if here().page() == e.loc.at(0) {
                    set par(justify: false, leading: 0.65em)
                    place(top + right, align(left, text(fill: accent-color, size: 0.75em, hyphenate: false, pad(x: 0.5cm, block(width: 3cm, strong(e.body))))), dy: e.loc.at(1).y)
                } else {
                }
            }).join[],

        footer: if footer != none {footer} else {
            set text(font: title-font, size: 0.75em)

            if show-footer-line {
                line(length: 100%, stroke: accent-color)
                v(-0.5em)
            }

            table(columns: (1fr, auto, auto),
                align: top,
                stroke: none,
                inset: 0pt,

                if footer-left != none {footer-left} else [
                    #align(left, context {title})
                ],

                align(center, if header-middle != none {header-middle} else []),

                if footer-right != none {footer-right} else [
                    #align(right, context {author})
                ],
            )
        }
    )

    set heading(numbering: "1.")

    show heading: set par(leading: 0.65em, justify: false)
    set par(justify: true, leading: 1em, spacing: 1em, first-line-indent: 1.5em)
    show bibliography: set bibliography(style: "static/ieee-superscript.csl")

    body
}

#let sidenote(body) = context {
    let pos = here()

    state("grape-suite-seminar-paper-sidenotes", ()).update(k => {
        k.push((loc: (pos.page(), pos.position()), body: body))
        return k
    })
}

#let show-declaration-of-independent-work(accent-color: blue) = {
    pagebreak(weak: true)
    set page(header: {v(-0.5em) + line(length: 100%, stroke: accent-color) })
    
    //LTeX: language=de-DE

    heading(outlined: false, numbering: none, [Eigenständigkeitserklärung])
    set block(spacing: 2em)

    [
        #set par(leading: 0.8em)
        #set text(size: 10pt)
        + Hiermit versichere ich, dass ich die vorliegende Arbeit - bei einer Gruppenarbeit die von mir zu verantwortenden und entsprechend gekennzeichneten Teile - selbstständig verfasst und keine anderen als die angegebenen Quellen und Hilfsmittel benutzt habe. Ich trage die Verantwortung für die Qualität des Textes sowie die Auswahl aller Inhalte und habe sichergestellt, dass Informationen und Argumente mit geeigneten wissenschaftlichen Quellen belegt bzw. gestützt werden. Die aus fremden oder auch eigenen, älteren Quellen wörtlich oder sinngemäß übernommenen Textstellen, Gedankengänge, Konzepte, Grafiken etc. in meinen Ausführungen habe ich als solche eindeutig gekennzeichnet und mit vollständigen Verweisen auf die jeweilige Quelle versehen. Alle weiteren Inhalte dieser Arbeit ohne entsprechende Verweise stammen im urheberrechtlichen Sinn von mir.
        + Ich weiß, dass meine Eigenständigkeitserklärung sich auch auf nicht zitierfähige, generierende KI-Anwendungen (nachfolgend „generierende KI“) bezieht. Mir ist bewusst, dass die Verwendung von generierender KI unzulässig ist, sofern nicht deren Nutzung von der prüfenden Person ausdrücklich freigegeben wurde (Freigabeerklärung). Sofern eine Zulassung als Hilfsmittel erfolgt ist, versichere ich, dass ich mich generierender KI lediglich als Hilfsmittel bedient habe und in der vorliegenden Arbeit mein gestalterischer Einfluss deutlich überwiegt. Ich verantworte die Übernahme, der von mir verwendeten maschinell generierten Passagen in meiner Arbeit vollumfänglich selbst. Für den Fall der Freigabe der Verwendung von generierender KI für die Erstellung der vorliegenden Arbeit wird eine Verwendung in einem gesonderten Anhang meiner Arbeit kenntlich gemacht. Dieser Anhang enthält eine Angabe oder eine detaillierte Dokumentation über die Verwendung generierender KI gemäß den Vorgaben in der Freigabeerklärung der prüfenden Person. Die Details zum Gebrauch generierender KI bei der Erstellung der vorliegenden Arbeit inklusive Art, Ziel und Umfang der Verwendung sowie die Art der Nachweispflicht habe ich der Freigabeerklärung der prüfenden Person entnommen.
        + Ich versichere des Weiteren, dass die vorliegende Arbeit bisher weder im In- noch im Ausland in gleicher oder ähnlicher Form einer anderen Prüfungsbehörde vorgelegt wurde oder in deutscher oder einer anderen Sprache als Veröffentlichung erschienen ist.
        + Mir ist bekannt, dass ein Verstoß gegen die vorbenannten Punkte prüfungsrechtliche Konsequenzen haben und insbesondere dazu führen kann, dass meine Prüfungsleistung als Täuschung und damit als mit „nicht bestanden“ bewertet werden kann. Bei mehrfachem oder schwerwiegendem Täuschungsversuch kann ich befristet oder sogar dauerhaft von der Erbringung weiterer Prüfungsleistungen in meinem Studiengang ausgeschlossen werden.
        ]

    v(0.5cm)

    table(columns: (auto, auto, auto, auto),
        stroke: white,
        inset: 0cm,

        strong([Ort:]) + h(0.5cm),
        repeat("."+hide("'")),
        h(0.5cm) + strong([Unterschrift:]) + h(0.5cm),
        repeat("."+hide("'")),
        v(0.75cm) + strong([Datum:]) + h(0.5cm),
        v(0.75cm) + repeat("."+hide("'")),)
}

    // outline
#let show-ountline-todo(show-outline: true, show-todolist:true, accent-color: blue) = {
        set page(footer: [])
        if show-outline {
            show heading: set text(fill:accent-color)

            set outline.entry(fill: repeat("_"))
            outline(indent: 1.5em)
            v(1fr)
        }

        if show-todolist {
            list-todos()
        }

    pagebreak(weak: true)
}