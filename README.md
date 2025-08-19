# LittleURL (TinyURL Clone)

A simple URL shortener built with **Ruby on Rails 8.0.2** and **Ruby 3.4.5**, designed with clean architecture and good practices.  
It allows users (even without registration) to shorten URLs, customize their tokens, track visits by IP, and manage their own links via a browser session.

---

## Features

- Shorten any valid HTTP/HTTPS URL.
- Custom token support (user decides the short code).
- Token uniqueness validation (case-insensitive, reserved words restricted).
- Track visits with IP, user-agent, and timestamp.
- List all URLs created by a user (identified via permanent signed cookie).
- Edit or delete individual URLs.
- Copy the link with a button or getting a QR code.
- Bulk delete all URLs created by a user.
- Redirect using a short token (e.g., `http://localhost:3000/abc123`).

---

## Requirements

- Ruby 3.4.5
- Rails 8.0.2
- PostgreSQL 14+
- Git

---

## Installation

1. **Clone the repository**

   ```bash
   git clone git@github.com:jwaldimer/littleurl.git
   cd littleurl
   ```

2. **Install Ruby dependencies**

   ```bash
   bundle install
   ```

3. **Setup the database**

   Make sure PostgreSQL is running and a database is available.

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the Rails server**

   ```bash
   rails s
   ```

   The app will be available at [http://localhost:3000](http://localhost:3000).

---

## Usage

- Open the root page (`/`) to create a new shortened URL.
- Enter the **original URL**, choose a **custom token**, and optionally add a description.
- After creation, you will see your list of URLs.
- Each LittleURL entry provides:
  - The shortened link.
  - The original URL.
  - The description.
  - The creation time.
  - A **Visit URL** button to use the LittleURL.
  - A **Copy** button to copy the link.
  - A **QR code** for easy sharing.
  - Options to **Edit** or **Delete**.
- You can also delete all your URLs at once.

---

## Endpoints

### Root
- **GET /** → Renders the URL creation form and lists your URLs.

### LittleUrls
- **POST /little_urls** → Create a new shortened URL.  
  Params: `original_url`, `token`, `description`.
- **GET /little_urls/:id/edit** → Edit form for a URL.
- **PATCH/PUT /little_urls/:id** → Update a URL.
- **DELETE /little_urls/:id** → Delete a single URL.
- **DELETE /little_urls/destroy_all** → Delete all URLs created by the current user.

### Redirects
- **GET /:id** → Redirect to the original URL associated with the token or slug.  
  Example: `GET /bootstrap` → Redirects permanently (301) to `https://getbootstrap.com/`.

---

## Tests

The project uses **RSpec** and the **interactor** gem. To run the test suite:

```bash
bundle exec rspec
```

---

## Notes

- Users are identified via a permanent signed cookie (`creator_id`).
- Tokens must be unique (case-insensitive), 5–50 characters, and may contain only letters, numbers, dashes, and underscores.
- Certain reserved tokens (e.g., `admin`, `login`, `api`) cannot be used.

---

## Author

Developed by Jorge Gómez [@jwaldimer](https://github.com/jwaldimer) as part of a technical assessment for PlayByPoint.

---

## License

This project is open source. Feel free to fork and improve it.
