Picombo::Event.add('system.display') do
	Picombo::View::Core.new('bench/footer').render()
end