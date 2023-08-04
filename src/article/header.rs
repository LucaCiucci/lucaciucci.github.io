use super::*;

pub struct BodyHeader(pub PathVec);


impl Html for BodyHeader {
    fn write_html(self, env: &mut impl HtmlEnv) -> std::fmt::Result {
        let base = self.0;

        env.write_html(html! {
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
        })?;

        Ok(())
    }
}