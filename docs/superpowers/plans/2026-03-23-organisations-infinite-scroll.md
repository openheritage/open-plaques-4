# Organisations Infinite Scroll Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `/organisations` numbered pagination with Turbo-driven infinite scrolling (auto pages 2-4, then `Load more`) while preserving alphabetical order and `per_page: 20`.

**Architecture:** Keep `OrganisationsController#index` as the single query source for both initial HTML and incremental loads. Use Turbo Frame lazy loading for the auto phase and Turbo Stream responses to append organisation tiles + replace a single pager frame. Protect against stale/racing requests using `cursor = page - 1` validation and no-op stale responses.

**Tech Stack:** Rails 8, RSpec (`request` + `system`), ERB partials, Hotwire Turbo (Frames + Streams), importmap/stimulus, will_paginate query API.

---

## File Structure

- Modify: `app/controllers/organisations_controller.rb`
  - Add `PER_PAGE = 20`, auto/manual mode thresholds, cursor guard, and Turbo response handling.
  - Enforce deterministic ordering (`name ASC, id ASC`) via explicit ordering/scope.
- Modify: `app/models/concerns/nameable.rb` (only if needed)
  - Update `alphabetically` scope to include tie-breaker `id ASC` safely.
- Modify: `app/views/organisations/index.html.erb`
  - Remove `will_paginate` controls and mount infinite pager frame.
- Create: `app/views/organisations/_organisation_tiles.html.erb`
  - Render page batch wrapper (`org-page-<page>`) and existing organisation card partials.
- Create: `app/views/organisations/_infinite_pager.html.erb`
  - Render pager states: auto-lazy, manual `Load more`, retry (`Try again`), terminal.
- Create: `app/views/organisations/index.turbo_stream.erb`
  - Stream append tiles and replace pager frame, with stale-cursor no-append behavior.
- Create: `app/views/organisations/index.turbo_frame.erb` (or equivalent frame template/partial)
  - Return frame HTML that embeds `<turbo-stream>` actions for lazy auto-load requests.
- Create: `spec/requests/organisations_infinite_scroll_spec.rb`
  - Request contract and resilience tests.
- Create: `spec/system/organisations_infinite_scroll_spec.rb`
  - Browser-level flow tests (auto phase, manual phase, URL unchanged).

## Task 1: Request spec contract first (TDD)

**Files:**

- Create: `spec/requests/organisations_infinite_scroll_spec.rb`
- Test: `spec/requests/organisations_infinite_scroll_spec.rb`

- [ ] **Step 1: Write failing request spec for initial HTML shell**

```ruby
it "renders tiles and turbo pager without pagination links" do
  get organisations_path
  expect(response).to have_http_status(:ok)
  expect(response.body).to include('id="organisation-tiles"')
  expect(response.body).to include('turbo-frame id="organisations_pager"')
  expect(response.body).not_to include('class="pagination"')
end
```

- [ ] **Step 2: Run spec to verify failure**

Run: `bundle exec rspec spec/requests/organisations_infinite_scroll_spec.rb:1`  
Expected: FAIL (pagination still present / pager frame absent).

- [ ] **Step 3: Write failing spec for Turbo Stream append+replace contract**

```ruby
it "returns append+replace turbo stream operations for valid cursor" do
  get organisations_path, params: { page: 2, cursor: 1 }, headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
  expect(response).to have_http_status(:ok)
  expect(response.body.scan('action="append" target="organisation-tiles"').size).to eq(1)
  expect(response.body.scan('action="replace" target="organisations_pager"').size).to eq(1)
end
```

- [ ] **Step 4: Write failing specs for resilience requirements**

```ruby
it "shows retry state with Try again when incremental load errors" do
  # simulate failing fetch path and expect retry UI in pager frame
end

it "returns no append for stale cursor" do
  get organisations_path, params: { page: 4, cursor: 1 }, headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
  expect(response.body).not_to include('action="append" target="organisation-tiles"')
end

it "returns terminal/no-append for out-of-range page" do
  get organisations_path, params: { page: 99_999, cursor: 99_998 }, headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
  expect(response.body).not_to include('action="append" target="organisation-tiles"')
end
```

