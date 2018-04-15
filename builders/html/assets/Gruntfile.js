module.exports = function(grunt) {
	// load all grunt tasks
	require('load-grunt-tasks')(grunt);

	grunt.registerTask( 'default', [ 'concat:base', 'uglify:base', 'sass:base', 'cssmin:base' ] );

	var _version = 19;

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

		watch: {
			base: {
				files: ['js/src/*.js', 'sass/**/*.scss'],
				tasks: ['concat:base', 'uglify:base', 'sass:base', 'cssmin:base']
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