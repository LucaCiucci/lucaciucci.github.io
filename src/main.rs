
use vswg::Generator;

mod article;
mod typ_article;
use article::HtmlArticle;
use typ_article::TypArticle;

fn main() {
    env_logger::init();

    Generator::new()
        .rule(HtmlArticle)
        .rule(TypArticle)
        .run("./content", "./out");
}




