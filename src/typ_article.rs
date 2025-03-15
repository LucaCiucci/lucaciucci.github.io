use std::{fs::File, io::Write, path::PathBuf};

use vswg::{PathVec, Rule};
use write_html::HtmlEnv;


pub struct TypArticle;

impl Rule for TypArticle {
    fn run(&self, root: &PathBuf, path: &PathBuf, rel: &PathVec, out_root: &PathBuf) -> bool {
        if path.extension().unwrap_or_default() != "typ" {
            return false;
        }

        let project_root = std::env::current_dir().unwrap();
        let project_root = project_root.to_str().unwrap();

        // relative base path
        let base = rel.parent().unwrap().inverse();

        // copy the original file
        std::fs::copy(
            path,
            out_root.join(path.strip_prefix(root).unwrap()),
        ).expect(&format!("Error copying file {path:?}"));

        // run typst to create the pdf
        let status = std::process::Command::new("typst")
            .arg("compile")
            .args(["--root", project_root])
            .args(["--input", "print=true"])
            .arg(path)
            // output file
            .arg(out_root.join(path.strip_prefix(root).unwrap()).with_extension("pdf"))
            .status()
            .expect("Error running typst");

        if !status.success() {
            log::error!("Error running typst: {:?}", status);
        }

        // create html
        let status = std::process::Command::new("typst")
            .arg("compile")
            .args(["--root", project_root])
            .args(["--features", "html"])
            .args(["--input", "html=true"])
            .args(["--input", &format!("base={}", base.uri())])
            .args(["--input", &format!("src-rel-path={}", rel.uri())])
            .args(["--input", &format!("out-rel-path={}", rel.uri().replace(".typ", ".html"))]) // FIXME do not use replace
            .arg(path)
            // output file
            .arg(out_root.join(path.strip_prefix(root).unwrap()).with_extension("html"))
            .status()
            .expect("Error running typst");

        if !status.success() {
            log::error!("Error running typst: {:?}", status);
        }

        true
    }
}