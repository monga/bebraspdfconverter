# bebraspdfconverter

Convert Bebras task proposals to pdf.

To build a local docker container, clone this repo and:

```sh
docker build -t mmonga/bebraspdfconverter .
```

(or use the pre-built image on the docker hub: `docker pull mmonga/bebraspdfconverter`)

To run it, `cd` in the `TaskProposals` directory and:

```sh
docker run --rm -ti -v $(pwd):/home/user mmonga/bebraspdfconverter
```

(if your system doesn't support the `$(pwd)` syntax, just write down the full
path of the `TaskProposals` directory.)

The `mkpdf.sh` script creates two files in the current directory: `all.pdf`
(with all the pages) and `all-first.pdf` (with just the first pages).
