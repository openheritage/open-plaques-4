# Organisations Infinite Scroll Design

Date: 2026-03-23  
Project: Open Plaques (`/organisations`)  
Status: Approved design (brainstorming phase)

## Objective

Replace numbered pagination UI on the public organisations index with infinite scrolling while preserving:

- alphabetical ordering
- batch size of 20 items
- no URL/history updates during loading

The interaction model is hybrid:

- auto-load first 3 subsequent pages (pages 2, 3, and 4)
- switch to manual `Load more` from page 5 onward

## Scope

In scope:

- `/organisations` HTML browsing experience
- server-rendered incremental page loading via Turbo Frames/Streams
- remove `will_paginate` controls from organisations index

Out of scope:

- changes to JSON/GeoJSON behaviors
- URL state sync and browser history/state restoration
- changes to ordering/sorting/filtering behavior

## Current Baseline

`OrganisationsController#index` currently:

- loads paginated organisations (`per_page: 20`)
- renders `@organisations` collection
- renders `will_paginate` links above and below tiles

The view renders tiles in `#organisation-tiles` and includes chart and explanatory text above the list.

## Proposed Architecture

Use Turbo incremental loading with a sentinel frame:

1. Initial `/organisations` response renders first page and a pager Turbo Frame.
2. Pager frame lazily requests next page for pages 2-4.
3. Each next-page response returns Turbo Stream operations:
   - append new organisation tiles into `#organisation-tiles`
   - replace pager frame with pointer to next page (or terminal state)
4. From page 5 onward, pager renders a `Load more` action instead of lazy auto-loading.
5. End-of-list replaces pager frame with terminal state (or blank).

No browser URL/history mutations are performed.

## Request/Response Contract

- Incremental loads use `GET /organisations?page=:n&cursor=:n_minus_1`.
- Initial full page request uses `format: html`.
- Auto-load requests (pages 2-4) are initiated by lazy `turbo-frame#organisations_pager[src=...]` GETs (including both `page` and `cursor`) and return frame HTML containing embedded `<turbo-stream>` actions (`append` + `replace`).
- Manual requests (page 5+) use `Load more` with Turbo Stream GET (`data-turbo-stream="true"`) including both `page` and `cursor`, returning `format: turbo_stream`.
- Both auto and manual requests target the same page contract and apply the same append/replace semantics.
- Manual `Load more` control lives inside `turbo-frame#organisations_pager` and requests the next page via GET.
- Non-Turbo/non-JS access may still receive normal HTML page output for direct navigation, but no numbered pagination UI is shown in the primary organisations template.

Examples:

- auto page 2 request: `/organisations?page=2&cursor=1`
- auto page 4 request: `/organisations?page=4&cursor=3`
- manual page 5 request: `/organisations?page=5&cursor=4`

## Components

### Controller (`OrganisationsController#index`)

Continue using existing query semantics:

- `alphabetically`
- `select(:language_id, :name, :slug, :sponsorships_count)`
- `paginate(page: ..., per_page: 20)`
- deterministic order requirement: `ORDER BY name ASC, id ASC` (or equivalent scope behavior) so page boundaries are stable when names tie

Add response handling for `turbo_stream`:

- compute `next_page` from paginated result
- compute loading mode for `next_page`:
  - auto if `next_page <= 4`
  - manual if `next_page >= 5`

### Views

Decompose organisations index rendering into reusable partials:

- tile list rendering partial (reusing existing organisation partials)
- pager frame partial for:
  - lazy auto mode
  - manual load-more mode
  - terminal/no-more mode

Index page removes `will_paginate` controls entirely.

### Turbo Stream Template

For incremental requests:

- `append` organisation batch into `organisation-tiles`
- `replace` `organisations_pager` with next pager state

To avoid duplicate inserts on retries/races:

- each organisation tile must use a deterministic DOM id (for example, `dom_id(organisation)`)
- each appended batch should be wrapped by page container id (for example, `org-page-#{page}`)
- pager requests are single-flight: disable `Load more` while request is active

## Data Flow

Initial load:

- browser requests `/organisations`
- server returns first 20 tiles and pager frame targeting page 2

Auto phase:

- scrolling reveals lazy frame; frame requests page 2, then 3, then 4
- each response appends tiles and advances pager

Manual phase:

- pager switches to visible `Load more`
- click triggers next page stream request
- append/advance repeats until exhaustion

## Error Handling and Resilience

Pager state machine:

- `loading(page=n)` -> `ready(page=n+1)` on success
- `loading(page=n)` -> `error(page=n)` on failure
- retry action from error state always re-requests same page `n`
- `terminal` when `next_page` is nil

Additional guarantees:

- failed next-page load renders retry state in pager frame with explicit `Try again`
- out-of-range page renders no append and terminal pager replacement
- stale responses for earlier pages must not advance pointer; enforce with `cursor` guard:
  - pager carries `cursor` (last successfully rendered page)
  - request for `page=n` must include `cursor=n-1`
  - controller treats mismatched cursor as stale and returns no-op pager refresh without append

## UX and Accessibility

- Loading state shown in pager area while request is in-flight.
- `Load more` is keyboard accessible with clear label.
- Appends should not disrupt current scroll position.
- End state is explicit (`No more organisations`) or cleanly hidden pager.

## Performance Notes

- Retain selective columns for index list query.
- Keep page size at 20.
- If masonry layout requires refresh after append, trigger minimal reflow hook after stream append.

## Testing Strategy

### Request specs

- HTML index returns first page and pager frame.
- Turbo Stream page request appends expected tiles.
- Pager mode transitions to manual at page 5.
- Last page removes/replaces pager appropriately.
- Turbo Stream payload includes exactly:
  - one `append` targeting `organisation-tiles`
  - one `replace` targeting `organisations_pager`

### System spec

- Visit `/organisations`.
- Verify first page tiles render.
- Trigger auto-loading for pages 2-4 and confirm count increases.
- Verify page 5 requires explicit `Load more`.
- Verify `Load more` is not shown during auto-load phase and appears from manual phase onward.
- Verify `Load more` control is disabled/guarded while request is in flight.
- Verify retries do not create duplicate organisation tile ids.
- Verify URL does not change during incremental loads.

## Risks and Mitigations

- Turbo integration mismatch with current frontend stack  
  Mitigation: isolate behavior to organisations index and keep fallback pager template simple.

- Duplicate appends on race conditions  
  Mitigation: single pager frame id, one next-page pointer, and deterministic stream replace behavior.

- Layout glitches after append (masonry)  
  Mitigation: apply targeted post-append layout refresh.
