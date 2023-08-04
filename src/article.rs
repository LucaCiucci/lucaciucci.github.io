use std::{path::PathBuf, fs::File, io::Write};

use vswg::{generator::Rule, path::PathVec};
use write_html::{Html, HtmlEnv, AsHtml, Compactability, tags, Empty, html};
use yaml_rust::Yaml;

pub struct HtmlArticle;
impl Rule for HtmlArticle {
    fn run(&self, root: &PathBuf, path: &PathBuf, rel: &PathVec, out_root: &PathBuf) -> bool {
        if path.extension().unwrap_or_default() != "html" {
            return false;
        }

        let src = std::fs::read_to_string(path)
            .expect("Error reading file")
            .replace("\r", "");

        let split = src
            .split("---\n")
            .map(|s| s.trim())
            .collect::<Vec<_>>();

        if split.len() != 3 {
            return false;
        }
        if split[0].len() != 0 {
            return false;
        }

        let yaml = yaml_rust::YamlLoader::load_from_str(split[1]).expect("Error parsing YAML");

        assert_eq!(yaml.len(), 1);
        let yaml = &yaml[0];

        let html = split[2];

        use write_html::*;

        let base = rel.parent().unwrap().inverse();

        let page = html!(
            (Doctype)
            html lang="en" {
                head {
                    (DefaultMeta)
                    (HeadContent(yaml, &base))
                }
                body {
                    header {
                        div {
                            div class="links" {
                                div class="button" {
                                    a href=(base.uri_dir().as_str()) { "Luca Ciucci" }
                                }
                                div class="button" {
                                    a href=((&base / "about-me").uri_dir().as_str()) { "About Me" }
                                }
                                div class="button" {
                                    a href=((&base / "cv").uri_dir().as_str()) { "CV" }
                                }
                                div class="button" {
                                    a href=((&base / "topics").uri_dir().as_str()) { "Topics" }
                                }
                                div class="button" {
                                    a href=((&base / "research").uri_dir().as_str()) { "Research" }
                                }
                                div class="button" {
                                    a href=((&base / "projects").uri_dir().as_str()) { "Projects" }
                                }
                            }
                        }
                    }
                    (TopNav(&rel))
                    div class="top-notice orange" {
                        b { "🚧 Under construction 🚧" }
                    }
(r###"
<lc-content>
<lc-sidebar>
    <!-- TODO ${this._related_articles_box} -->
    <lc-nav-index class="in-nav-index">pippo pluto</lc-nav-index>
</lc-sidebar>"###.as_html())
                    article {
                        (html.as_html())
                    }
                    script src=((&base / "js/index.js").uri_dir().as_str());
                }
            }
        ).to_html_string().unwrap();

        let out_file = out_root.join(path.strip_prefix(root).unwrap());
        let mut out_file = File::create(out_file).expect("Error creating file");
        out_file.write_all(page.as_bytes()).expect("Error writing file");

        true
    }
}

struct HeadContent<'a>(&'a Yaml, &'a PathVec);

impl<'a> Html for HeadContent<'a> {
    fn write_html(self, env: &mut impl write_html::HtmlEnv) -> std::fmt::Result {
        if let Some(title) = self.0["title"].as_str() {
            env.open_tag("title", Compactability::No)?
                .inner_html()?
                .write_html(title.as_html_text())?;
        }

        env.write_html(tags::link([
            ("rel", "stylesheet"),
            ("href", (self.1 / "css/style.css").uri().as_str())
        ], Empty))?;

        Ok(())
    }
}

struct TopNav<'a>(&'a PathVec);

impl<'a> Html for TopNav<'a> {
    fn write_html(self, env: &mut impl HtmlEnv) -> std::fmt::Result {
        let pieces = self.0.pieces();

        if pieces.is_empty() {
            return Ok(());
        }

        let mut topnav = env.open_tag("lc-topnav", Compactability::No)?
            .inner_html()?;
        
        let mut div = topnav.open_tag("div", Compactability::No)?
            .with_attr("class", "top-nav-links")?
            .inner_html()?;

        let pieces = self.0.pieces();
        let mut path = self.0.parent().unwrap().inverse();
        div.write_html(html!(
            a href=(path.uri().as_str()) { "Luca Ciucci" }
        ))?;
        for i in 0..pieces.len() {
            let name = &pieces[i];
            path = &path / name.as_str();
            div.write_html(html!(
                a href=(path.uri().as_str()) { (name.as_str().as_html_text()) }
            ))?;
        }

        Ok(())
    }
}