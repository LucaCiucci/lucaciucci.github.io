
// current typst version does not fully support html yet
#let html-output = "html" in sys.inputs and sys.inputs.at("html") == "true"

#let to-css-length(l) = if type(l) == relative {
    // TODO repr(l.ratio) + " " + repr(l.length)
    repr(l.length)
} else if type(l) == length {
    repr(l)
} else if type(l) == ratio {
    repr(l)
} else {
    panic("unsupported type: " + type(l))
}

#let html-article-page(
  related-articles,
  it
) = {
  show raw.where(block: true): it => {
    html.elem(
      "pre",
      html.elem(
        "code",
        attrs: (class: if it.lang != "" { "language-" + it.lang } else { none }),
        it.text
      )
    )
  }

  show raw.where(block: false): it => {
    html.elem(
      "code",
      attrs: if (it.lang != none and it.lang != "") { (class: "language-" + it.lang) } else { (:) },
      it.text
    )
  }

  let nav-btn(href, body) = html.elem(
    "div", attrs: (class: "button"),
    html.elem("a", attrs: (href: href), body)
  )

  html.elem("script", attrs: (src: "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"))
  html.elem("script", attrs: (src: "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/rs.min.js"))
  //html.elem("script", "hljs.highlightAll();")
  html.elem("script", ```
  document.addEventListener('DOMContentLoaded', (event) => {
    document.querySelectorAll('code[class^="language-"]').forEach((el) => {
      hljs.highlightElement(el);
    });
  });
  ```.text)

  show stack: it => {
    if it.dir != ltr {
      panic("only ltr is supported for now")
    }

    let style = "display: flex; flex-direction: row;"

    if it.spacing != none {
      style += " gap: " + to-css-length(it.spacing) + ";"
    }

    html.elem(
      "div",
      attrs: (style: style),
      for c in it.children {
        c
      }
    )
  }

  show image: it => {
    if type(it.source) != str {
      panic("source must be a string")
    }
    let style = ""
    if it.width != auto {
      style = "width: " + to-css-length(it.width) + ";"
    }
    if it.width == auto or it.height == auto {
      //style += "object-fit: cover;"
      style += "object-fit: contain;"
    }
    html.elem(
      "img",
      attrs: (
        src: it.source,
        //..if it.width != none { (width: to-css-length(it.width)) } else { () },
        style: style,
      ),
    )
  }

  let base = sys.inputs.at("base")

  html.elem("link", attrs: (rel: "stylesheet", href: base + "/css/style.css"))
  html.elem(
    "header",
    html.elem(
      "div",
      html.elem(
        "div", attrs: (class: "links"),
        [
          #nav-btn("./", [Luca Ciucci])
          #nav-btn(base + "/about-me/", [About Me])
          #nav-btn(base + "/projects/", [Projects])
          #nav-btn(base + "/cv/", [CV])
          #nav-btn(base + "/topics/", [Topics])
          #nav-btn(base + "/research/", [Research])
          #nav-btn("https://github.com/LucaCiucci", [GitHub])
        ]
      )
    )
  )
  html.elem(
    "div", attrs: (class:"lc-topnav"),
    html.elem("div", attrs: (class: "top-nav-links"), {
      link(base)[Luca Ciucci]
      let url = base
      for p in sys.inputs.out-rel-path.split("/") {
        link(url + "/" + p, p)
        url += "/" + p
      }
    })
  )
  html.elem("div", attrs: (class: "lc-content"), {
    html.elem("div", attrs: (class: "lc-sidebar"), {
      html.elem("div", attrs: (class: "lc-nav-index in-nav-index"), "pippo")
      // <div class="related-articles"><strong>Related articles</strong><ul><li><a href="../about-me/">About Me</a></li></ul></div>
      if related-articles.len() > 0 {
        html.elem("div", attrs: (class: "related-articles"), {
          html.elem("strong", [Related articles])
          html.elem("ul", {
            //html.elem("li", html.elem("a", attrs: (href: base + "/about-me/"), [About Me]))
            for related in related-articles {
              let (path, title) = related
              let path = if path.starts-with("/") { base + path } else { path }
              html.elem("li", html.elem("a", attrs: (href: path), title))
            }
          })
        })
      }
    })
    html.elem(
      "article",
      {
        it
        html.elem("hr")
        list(
          link(base + "/" + sys.inputs.out-rel-path.replace(".html", ".typ"))[typst source],
          link(base + "/" + sys.inputs.out-rel-path.replace(".html", ".pdf"))[styled PDF],
        )
      }
    )
    // TODO <div class="out-nav-index-container"><lc-nav-index class="out-nav-index">pippo</lc-nav-index></div>
    //html.div(attrs: (class: "out-nav-index-container"), html.elem("lc-nav-index", attrs: (class: "out-nav-index"), "pippo"))
    html.elem("div", attrs: (class: "out-nav-index-container"), html.elem("div", attrs: (class: "lc-nav-index out-nav-index"), "pippo"))
  })
  html.elem("script", attrs: (src: base + "/js/index.js"))
}

#let print = "print" in sys.inputs and sys.inputs.at("print") == "true"

#let article(
  related-articles: (),
  it
) = {
  //set heading(numbering: "1.")

  if html-output {
    show: html-article-page(
      related-articles,
      it,
    )
  } else if not print {
    set page(
      fill: rgb(21, 20, 26),
      width: 15cm,
      height: 25cm,
      //height: auto,
      //paper: "a5",
      margin: 0.5cm,
    )
    set text(fill: rgb(200, 200, 200))
    set text(font: "DejaVu Serif")
    show heading: set text(fill: color.hsl(216deg, 50%, 71%))
    show heading.where(level: 1): it => {
      box(it, stroke: (bottom: color.hsl(216deg, 50%, 71%) + 0.5pt), inset: (bottom: 0.25em), width: 100%)
    }
    //set raw(theme: "halcyon.tmTheme")
    show raw.where(block: true): it => {
      rect(it, stroke: gray + 0.5pt, radius: 0.25em, width: 100%, fill: rgb(30, 30, 30))
    }
    show raw.where(lang: none): set text(fill: rgb(219, 203, 171))
    show link: set text(fill: color.hsl(216deg, 88%, 71%))
    set table(stroke: gray + 0.5pt)
    //set page(fill: black)
    //set text(rgb(200, 200, 200))
    //rect(fill: color.hsl(0deg, 0%, 10%, 90%))
    it
  } else {
    show link: set text(fill: color.hsl(216deg, 88%, 71%).saturate(50%).darken(75%))
    it
  }
}


#let article-title(body) = if html-output {
  html.elem("h1", body)
} else {
  if not print {
    align(center, text(color.hsl(216deg, 50%, 71%), size: 2em, body))
  } else {
    align(center, text(size: 2em, body))
  }
}