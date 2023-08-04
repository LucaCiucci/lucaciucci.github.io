use super::*;

pub struct HeadContent<'a>(pub &'a Yaml, pub &'a PathVec);

impl<'a> Html for HeadContent<'a> {
    fn write_html(self, env: &mut impl write_html::HtmlEnv) -> std::fmt::Result {
        let yaml = self.0;
        let base = self.1;

        // title
        if let Some(title) = yaml["title"].as_str() {
            env.write_html(html! {
                title { (title.as_html_text()) }
                meta name="og:title" content=(title);
                meta name="twitter:title" content=(title);
            })?;
        }

        // style sheet
        env.write_html(html! {
            link rel="stylesheet" href=((self.1 / "css/style.css").uri().as_str());
        })?;

        // favicon
        let favicon = yaml["favicon"].as_str().unwrap_or("favicon.svg");
        env.write_html(html! {
            link rel="icon" href=((base / favicon).uri().as_str());
            link rel="shortcut icon" href=((base / favicon).uri().as_str());
        })?;

        // description
        if let Some(description) = yaml["description"].as_str() {
            env.write_html(html! {
                meta name="description" content=(description);
                meta name="og:description" content=(description);
                meta name="twitter:description" content=(description);
            })?;
        }

        // subject
        if let Some(subject) = yaml["subject"].as_str() {
            env.write_html(html! {
                meta name="subject" content=(subject);
            })?;
        }

        // keywords
        if let Some(keywords) = yaml["keywords"].as_str() {
            env.write_html(html! {
                meta name="keywords" content=(keywords);
            })?;
        }

        // author
        if let Some(author) = yaml["author"].as_str() {
            env.write_html(html! {
                meta name="author" content=(author);
            })?;
        }

        // image
        if let Some(image) = yaml["image"].as_str() {
            env.write_html(html! {
                meta name="og:image" content=((base / image).uri().as_str());
                meta name="twitter:image" content=((base / image).uri().as_str());
            })?;
        }

        // additional head content
        if let Some(head) = yaml["head"].as_str() {
            env.write_html(head.as_html())?;
        }

        Ok(())
    }
}