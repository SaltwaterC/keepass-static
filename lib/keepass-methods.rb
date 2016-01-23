module Keepass
  # KeePass Database class
  class Database
    def group(name)
      gr = groups.select { |g| g.name == name }
      fail "Error: found multiple groups with name #{name}" if gr.length > 1
      gr[0]
    end

    def entry(title, name = nil)
      if name.nil?
        ent = simple_select title
      else
        ent = double_select title, name
      end
      ent[0]
    end

    private

    def simple_select(title)
      ent = entries.select { |e| e.title == title }
      fail "Error: found multiple entries with title #{title}" if ent.length > 1
      ent
    end

    def double_select(title, name)
      ent = group(name).entries.select { |e| e.title == title }
      if ent.length > 1
        fail "Error: found multiple entries with title #{title} for "\
          "group #{name}"
      end
      return ent
    rescue NoMethodError # if the group doesn't exist
      return []
    end
  end
end
