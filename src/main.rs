use std::path::PathBuf;

use vswg::generator::Generator;

mod article;
use article::HtmlArticle;

fn main() {
    let content_dir = PathBuf::from("./content");
    let out_dir = PathBuf::from("./out");

    let generator = Generator::new()
        .rule(HtmlArticle);

    generator.run(&content_dir, &out_dir);
}




