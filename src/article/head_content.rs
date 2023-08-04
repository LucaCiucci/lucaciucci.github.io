use super::*;

pub struct HeadContent<'a>(pub &'a Yaml, pub &'a PathVec);

impl<'a> Html for HeadContent<'a> {
    fn write_html(self, env: &mut impl write_html::HtmlEnv) -> std::fmt::Result {
        let yaml = self.0;

        // title
        if let Some(title) = yaml["title"].as_str() {
            env.write_html(html! {
                title { (title.as_html_text()) }
            })?;
        }

        // style sheet
        env.write_html(html! {
            link
                rel="stylesheet"
                href=((self.1 / "css/style.css").uri().as_str());
        })?;

        Ok(())
    }
}