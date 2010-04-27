Gem::Specification.new do |s|
  s.name = %q{picombo}
  s.version = "0.2.0"
  s.date = %q{2010-04-26}
  s.authors = ["Jeremy Bush"]
  s.email = %q{contractfrombelow@gmail.com}
  s.summary = %q{A lightweight MVC web framework}
  s.homepage = %q{http://www.picombo.net/}
  s.description = %q{Picombo is a lightweight MVC framework inspired by the Kohana PHP MVC framework.}
  s.files = [ 
	'lib/picombo.rb',
	'lib/classes/bench.rb',
	'lib/classes/cache.rb',
	'lib/classes/cache_file.rb',
	'lib/classes/config.rb',
	'lib/classes/cookie.rb',
	'lib/classes/e404.rb',
	'lib/classes/event.rb',
	'lib/classes/html.rb',
	'lib/classes/input.rb',
	'lib/classes/log.rb',
	'lib/classes/router.rb',
	'lib/classes/security.rb',
	'lib/classes/session.rb',
	'lib/classes/url.rb',
	'lib/classes/view/xml.rb',
	'lib/classes/view.rb',
	'lib/config/cache.yaml',
	'lib/config/log.yaml',
	'lib/config/mimes.yaml',
	'lib/config/routes.yaml',
	'lib/controllers/error_404.rb',
	'lib/controllers/template.rb',
	'lib/core/core.rb',
	'lib/hooks/datamapper.rb',
	'lib/hooks/profiler.rb',
	'lib/views/404.rhtml',
	'lib/views/bench/footer.rhtml']
end