- [ ] **Step 5: Run request spec file**

Run: `bundle exec rspec spec/requests/organisations_infinite_scroll_spec.rb`  
Expected: FAIL.

- [ ] **Step 6: Commit failing contract tests**

```bash
git add spec/requests/organisations_infinite_scroll_spec.rb
git commit -m "test: define organisations infinite scroll request contract"
```

## Task 2: Controller/query implementation

**Files:**

- Modify: `app/controllers/organisations_controller.rb`
- Modify (if needed): `app/models/concerns/nameable.rb`
- Test: `spec/requests/organisations_infinite_scroll_spec.rb`

- [ ] **Step 1: Implement minimal query/state constants**

```ruby
PER_PAGE = 20
AUTO_LOAD_LAST_PAGE = 4
@page = [params.fetch(:page, 1).to_i, 1].max
@cursor = params[:cursor].to_i if params[:cursor].present?
@stale_cursor = @page > 1 && @cursor != (@page - 1)
```

- [ ] **Step 2: Implement deterministic ordering**

Ensure organisations are sorted with stable tie-break:

```ruby
Organisation.select(...).order(Arel.sql("name ASC NULLS LAST, id ASC"))
```

or update `alphabetically` scope to include `id ASC`.

- [ ] **Step 3: Add Turbo response branch**

`format.turbo_stream` should set `@next_page`, `@auto_mode`, pager state, and stale no-op behavior.

- [ ] **Step 4: Run request specs**

Run: `bundle exec rspec spec/requests/organisations_infinite_scroll_spec.rb`  
Expected: some tests pass; view/template tests may still fail.

- [ ] **Step 5: Commit controller/model changes**

```bash
git add app/controllers/organisations_controller.rb app/models/concerns/nameable.rb
git commit -m "feat: add organisations infinite-scroll controller states"
```

## Task 3: HTML view shell + pager partials

**Files:**

- Modify: `app/views/organisations/index.html.erb`
- Create: `app/views/organisations/_organisation_tiles.html.erb`
- Create: `app/views/organisations/_infinite_pager.html.erb`
- Test: `spec/requests/organisations_infinite_scroll_spec.rb`

- [ ] **Step 1: Remove `will_paginate` controls from organisations index**

- [ ] **Step 2: Render initial tiles + pager frame**

```erb
<div id="organisation-tiles">
  <%= render "organisation_tiles", organisations: @organisations, page: @page %>
</div>
<%= render "infinite_pager", next_page: @next_page, auto_mode: @auto_mode, cursor: @page, state: :ready %>
```

- [ ] **Step 3: Implement `_organisation_tiles` wrapper**

```erb
<div id="org-page-<%= page %>">
  <%= render organisations %>
</div>
```

- [ ] **Step 4: Implement `_infinite_pager` states**

- `ready + auto`: lazy frame with `src=/organisations?page=n&cursor=n-1`
- `ready + manual`: `Load more` link with `data-turbo-stream="true"`
- `error`: show `Try again` link for same page+cursor
- `terminal`: hide pager or render `No more organisations`

- [ ] **Step 5: Run request specs**

Run: `bundle exec rspec spec/requests/organisations_infinite_scroll_spec.rb`  
Expected: HTML shell tests pass.

- [ ] **Step 6: Commit view shell**

```bash
git add app/views/organisations/index.html.erb app/views/organisations/_organisation_tiles.html.erb app/views/organisations/_infinite_pager.html.erb
git commit -m "feat: add organisations infinite-scroll html shell"
```

## Task 4: Turbo Stream template + stale/no-op behavior

**Files:**

- Create: `app/views/organisations/index.turbo_stream.erb`
- Create: `app/views/organisations/index.turbo_frame.erb` (or equivalent)
- Modify: `app/views/organisations/_infinite_pager.html.erb`
- Test: `spec/requests/organisations_infinite_scroll_spec.rb`

- [ ] **Step 1: Implement dual incremental response paths**

Controller branching must be explicit:

