use super::*;

pub struct TopNav<'a>(pub &'a PathVec);

impl<'a> Html for TopNav<'a> {
    fn write_html(self, env: &mut impl HtmlEnv) -> std::fmt::Result {
        let pieces = self.0.pieces();

        if pieces.is_empty() {
            return Ok(());
        }

        let pieces = self.0.pieces();
        let mut path = self.0.parent().unwrap().inverse();
        let mut nav_links = vec![
            (path.uri(), "Luca Ciucci".to_string()),
        ];
        for i in 0..pieces.len() {
            let name = &pieces[i];
            path = &path / name.as_str();
            nav_links.push((path.uri(), name.to_string()));
        }

        env.write_html(html!{
            lc-topnav {
                div class="top-nav-links" {
                    (nav_links.iter().map(|(uri, name)| {
                        html!{
                            a href=(uri.as_str()) { (name.as_str().as_html_text()) }
                        }
                    }))
                }
            }
        })?;

        Ok(())
    }
}