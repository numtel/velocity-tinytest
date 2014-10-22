Package.describe({
  name: 'numtel:velocity-tinytest',
  summary: 'Use Tinytest with Velocity',
  version: '0.0.37',
  git: 'https://github.com/numtel/velocity-tinytest.git'
});

Npm.depends({
  'mkdirp': '0.5.0'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.imply('tinytest');
  api.use('coffeescript');
  api.use('numtel:phantomjs-persistent-server@0.0.8');
  api.use('velocity:core@0.2.15', 'server');
  api.addFiles('test/sample.js', 'server', {isAsset: true});
  api.addFiles('lib/runner.coffee');
  api.addFiles('lib/server.coffee', 'server');
});
