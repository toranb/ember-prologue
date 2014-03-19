module.exports = function(config) {
  config.set({
    frameworks: ['qunit', 'qunit-sb'],
    browsers: ['PhantomJS'],
    files: [
      'overture/static/overture/js/lib/scripts.min.js',
    ],
    logLevel: config.LOG_ERROR,
    autoWatch: false,
    singleRun: true
  });
};
