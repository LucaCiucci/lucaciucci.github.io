#import "../../typst/article.typ": article, article-title, html-output

#set document(title: [Luca Ciucci - CV], description: "foo")

#show: article.with(
    related-articles: (
        ("/about-me/", [About Me]),
    ),
)

#article-title[Luca Ciucci]

#let info-table = table(columns: 2)[
    home address
][
    #link("https://goo.gl/maps/szUPzgGoyFhpd5kN7")[via Colle da Sole, 37], Torre San Patrizio, FM, Italy
][
    residence
][
    #link("https://maps.app.goo.gl/GAsvPHLycYZ1CWkb8")[via Francesco Rismondo, 35], Pisa, PI, Italy
][
    phone number
][
    #link("tel:+393245509174")[+39 324 550 9174]
][
    E-Mail
][
    #link("mailto:luca.ciucci99@gmail.com")[luca.ciucci99\@gmail.com]\
    #link("luca@scanny3d.com")[luca\@scanny3d.com]\
    #link("luca@lucaciucci99.com")[luca\@lucaciucci99.com]\
]

#context if html-output {
    html.elem(
        "div",
        attrs: (style: "display: flex;flex-wrap: wrap;justify-content: space-around;align-items: center;align-content: center;"),
        {
            info-table
            html.elem(
                "img",
                attrs: (src: "me.jpg", alt: "myself", style: "height: 12em; border-radius: 10px; margin: 0.5em;"),
            )
        },
    )
} else {
    stack(
        dir: ltr,
        box(width: 100% - 13em, info-table),
        align(right, block(radius: 0.75em, clip: true, image("me.jpg", width: 12em))),
    )
}

= Main Interests

- *Physics*
- *Math*
- *Programming*
  - languages:
    - `Rust`
    - `C++` & `C` (and some popular build systems like `CMake`, `make`, `Visual Studio`)
    //- `C++` (& `C`): advanced practical experience, I use `CMake` and `Visual Studio` as build systems
    //- `Rust`: a recent adoption in my toolset, still learning but already developing real-life algorithms and a new GUI library
    //- `Matlab`: used matlab since prior to my university studies, especially for data analysis and visualization
    - `Matlab`
    //- `TypeScript` & `JavaScript`: for both frond-end and back-end
    - `TypeScript` & `JavaScript`
    - `HTML` & `CSS`
    - `Typst`
    //- `Python`: data analysis
    - `Python`
    - `prolog` (just yet fluent in it)
    //- `Fortran`: used for a university course
    - `Fortran`
    //- `LabView`: used for a university course
    - `LabView`
    - `LaTex`
    - `Java`
    - `Pascal`
    - `PIC Basic`
  - systems: *Desktop*, *Microcontrollers*, *Embedded*
  - technologies: *3D reconstruction*, *Quaternions*, *Differentials*, *Numerical Optimization*, *image processing*, *camera calibration*, *Neural Networks*, *GUI*
- *Electronics*: some very basic knowledge, worked mainly with prebuilt boards
- *Mechanics*: many manual tools, *CNC machines* (+ *G-CODE* & *CAM*), *3D printing*

= Work Experience

== Software developer \@ BUGSENG s.r.l.

Since 2024/09

== research and development \@ Scanny3D s.r.l.

- software developer
- algorithm developer, mainly for 3D reconstruction
- electronics and mechanics experience
- 3D printing experience

= Publications

+ P. Francavilla, M.R. Felici, E. Cisbani, et al, #link("https://doi.org/10.22323/1.314.0822")[_"A low-cost Cherenkov detector to be tested in CERN's T9 beam line"_] (2018)

= Education

#let event-with-image(img-src, alt, body) = if html-output {
    html.elem(
        "img",
        attrs: (src: img-src, alt: alt, style: "width: 7em; margin: 0.5em; border-radius: 0.25em; float: right;"),
    )
    body
} else {
    stack(
        dir: rtl,
        spacing: 0.5em,
        align(horizon, block(radius: 0.25em, clip: true, image(img-src, width: 7em))),
        block(width: 100% - 7.5em, body),
    )
}

#let rows = (
    ([*17/9/2018* - now], [*University of Pisa*\ Stared my studies in physics course #link("https://www.unipi.it/index.php/lauree/corso/10441")[L-30]]),
    ([*17/7/2017* - *21/7/2017*], [*Ducati "Fisica in moto" summer school*\ Attended some lesson on mechanics, physics laboratory, motorbikes mechanical development, production, data analysis and cooperative problem solving.]),
    ([*26/6/2017* - *1/7/2017*], [*"Modern Physics for students" summer school*\ Attended some physics courses with particular emphases on both classical and modern physics introduction. Laboratory experiences on measurements and computing.]),
    ([*xx/3/2017*], event-with-image("ippog.png", "ippog")[*IPPOG International masterclass 2017*\ Attended some courses on high energy particle accelerator physics at the LNF INFN laboratories. Particularly interested on accelerating technologies and tracing detectors.]),
    ([*4/6/2018*], [*Cambridge English First Certificate*\ English level B2.]),
    ([*2013* / *2018*], event-with-image("tco.png", "tco")[*Scientific high school diploma*\ Applied science section, 100/100 score.])
)


#table(columns: (8em, auto), ..rows.flatten())

= Educational projects

#let rows = (
    ([*6/6/2023*], [*"Learning by doing" competition winners*\ We created #link("https://github.com/bbf-project/body-tracking-web")[_Body Tracking Web_] and _VDU posture monitor_ software to help people improve their posture while working at a video terminal. We won the competition and we are now working on the project to make it a real product.]),
    ([*17/12/2019*], event-with-image("asml.png", "asml")[*"ASML Intergalactic Coding Challenge" winner*\ I was a Winner of the ASML Intergalactic Coding Challenge 2019. ]),
    ([*20/9/2017* - *2/10/2017*], event-with-image("beamline-cern.png", "beamline-cern")[*CERN's days as BL4S winners*\ Two week experience at CERN, performing tests on the beam of T9 beam facility with the proposed and built Cherenkov detector. I was particularly involved in the detector design, construction and testing, data analysis and electronics.
    - #link("https://web.archive.org/web/20230128071752/http://www.tco-beamline.com/", "http://www.tco-beamline.com/")
    - #link("https://beamline-for-schools.web.cern.ch/editions/2017-edition")
    //- #link("https://home.infn.it/it/%C2%ADit/comunicazione/com%C2%ADunicati-stampa/2336-%C2%ADbeamline-for-schools%C2%AD-studenti-di-fermo-c%C2%ADampioni-del-mondo")[articolo INFN]]),
    - #link("https://web.archive.org/web/20210613061858/https://home.infn.it/it/%C2%ADit/comunicazione/com%C2%ADunicati-stampa/2336-%C2%ADbeamline-for-schools%C2%AD-studenti-di-fermo-c%C2%ADampioni-del-mondo")[articolo INFN]]),
    ([*22/9/2016*], event-with-image("beamline.png", "beamline")[*LNF (INFN)*\ Performed some experiments with the Cherenkov detector of the 2016 BL4S proposal on one of the Frascati INFN's LINAC's beam (BTF).]),
    ([*2017*], event-with-image("pack-man.png", "pack-man")[*"Olimpiadi della robotica"*\ Participated with the "_pac-man_" project for which I built the most of the robot and all the firmware.]),
    ([*2016*], event-with-image("bl4s-group.png", "bl4s-group")[*First BL4S proposal*\ Participated in the first group of the school project of a Cherenkov effect detector proposal for the 2016 CERN BL4S competition.])
)

#table(columns: (8em, auto), ..rows.flatten())