const startWebhookListener = require("../../../webhook-listener/server.js");

const config = {
  secret: "the-big-secret",
  repoPath: "/pi-ingredients",
  port: 5000,
  routePath: "/webhook",
};

startWebhookListener(config);
