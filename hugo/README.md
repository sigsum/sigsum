# Static website
www.sigsum.org can be generated as a static website using [hugo](https://gohugo.io)
and the [hugo-xmin](https://github.com/yihui/hugo-xmin) theme.

## One-time setup
1. Install `hugo`
1. Initialize theme: `git submodule update --init --recursive`

## Test locally
1. Run `hugo serve`
2. Browse http://localhost:1313

## Generate
1. Run `hugo`
2. Static website is now located in `public`
