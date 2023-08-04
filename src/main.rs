
use vswg::Generator;

mod article;
use article::HtmlArticle;

fn main() {
    Generator::new()
        .rule(HtmlArticle)
        .run("./content", "./out");
}




