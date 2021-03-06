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
      ' Licensed <%= pkg.license %> */\n',
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
    coffeelint: {
      options: {
        'max_line_length': {
            'name': 'max_line_length',
            'value': 100,
            'level': 'error',
            'limitComments': true
        },
      },
      spec: ['test/spec/**/*.coffee']
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
    'jsbeautifier' : {
      'source': {
        src: ['src/**/*.js'],
        options : {
          config: '.jsbeautifyrc'
        }
      },
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
    },
    coveralls: {
      basicTest: {
        src: 'coverage/**/*.info'
      },
    },
    bump: {
      options: {
        files: ['package.json', 'bower.json', 'defaultValue.jquery.json'],
        push: false,
        pushTo: 'origin'
      }
    }
  });

  // Default task.
  grunt.registerTask('default', [
    'test',
    'build'
  ]);

  grunt.registerTask('lint', [
    'jshint',
    'coffeelint'
  ]);

  grunt.registerTask('test', [
    'lint',
    'karma:ci',
  ]);

  grunt.registerTask('build', [
    'clean',
    'requirejs',
  ]);
};
