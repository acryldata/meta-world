const { ipcRenderer } = require("electron");

// Set this up first
const NOT_FOUND_EMAIL = "DATAGOVERNANCETEAM@YOURCOMPANY.COM"

const DATAHUB_URL = "https://your.datahub.homeurl";
const GRAPHQL_URL = "https://your.datahub.homeurl/api/graphql";
// with auth token it will be GRAPHQL_URL will be like
//   "https://your.datahub.homeurl/api/v2/graphql";


const clipb = document.getElementById("clipb");

addCard = (resItem) => {
    const name = resItem['entity']['properties']['name'];
    const desc = resItem['entity']['properties']['description'];
    const urn = resItem['entity']['urn']

    const card = document.createElement("div");
    card.className = "card";

    const header = document.createElement("div");
    header.classList = "card-header bg-primary bg-gradient text-white";
    const htx = document.createTextNode(name)
    header.appendChild(htx)
    card.appendChild(header)

    const cardBody = document.createElement("div");
    cardBody.className = "card-body";
    card.appendChild(cardBody);
    const p = document.createElement("p")
    p.className = "card-text"
    const tx = document.createTextNode(desc);
    p.appendChild(tx);
    cardBody.appendChild(p)
    // <button type="button" class="btn btn-secondary btn-sm">Small button</button>
    button = document.createElement("a");
    button.classList = "btn btn-outline-secondary btn-sm";
    button.setAttribute("href", DATAHUB_URL + "/glossaryTerm/" + urn);
    document.addEventListener
    const lm = document.createTextNode("Learn more...")
    button.appendChild(lm);
    cardBody.appendChild(button);

    const sr = document.getElementById("searchRes");
    const row = document.createElement("div");
    row.classList = "m-2";
    row.appendChild(card)
    sr.appendChild(row)
}
notfound = (word) => {
    const card = document.createElement("div");
    card.className = "card";

    const header = document.createElement("div");
    header.classList = "card-header bg-secondary bg-gradient text-white";
    const htx = document.createTextNode("Sorry!! No CaKE slices 🍰 for you!! 😭")
    header.appendChild(htx)
    card.appendChild(header)

    const cardBody = document.createElement("div");
    cardBody.className = "card-body";
    card.appendChild(cardBody);
    const p = document.createElement("p")
    p.className = "card-text"
    const tx = document.createTextNode("No satisfactory matches found while searching for " + word);
    p.appendChild(tx);
    cardBody.appendChild(p)

    button = document.createElement("a");
    button.classList = "btn btn-outline-success btn-sm";
    button.setAttribute("href", "mailto:" + NOT_FOUND_EMAIL + "?subject=Definition requested for: " + word);
    document.addEventListener
    const lm = document.createTextNode("Request Definition")
    button.appendChild(lm);
    cardBody.appendChild(button);

    const sr = document.getElementById("searchRes");
    const row = document.createElement("div");
    row.classList = "m-2";
    row.appendChild(card)
    sr.appendChild(row)
}

ipcRenderer.on("search", (e, word, username) => {
  clipb.innerText = "Search on: " + word;
  clipb.classList = "bg-dark bg-gradient text-white p-2"
  let element = document.getElementById("searchRes");
while (element.firstChild) {
  element.removeChild(element.firstChild);
}

  let body = {
    operationName: "getSearchResultsForMultiple",
    variables: {
      input: {
        types: ["GLOSSARY_TERM"],
        query: word,
        start: 0,
        count: 5,
        filters: [],
      },
    },
    query:
      "query getSearchResultsForMultiple($input: SearchAcrossEntitiesInput!) {searchAcrossEntities(input: $input) {...searchResults __typename } } fragment searchResults on SearchResults {start count total searchResults {entity {...searchResultFields __typename } matchedFields {name value __typename } insights {text icon __typename } __typename } __typename } fragment searchResultFields on Entity {urn type ... on Dataset {name origin uri properties {name description qualifiedName customProperties {key value __typename } __typename } glossaryTerms {...glossaryTerms __typename } editableProperties {description __typename } } ... on GlossaryTerm {name hierarchicalName properties {name description termSource sourceRef sourceUrl rawSchema customProperties {key value __typename } __typename } __typename } } fragment glossaryTerms on GlossaryTerms {terms {term {urn name properties {name __typename } __typename } __typename } __typename }",
  };
  jbody = JSON.stringify(body);


  let headers = {
    "Content-Length": jbody.length,
    "X-DataHub-Actor" : "urn:li:corpuser:" + username,
    "Content-Type": "application/json",
    // Authorization:
    //   "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhY3RvclR5cGUiOiJVU0VSIiwiYWN0b3JJZCI6IjQzMDAxNDE4MyIsInR5cGUiOiJQRVJTT05BTCIsInZlcnNpb24iOiIxIiwiZXhwIjoxNjU5NDgzODEwLCJqdGkiOiI2YjZhN2RiNi04OWZjLTQyZWUtODRjYS0xNTg0OTQxMDZhNWEiLCJzdWIiOiI0MzAwMTQxODMiLCJpc3MiOiJkYXRhaHViLW1ldGFkYXRhLXNlcnZpY2UifQ.WADf7DPB8uSSzR8q_xYo6uHvr2J2Ha4eUpjWqVzJoXw",
  };

  fetch(GRAPHQL_URL, { method: "POST", headers: headers, body: jbody })
    .then((response) => response.json())
    .then((data) => {
      const results =
        data["data"]["searchAcrossEntities"]["searchResults"];
    if (data["data"]["searchAcrossEntities"]["total"] > 0) {
            results.map(x=> addCard(x));
        }
    else {
        notfound(word);
    }
    });
});
