"use strict";

function handler(event) {
  var response = event.response;
  var headers = response.headers;

  headers["strict-transport-security"] = {
    value: "max-age=63072000;includeSubdomains;preload",
  };

  headers["x-content-type-options"] = {
    value: "nosniff",
  };

  headers["x-xss-protection"] = { value: "1;mode=block" };

  headers["referrer-policy"] = { value: "same-origin" };

  return response;
}