- **Auto phase (pages 2-4 lazy frame `src`)**: return frame HTML template that contains embedded `<turbo-stream>` append+replace tags.
- **Manual phase (`Load more`, `data-turbo-stream="true"`)**: return `text/vnd.turbo-stream.html` via `index.turbo_stream.erb`.

- [ ] **Step 2: Implement stream append+replace for valid cursor**

```erb
<%= turbo_stream.append "organisation-tiles", partial: "organisations/organisation_tiles", locals: { organisations: @organisations, page: @page } unless @stale_cursor || @organisations.blank? %>
<%= turbo_stream.replace "organisations_pager", partial: "organisations/infinite_pager", locals: { next_page: @next_page, auto_mode: @auto_mode, cursor: @page, state: :ready } %>
```

- [ ] **Step 3: Implement error/retry state path**

When incremental load fails, replace pager with:

- message: `Couldn’t load more organisations`
- retry control: `Try again` for same `page/cursor`

- [ ] **Step 4: Ensure out-of-range returns terminal/no-append**

- [ ] **Step 5: Run request specs**

Run: `bundle exec rspec spec/requests/organisations_infinite_scroll_spec.rb`  
Expected: PASS.

- [ ] **Step 6: Commit incremental response templates**

```bash
git add app/views/organisations/index.turbo_stream.erb app/views/organisations/index.turbo_frame.erb app/views/organisations/_infinite_pager.html.erb app/controllers/organisations_controller.rb
git commit -m "feat: stream organisations infinite-scroll batches"
```

## Task 5: System specs for real user behavior

**Files:**

- Create: `spec/system/organisations_infinite_scroll_spec.rb`
- Test: `spec/system/organisations_infinite_scroll_spec.rb`

- [ ] **Step 1: Write failing system spec for auto phase**

Validate:

- starts with `org-page-1`
- auto-load reaches pages 2, 3, 4 without button click
- `Load more` is absent before manual threshold

- [ ] **Step 2: Write failing system spec for manual phase + URL stability**

Validate:

- `Load more` appears for page 5+
- click appends next page
- `current_url` unchanged during auto/manual loads

- [ ] **Step 3: Write failing system spec for retry UI**

Validate:

- failed incremental load shows `Try again`
- clicking `Try again` successfully loads next page once backend recovers

- [ ] **Step 4: Run system specs**

Run: `bundle exec rspec spec/system/organisations_infinite_scroll_spec.rb`  
Expected: FAIL initially; PASS after implementation refinements.

- [ ] **Step 5: Commit system specs**

```bash
git add spec/system/organisations_infinite_scroll_spec.rb
git commit -m "test: cover organisations infinite-scroll browser behavior"
```

## Task 6: Final verification

**Files:**

- Modify: any touched files from previous tasks
- Test: request + system specs

- [ ] **Step 1: Run full targeted suite**

Run:

- `bundle exec rspec spec/requests/organisations_infinite_scroll_spec.rb`
- `bundle exec rspec spec/system/organisations_infinite_scroll_spec.rb`

Expected: PASS.

- [ ] **Step 2: Run lint on touched Ruby files**

Run:

- `bundle exec rubocop app/controllers/organisations_controller.rb app/models/concerns/nameable.rb spec/requests/organisations_infinite_scroll_spec.rb spec/system/organisations_infinite_scroll_spec.rb`

Expected: no new offenses in touched files.

- [ ] **Step 3: Manual smoke check**

Verify in browser:

- no numbered pagination on `/organisations`
- pages 2-4 load automatically
- page 5+ requires `Load more`
- stale/out-of-range does not append duplicates
- retry flow shows `Try again` and recovers
- URL does not change while loading

- [ ] **Step 4: Final commit**

```bash
git add app/controllers/organisations_controller.rb app/models/concerns/nameable.rb app/views/organisations/index.html.erb app/views/organisations/_organisation_tiles.html.erb app/views/organisations/_infinite_pager.html.erb app/views/organisations/index.turbo_stream.erb spec/requests/organisations_infinite_scroll_spec.rb spec/system/organisations_infinite_scroll_spec.rb
git commit -m "feat: add turbo infinite scrolling for organisations index"
```
