use std::{path::PathBuf, fs::File, io::Write};

use vswg::{Rule, PathVec};
use write_html::{Html, HtmlEnv, AsHtml, html};
use yaml_rust::Yaml;

mod header; use header::*;
mod head_content; use head_content::*;
mod top_nav; use top_nav::*;
mod related; use related::*;

pub struct HtmlArticle;
impl Rule for HtmlArticle {
    fn run(&self, root: &PathBuf, path: &PathBuf, rel: &PathVec, out_root: &PathBuf) -> bool {
        if path.extension().unwrap_or_default() != "html" {
            return false;
        }

        // relative base path
        let base = rel.parent().unwrap().inverse();

        // load the file, remove "\r"
        let src = std::fs::read_to_string(path)
            .expect("Error reading file")
            .replace("\r", "");

        // split the file in 2 parts: yaml and html. Example:
        // ---
        // title: "My title"   <- yaml
        // ---
        // <h1>My title</h1>   <- html
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

        let split = &split[1..];

        // parse the yaml
        let yaml = yaml_rust::YamlLoader::load_from_str(split[0])
            .expect(format!("Error parsing yaml in file {:?}", path).as_str());

        // we should have only one yaml
        assert_eq!(yaml.len(), 1);
        let yaml = &yaml[0];

        let mut html = String::new();

        // title
        if let Some(title) = yaml["title"].as_str() {
            html.write_html(html! {
                h1 { (title.as_html_text()) }
            }).unwrap();
        }

        // description
        if let Some(description) = yaml["description"].as_str() {
            html.write_html(html! {
                article-description { (description.as_html_text()) }
            }).unwrap();
        }

        // date
        if let Some(date) = yaml["date"].as_str() {
            html.write_html(html! {
                article-date { (date.as_html_text()) }
            }).unwrap();
        }

        html += split[1];

        let html = html.as_html();

        use write_html::*;

        // create the page
        let page = html!(
            (Doctype)
            html lang="en" {
                head {
                    (DefaultMeta)
                    (HeadContent(yaml, &base))
                    (r##"
                     <!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-VJDBPCCRK7"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-VJDBPCCRK7');
</script>
                     "##.as_html())
                }
                body {
                    (BodyHeader(base.clone()))
                    (TopNav(&rel))
                    div class="top-notice orange" {
                        b { "🚧 Under construction 🚧" }
                    }
                    lc-content {
                        lc-sidebar {
                            lc-nav-index class="in-nav-index" { "pippo" }
                            (RelatedArticles(yaml))
                        }
                        article {
                            (html)
                        }
                        div class="out-nav-index-container" {
                            lc-nav-index class="out-nav-index" { "pippo" }
                        }
                    }
                    script src=((&base / "js/index.js").uri().as_str());
                }
            }
        ).to_html_string().unwrap();

        let out_file = out_root.join(path.strip_prefix(root).unwrap());
        let mut out_file = File::create(out_file).expect("Error creating file");
        out_file.write_all(page.as_bytes()).expect("Error writing file");

        true
    }
}
