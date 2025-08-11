// TODO: update this path
const startWebhookListener = require('./webhookListener');

// TODO: use a real config
const config = {
  secret: 'your_webhook_secret_here',
  repoPath: '/home/pi/yourrepo',
  port: 5000,
  routePath: '/webhook',
};

startWebhookListener(config);

// Eventually, you'll run this with `node server.js`