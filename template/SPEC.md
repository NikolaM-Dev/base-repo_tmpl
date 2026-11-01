# README Template Spec

Each `{{TOKEN}}` in `README.template.md`: meaning, source, rules.

## Mechanical tokens (script fills, never hand-type)

| Token                | Source                                                                                                                                                                                                                   | Rule                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------- |
| `{{OWNER_REPO}}`     | `git remote get-url origin`, normalized from ssh or https. Fallback `gh repo view --json nameWithOwner`. No remote: stop and ask.                                                                                        | `owner/repo`, no trailing `.git`.                     |
| `{{REPO_NAME}}`      | Second half of `{{OWNER_REPO}}`.                                                                                                                                                                                         | Used only in the `cd` line.                           |
| `{{DEFAULT_BRANCH}}` | `gh repo view --json defaultBranchRef`. Fallback `git branch --show-current`. Fallback `main`.                                                                                                                           | Appears in LICENSE badge link and commits badge link. |
| `{{YEAR}}`           | `date +%Y`.                                                                                                                                                                                                              | LICENSE copyright line only.                          |
| `{{LICENSE_HOLDER}}` | `git config user.name`. Missing: stop and ask, never guess.                                                                                                                                                              | LICENSE copyright line only.                          |
| `{{PREVIEW_URL}}`    | Target repo first: `docs/preview.*`, `docs/assets/preview.*`, `.github/preview.*` via that repo's raw URL. Else base fallback `https://raw.githubusercontent.com/NikolaM-Dev/base-repo_tmpl/v1/docs/assets/preview.jpg`. | Only sanctioned exception to the asset-URL rule.      |

## Content tokens (agent fills from the repo, never invents)

| Token                 | Source order                                                                                                             | Rule                                                                                             |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| `{{TITLE}}`           | Repo name, humanized.                                                                                                    | Keep short. One emoji pair max. Example: `Base Repository 🖨️🪴`.                                 |
| `{{HEADLINE}}`        | Existing README, then `gh repo view --json description`, then manifest (`package.json`, `pyproject.toml`, `Cargo.toml`). | One line, no period needed. Plain words, no placeholder text.                                    |
| `{{DESCRIPTION}}`     | Existing README, manifests, source tree, `git log --oneline -20`.                                                        | 2-4 sentences. What it is, who it is for, how it is different.                                   |
| `{{FEATURES}}`        | Source tree and manifests.                                                                                               | Markdown list, 3-5 items. Format `- **Name** – what it does`. Only features present in the code. |
| `{{INSPIRATION}}`     | Existing README, Acknowledgments, commit history.                                                                        | 1-3 sentences. What sparked it.                                                                  |
| `{{LEARNINGS}}`       | `git log`, source tree, issues.                                                                                          | Markdown list, 2-4 items. Real obstacles or insights from this repo.                             |
| `{{RUN_STEPS}}`       | `Justfile`, `package.json` scripts, `Makefile`, manifests.                                                               | Extra shell lines after `cd`. Empty when the repo has no run step. Never invent commands.        |
| `{{PREVIEW_CAPTION}}` | Project name or screenshot content.                                                                                      | Defaults to `<Repo Name> preview`. Never leave `Preview Caption`.                                |

## Fixed blocks (do not edit)

- All 8 `raw.githubusercontent.com/NikolaM-Dev/base-repo_tmpl/v1/...` asset
  URLs: logo, gap, preview fallback, footer, X, LinkedIn, GitHub, top icons.
- Footer social block (`x.com/nikolam_dev`, `linkedin.com/in/nikolam-dev`,
  `github.com/NikolaM-Dev`). Only change when the repo belongs to someone else,
  then replace the whole block.
- Acknowledgments entries. Append repo-specific thanks, never remove base
  credits.
- Star History section between `STAR-HISTORY-START` and `STAR-HISTORY-END`
  markers. Drop the whole block (markers included) for repos with fewer than 10
  stars. Otherwise keep with `{{OWNER_REPO}}` replaced.

## Verification

1. No `{{` remains.
2. No `base-repo_tmpl` outside `raw.githubusercontent.com` lines.
3. No `<...>` placeholders.
4. `cd <name>` matches the repo name.
5. TOC anchors exactly as written in the template (`#-run-locally` and
   `#-roadmap` carry no variation selector U+FE0F).
