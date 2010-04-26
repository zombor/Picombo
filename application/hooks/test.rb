Picombo::Event.add('system.post_router') do |data|
	data.merge!({:params => ['test', 'test', 'test']})
end