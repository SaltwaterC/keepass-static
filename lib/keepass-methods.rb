module Keepass
  # KeePass Database class
  class Database
    def group(name)
      gr = groups.select { |g| g.name == name }
      raise "Error: found multiple groups with name #{name}" if gr.length > 1
      gr[0]
    end

    def entry(title, name = nil)
      ent = if name.nil?
              simple_select title
            else
              double_select title, name
            end

      ent[0]
    end

    private

    def simple_select(title)
      ent = entries.select { |e| e.title == title }

      if ent.length > 1
        raise "Error: found multiple entries with title #{title}"
      end

      ent
    end

    def double_select(title, name)
      ent = group(name).entries.select { |e| e.title == title }
      if ent.length > 1
        raise "Error: found multiple entries with title #{title} for "\
          "group #{name}"
      end
      return ent
    rescue NoMethodError # if the group doesn't exist
      return []
    end
  end
end
