Picombo::Event.add('system.display') do
	Picombo::Stache::Bench_Footer.new.output
end