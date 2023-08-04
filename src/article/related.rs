use super::*;

pub struct RelatedArticles<'a>(pub &'a Yaml);
impl<'a> Html for RelatedArticles<'a> {
    fn write_html(self, env: &mut impl HtmlEnv) -> std::fmt::Result {
        let yaml = self.0;

        if let Some(related_articles) = yaml["related_articles"].as_vec() {
            env.write_html(html! {
                div class="related-articles" {
                    strong { "Related articles" }
                    ul {(
                        related_articles.iter().map(|article| {
                            html! {
                                li {
                                    a href=(article["url"].as_str().unwrap()) {
                                        (article["title"].as_str().unwrap().as_html_text())
                                    }
                                }
                            }
                        })
                    )}
                }
            })?;
        }

        Ok(())
    }
}
