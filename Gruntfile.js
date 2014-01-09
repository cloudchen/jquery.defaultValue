module.exports = function(grunt) {
  'use strict';

  require('time-grunt')(grunt);
  require('load-grunt-tasks')(grunt);

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    // Task configuration.
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      source: {
        src: ['Gruntfile.js', 'src/**/*.js']
      },
      spec: {
        options: {
          jshintrc: 'test/.jshintrc'
        },
        src: ['test/spec/**/*.js']
      }
    },
    clean: {
        src: ['coverage/', 'dist/']
    },
    karma: {
      options: {
        configFile: 'karma.conf.js'
      },
      ci: {
        singleRun: true,
        browsers: ['PhantomJS']
      },
      dev: {
        reporters: ['dots', 'coverage']
      }
    },
    requirejs: {
      options: {
        baseUrl: 'src',
        skipModuleInsertion: true,
        wrap: {
          start: ['<%=banner%>',
                  '(function (factory) {',
                  '  if (typeof define === \'function\' && define.amd) {',
                  '    define([\'jquery\'], function(jQuery){',
                  '      factory(jQuery);',
                  '      return jQuery;',
                  '    });',
                  '  } else {',
                  '    factory(window.jQuery);',
                  '  }',
                  '}(function(jQuery){'
                 ].join('\n'),
          end:    '}));'
        },
        include: ['<%= pkg.name%>'],
      },
      development: {
        options: {
          optimize: 'none',
          out: 'dist/<%= pkg.name%>.js',
        }
      },
      production: {
        options: {
          out: 'dist/<%= pkg.name%>.min.js',
        }
      }
    }
  });

  // Default task.
  grunt.registerTask('default', [
    'test',
    'build'
  ]);

  grunt.registerTask('test', [
    'jshint',
    'karma:ci',
  ]);

  grunt.registerTask('build', [
    'clean',
    'requirejs',
  ]);
};
