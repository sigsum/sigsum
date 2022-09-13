# www.sigsum.org
This website is built using [Hugo][] and the [researcher][] theme.

[Hugo]: https://gohugo.io/
[researcher]: https://github.com/ojroques/hugo-researcher

## Quick start after cloning

1. Run `git submodule update --init --recursive`.
2. Install Hugo
   - `apt install hugo` on a Debian system, or
   - follow the instruction [here][] to install from source.
3. Try serving the website locally
   1. Run `hugo serve`
   2. Browse http://localhost:1313

[here]: https://gohugo.io/getting-started/installing/#fetch-from-github

## Generate a new website that can be published

1. Check that it runs as expected locally (see quick start, step 3).
2. Run `hugo` to create the `public` repository that should be deployed.
