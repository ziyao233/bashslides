# Bashslides

Generate HTML-based slides from Markdown with bash scripts.

## Dependency

- `bash`
- `coreutils`
- `md4c` [Library and tool](https://github.com/mity/md4c/) for converting
  Markdown to HTML
- `file` for detecting MIME type of a file

## Usage

`bashslides.sh` simplify read Markdown document from stdin, and writes the
result to stdout. A typical usage looks like,

```shell
$ ./bashslides < demo.md > demo.html
# View it with "firefox demo.html"
```

`bashslides.sh` looks for `header.html` and `footer.html` at runtime. They
should locate at `$(which bashslides.sh)` or `$(which bashslides.sh)/../share`.

## Special Features

With `md4c`, Common Markdown features are all supported, and you may use
HTML tags in the Markdown documentation as well.

Additionally, some extra syntax is introduced,

- Every page should be enclosed in a pair of `<div>` and `</div>`.
- You may enclose a file path inside double dollar (`$$path.png$$`) to instruct
  `bashslides.sh` to convert the file content to a data URI and embed it in the
  result HTML, avoiding the burden of keeping the resource files.

Refer to `demo.md` for better demonstration.

Warning: don't try to edit the result HTML that contains data URI! Many editors
cannot handle it well.

## Show the Slide

After converting the Markdown document to HTML, you could open it directly in
browsers. For pageflipping, arrow keys may be used. Alternatively, short press
switches to the next page, and long press does the opposiste.

## Fun usage

HTML as a slide means you may put it on an arbitrary website, and show it
everywhere without downloading or special programs.

## Why?

I'm just too lazy to learn TeX or Typst, and Groff/Mom cannot render CJK
characters correctly. Libreoffice just looks too large. I don't want the
horrible NodeJS and other modern front-end stuff on my machine, so here's
bashslides.

## Disclaimer

Obviously I am NOT an expert in front-end programming, thus the JavaScript may
look terrible. Use the project on your own risk.
