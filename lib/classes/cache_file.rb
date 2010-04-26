module Picombo
	class Cache_File
		@@config = nil

		def initialize(config)
			@@config = config
			raise "Cache directory does not exist: "+APPPATH+'cache' unless File.directory?(APPPATH+'cache/')
			raise "Cache directory not writable: "+APPPATH+'cache' unless File.writable?(APPPATH+'cache/')
		end

		def exists(keys)
			return Dir.glob(APPPATH+'cache/*~*') if keys == true

			paths = []
			[*keys].each do |key|
				Dir.glob(APPPATH+'cache/'+key.to_s+'~*').each do |path|
					paths.push(path)
				end
			end

			paths.uniq
		end

		def set(items, lifetime)
			lifetime+=Time.now.to_i

			success = true

			items.each do |key, value|
				delete(key)

				File.open(APPPATH+'cache/'+key.to_s+'~'+lifetime.to_s, 'w') {|f| f.write(Marshal.dump(value)) }
			end

			return true
		end

		def get(keys, single = false)
			items = []

			exists(keys).each do |file|
				if expired(file)
					next
				end

				contents = ''
				File.open(file, "r") do |infile|
					while (line = infile.gets)
						contents+=line+"\n"
					end
				end
				items.push(Marshal.load(contents))
			end
			items.uniq!

			if single
				return items.length > 0 ? items.shift : nil
			else
				return items
			end
		end

		def delete(keys)
			exists(keys).each do |file|
				File.unlink(file)
			end
		end

		def delete_all
			exists(true).each do |file|
				File.unlink(file)
			end
		end

		def expired(file)
			expires = file[file.index('~') + 1, file.length]
			return (expires != 0 and expires.to_i <= Time.now.to_i);
		end
	end
end