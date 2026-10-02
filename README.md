# genealogy-research

A repo for displaying genealogy research to family and friends.

The family trees here are **password-protected**: each page is encrypted with
[StatiCrypt](https://github.com/robinmoisson/staticrypt) (AES-256) before it is
committed, so this public repo only ever contains encrypted pages. Readable
copies never leave the researcher's computer.

## Trees

| Tree | Page |
| --- | --- |
| Holbrook-Low Colonial Tree | https://dasloops.github.io/genealogy-research/holbrook-low/ |

## Updating a tree

1. Edit the readable tree in `~/Documents/GENEALOGY/...` as usual.
2. Run `./encrypt.sh`. It re-encrypts every tree and prints each share link.
3. Commit and push. GitHub Pages updates in a minute or two.

The password lives in `.staticrypt-password` (git-ignored, local only).
`.staticrypt.json` holds the salt; keep it committed so share links stay the
same across re-encryptions.

To add a tree, add a line to the `TREES` list in `encrypt.sh`.

## Safety net

A pre-commit hook (`.githooks/pre-commit`) refuses to commit any `.html` page
that isn't encrypted. After a fresh clone, enable it with:

    git config core.hooksPath .githooks
