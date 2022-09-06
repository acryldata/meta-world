# CaKE

Catalog and Knowledge Explorer app built with Electron

## Usage

Build the installer specific to your platform and Datahub configurations as outlined in the configuration and build section below

To search on specific keywords, select the keyword, copy it to clipboard using `Ctrl/Cmd+C`. Thin hit `Ctrl/Cmd+Shift+A` as the hotkey to launch the search.

### Configuration

Set following variables in `app/js/app.js`:

```javascript
const NOT_FOUND_EMAIL = "DATAGOVERNANCETEAM@YOURCOMPANY.COM";

const DATAHUB_URL = "https://your.datahub.homeurl";
const GRAPHQL_URL = "https://your.datahub.homeurl/api/graphql";
// with auth token it will be GRAPHQL_URL will be like
//   "https://your.datahub.homeurl/api/v2/graphql";
```

### Build

```
npm run package-mac
npm run package-win
npm run package-linux
```

## For Development

### Install Dependencies

```
npm install
```

### Run

```
npm start
```

## Next steps for improvement

### Immediate

1. Streamline Authentication: Currently CaKE uses the internal GraphQL endpoint and `"X-DataHub-Actor"` header to simplify authentication. Both of this may not be preffered for a production deployment. There are a couple of approaches to resolve this -

   - Have users logon to datahub onetime in CaKE and use `PLAY_SESSION` cookie for further calls.
   - Have users use a API token from Datahub.
   - Levarage SSO is available.

2. Provide user preference pane to customize and store a user defined hotkey.

### Future

1. Multiple tabs for other content apart from glossary.

## LICENSE

Apache-2.0
