Gem::Specification.new do |s|
  s.name = %q{picombo}
  s.version = "0.3.0"
  s.date = %q{2010-06-15}
  s.authors = ["Jeremy Bush"]
  s.email = %q{contractfrombelow@gmail.com}
  s.summary = %q{A lightweight MVC web framework}
  s.homepage = %q{http://www.picombo.net/}
  s.description = %q{Picombo is a lightweight MVC web framework that enables you to create websites quickly.}
  s.add_dependency('rack', '>= 1.0.0')
  s.add_dependency('mustache', '>= 0.10.0')
  s.files = [ 
	'./lib/classes/bench.rb',
	'./lib/classes/cache/file.rb',
	'./lib/classes/cache.rb',
	'./lib/classes/config.rb',
	'./lib/classes/cookie.rb',
	'./lib/classes/e404.rb',
	'./lib/classes/event.rb',
	'./lib/classes/html.rb',
	'./lib/classes/input.rb',
	'./lib/classes/log.rb',
	'./lib/classes/router.rb',
	'./lib/classes/session.rb',
	'./lib/classes/url.rb',
	'./lib/config/cache.yaml',
	'./lib/config/log.yaml',
	'./lib/config/mimes.yaml',
	'./lib/config/routes.rb',
	'./lib/controllers/error/404.rb',
	'./lib/controllers/template.rb',
	'./lib/core/core.rb',
	'./lib/core/core_cli.rb',
	'./lib/hooks/mustache.rb',
	'./lib/hooks/profiler.rb',
	'./lib/picombo.rb',
	'./lib/views/error/404.mustache',
	'./lib/views/error/404.rb']
end
