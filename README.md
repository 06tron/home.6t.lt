# home.6t.lt

My approach to maintaining a personal website.

## Commands

`home.6t.lt % conda activate snakemake`
- start environment where [Snakemake](https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html) can be used

`home.6t.lt % snakemake -c1 -n`
- performs dry-run of main build process

`home.6t.lt % npx wrangler deploy --env=beta`
- updates the testing version of my website: https://ß.6t.lt/sitemap.html
