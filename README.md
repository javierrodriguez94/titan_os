# Titan OS — Catalog API

Small Rails API that models a media catalog (movies, TV shows, seasons, episodes) and
exposes one public endpoint to show the contents of a list, in order, paginated and optionally filtered by content type.

## Stack

- Ruby 3.4.10, Rails 8.1.3 (API-only)
- PostgreSQL
- Minitest + FactoryBot for tests, SimpleCov for coverage
- Rubocop with `rubocop-rails-omakase` 

## Running it with Docker

```
docker compose up
```

This builds the app image, starts Postgres, creates and migrates the database, and boots
the server. The API is available at `http://localhost:3001`.

Ports are shifted by one (`3001` instead of `3000` and `5433` instead of `5432`) to avoid
crashing with anything already running locally on the default ports.

There are two Dockerfiles on purpose:
- `Dockerfile` is the one `rails new` generates — oriented to production envs, multi-stage, without
  dev/test gems. It is untouched and not wired into `docker-compose.yml`; I kept it since
  it is the standard Rails deploy image
- `Dockerfile.dev` is what `docker-compose.yml` actually builds — an image with
  the full Gemfile (including test tooling), were you
  can edit code without rebuilding.

## Running it without Docker

Ruby 3.4.10 and a local PostgreSQL instance needed.

```
bundle install
bin/rails db:create db:migrate
bin/rails server
```

The API is available at `http://localhost:3000`.

## Tests

```
bin/rails test
```

Rubocop:

```
bundle exec rubocop
```

Coverage report:

Every test run regenerates `coverage/index.html`. It's a small JS app, probably you need this small server to see the content properly:

```
ruby -run -e httpd coverage -p 3002
```

and open `http://localhost:3002`.

## The API

```
GET /api/v1/lists/:id
```

Query params (all optional):
- `content_type` should be `movie`, `tv_show`, `season` or `episode`. Narrows the list to that
  type while keeping the order. Anything else returns `422`.
- `page` defaults to `1`.
- `per_page` defaults to `20`, capped at `100`.

Response:

```json
{
  "list": { "id": 1, "name": "Best of 2020" },
  "items": [
    {
      "type": "Movie",
      "position": 1,
      "content": { "id": 5, "title": "Inception", "original_title": "Inception", "year": 2010 }
    },
    {
      "type": "Season",
      "position": 2,
      "content": { "id": 3, "title": "Season 1", "original_title": "Season 1", "year": 2011, "number": 1, "tv_show_id": 7 }
    }
  ],
  "pagination": { "page": 1, "per_page": 20, "total_pages": 3, "total_count": 45 }
}
```

`type` says what `content` is. A missing list returns `404`; everything else that goes wrong returns `422`. Errors
are like `{ "error": "<message>" }`.

## Design decisions

**Separate tables per content type** The content types `Movie`, `TvShow`, `Season` and `Episode`
has their own table. A shared `Content` concern holds the common fields (`title`, `original_title`, `year`)
validations and normalization, so there is no duplication without forcing every type into one table.

**Lists are polymorphic through a join table** `list_items` has `content_type`,
`content_id` and a `position` column that defines the
list's own order. Position is unique per list, because the
list defines a single sequence, not one sequence per content type.

**Pagination with page/per_page** Is a small API and it's easy to implement the pagination so I decided to implement it instead of adding dependencies with gems implenting it.
Cursor pagination is not needed

**Thin controllers** `Api::V1::ListsController#show` whitelists params, calls
`ListContentFetcher`, hands the result to `ListContentPresenter`. The actual logic resolving `content_type`, filtering, ordering and paginating is in the service. The
presenter generates the JSON for the response


## Known gaps

**No rate limiting.** The endpoint is public and unauthenticated as specification mentions, but nothing currently throttles it. would be nice to add `rack-attack` before this went anywhere near production.

