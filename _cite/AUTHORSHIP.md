# Publication author annotations

Reviewed on September 14, 2026 against the 22 entries in the local
`_data/citations.yaml`. The generated citation list was not changed.

`_data/authorship.yaml` stores manually verified roles by DOI. Each entry records
its source URL and a short explanation of the evidence. The citation template
looks up this file directly, so ORCID/Manubot regeneration cannot erase the roles.
Do not add superscripts to the generated author names or copy the author list into
`sources.yaml`: either would make future citation updates harder to maintain.

The display uses a dagger for equal-contributing first authors and an asterisk
for corresponding authors. Single corresponding authors are labelled in the
singular. Joint supervision and senior equal-contribution groups are NOT treated
as co-first authorship or proof of correspondence. Marked authors remain visible
even when other middle authors are abbreviated.

## Remaining verification

None for the 22 local citations reviewed here.

## Follow-up evidence

- `10.1016/j.bios.2016.06.043`: the supplied first-page screenshot
  (`codex-clipboard-15dddd81-6654-4dd2-9dc3-cc865b2d82ed.png`) confirms Xiaoming
  Yang as the sole corresponding author and shows no equal-contribution
  designation. This check is resolved.
- `10.1101/2023.11.30.569436`: the complete supplied screenshot
  (`codex-clipboard-776b4186-660f-498b-917c-c1ed1405e1cd.png`) shows footnote 13
  naming joint supervisors and their emails. Coauthor Zinan Zhou explicitly
  confirmed that Clotilde Lagier-Tourenne, Eunjung Alice Lee, and Christopher A.
  Walsh are co-corresponding authors. This check is resolved by coauthor
  confirmation, not by inferring correspondence from supervision.
- `10.1101/2025.05.19.654981`: the supplied manuscript screenshots
  (`codex-clipboard-9712eca5-b7af-4681-a583-63dd90a6ccef.png` and
  `codex-clipboard-7e0fa81a-577b-4a8f-8c90-ff255cf58535.png`) identify Jaejoon
  Choi, Kyung Sun Park, and Yann Le Guen as equal first authors; Jong-Won Kim,
  August Yue Huang, and Eunjung Alice Lee as corresponding authors. This resolves
  the check despite the previously inaccessible PDF path.

`null` means unverified. An empty list means the inspected author notes contained
no designation for that role. Neither produces markers on the site. These review
notes are for maintenance, not displayed to visitors.

The local file does not contain the journal article `10.1016/j.cell.2026.06.013`.
It was not reintroduced or substituted for its preprint as part of this change.

## Maintenance

For a newly imported DOI, check the actual paper's byline, footnotes, and
correspondence statement. Add names exactly as they appear in the generated
citation data, plus the source URL and evidence. A preprint and journal article
can have different roles and must be reviewed independently. These annotations
are preserved automatically, but newly imported papers do not acquire verified
roles automatically.

Run `ruby _cite/test_authorship.rb` in a Ruby environment with Liquid installed.
The tests flag annotated names that no longer match imported names and exercise
the real author-rendering template, including missing annotations and long lists.
