module.exports = function(grunt) {
	// load all grunt tasks
	require('load-grunt-tasks')(grunt);

	grunt.registerTask( 'default', [ 'concat:base', 'uglify:base', 'sass:base', 'sassUnicode:base', 'cssmin:base', 'copy:base'] );


	var _version = 36; // update in Application.cfc(s) too assetBundleVersion

	// grunt config
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),

		concat: {
			base: {
				src: ['js/jquery-3.3.1.js','js/hammer.js', 'js/src/*.js'],
				dest: 'js/base.js',
				nonull: true
			},
			options : {
				sourceMap :true
			}
		},
		sass: {
			base: {
				files: [{
					cwd: 'sass/',
					dest: 'css/',
					expand: true,
					ext: '.css',
					src: ['*.scss']
				}],
				options: {
					sourcemap: 'auto',
					style: 'expanded'
				}
			}
		},
		// see https://stackoverflow.com/questions/25488037/sass-compile-fontawesome-preserve-notation
		sassUnicode: {
			base: {
				files: {
					'css/base.css': 'css/base.css'
				}
			}
		},
		cssmin: {
			base: {
				src: ['css/base.css'],
				dest: 'css/base.min.css'
			},
			options: {
				sourcemap: true,
				format: {
					wrapAt: 150
				}
			}
		},
		uglify: {
			base: {
				files: {
					['js/dist/base.' + _version + '.min.js']: ['js/base.js']
				}
			},
			options: {
				output: {
					max_line_len: 150
				}
			}
		},
		copy: {
			base: {
				files: {
					['css/base.' + _version + '.min.css'] : 'css/base.min.css'
				}
			}
		},
		watch: {
			base: {
				files: ['js/src/*.js', 'sass/**/*.scss'],
				tasks: ['concat:base', 'uglify:base', 'sass:base', 'sassUnicode:base', 'cssmin:base']
			}
		},

		// dev update
		devUpdate: {
			main: {
				options: {
					semver: false,
					updateType: 'prompt'
				}
			}
		}
	});
};